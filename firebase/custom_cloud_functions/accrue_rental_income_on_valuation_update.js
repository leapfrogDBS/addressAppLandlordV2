// FlutterFlow-friendly: do NOT call admin.initializeApp() here.
const functions = require("firebase-functions");
const admin = require("firebase-admin");

// ───────────────────────── CONFIG ─────────────────────────
const REGION = "us-central1";
const LONDON_TZ = "Europe/London";
const RENT_PAYMENTS_COLLECTION = "rentPayments";
const EXPENSES_COLLECTION = "expenses";

exports.accrueRentalIncomeOnValuationUpdate = functions
  .region(REGION)
  .runWith({ memory: "256MB", timeoutSeconds: 120 })
  .firestore.document("properties/{propertyId}")
  .onUpdate(async (change, context) => {
    const propertyId = context.params.propertyId;
    const before = change.before.data() || {};
    const after = change.after.data() || {};

    // Only react to estimatedValue changes (normalise number-ish values)
    const normNum = (v) => {
      if (v == null) return null;
      if (typeof v === "number") return v;
      if (typeof v === "string") {
        const x = Number(v);
        return Number.isFinite(x) ? x : null;
      }
      return null;
    };

    if (normNum(before.estimatedValue) === normNum(after.estimatedValue)) {
      return null;
    }

    const db = admin.firestore();

    try {
      const result = await accrueRentalIncomeForProperty({ db, propertyId });
      functions.logger.info("Accrual result", { propertyId, ...result });
    } catch (err) {
      // Background trigger: log only to avoid retries spiralling
      functions.logger.error("Accrual failed", {
        propertyId,
        error: err && err.message ? err.message : String(err),
      });
    }

    return null;
  });

// ───────────────────────── CORE ACCRUAL ─────────────────────────

async function accrueRentalIncomeForProperty({ db, propertyId }) {
  const propRef = db.collection("properties").doc(propertyId);

  const propSnap = await propRef.get();
  if (!propSnap.exists) throw new Error("Property not found");

  const p = propSnap.data() || {};
  const now = new Date();

  // The "current cycle start" (anniversary start) for today in London time
  const currentPeriodStartTs = resolveCurrentPeriodStartTs(p, now);

  // Decide + initialise in a transaction (prevents races & double-counting)
  const decision = await db.runTransaction(async (t) => {
    const snap = await t.get(propRef);
    if (!snap.exists) return { action: "missing_property" };

    const lastStart = snap.get("lastAccruedPeriodStart") || null;

    // Initialise older/test properties (no accrual on init)
    if (!lastStart || typeof lastStart.toMillis !== "function") {
      const prevRent = snap.get("previousRentalIncome");
      const prevRentNum =
        typeof prevRent === "number" && Number.isFinite(prevRent)
          ? prevRent
          : 0;

      const prevExp = snap.get("previousExpenses");
      const prevExpNum =
        typeof prevExp === "number" && Number.isFinite(prevExp) ? prevExp : 0;

      t.update(propRef, {
        lastAccruedPeriodStart: currentPeriodStartTs,
        lastAccruedRentalAmount: 0,
        lastAccruedExpenseAmount: 0,
        lastAccruedAt: admin.firestore.FieldValue.serverTimestamp(),
        previousRentalIncome: prevRentNum,
        previousExpenses: prevExpNum,
      });

      return {
        action: "initialised",
        currentPeriodStart: currentPeriodStartTs.toDate().toISOString(),
        previousRentalIncome: prevRentNum,
        previousExpenses: prevExpNum,
      };
    }

    const lastMs = lastStart.toMillis();
    const currentMs = currentPeriodStartTs.toMillis();

    // If we haven't crossed into a new property-year cycle, do nothing
    if (lastMs >= currentMs) {
      return {
        action: "noop",
        lastAccruedPeriodStart: lastStart.toDate().toISOString(),
        currentPeriodStart: currentPeriodStartTs.toDate().toISOString(),
      };
    }

    // We *have* crossed at least one cycle boundary since last accrual
    return { action: "accrue", lastMs, currentMs };
  });

  if (decision.action !== "accrue") return decision;

  const fromTs = admin.firestore.Timestamp.fromMillis(decision.lastMs);
  const toTs = admin.firestore.Timestamp.fromMillis(decision.currentMs);

  // Sum rent + expenses for the elapsed period(s): [from, to)
  const rentSum = await sumRentPaymentsBetween({
    db,
    propertyId,
    fromTs,
    toTs,
  });
  const expenseSum = await sumExpensesBetween({ db, propertyId, fromTs, toTs });

  // Apply update with an idempotency guard:
  // only update if lastAccruedPeriodStart is still exactly what we used.
  await db.runTransaction(async (t) => {
    const snap = await t.get(propRef);
    if (!snap.exists) return;

    const lastStart = snap.get("lastAccruedPeriodStart") || null;
    if (!lastStart || typeof lastStart.toMillis !== "function") return;

    // If another execution already advanced it, skip (prevents double counting)
    if (lastStart.toMillis() !== decision.lastMs) return;

    const prevRent = snap.get("previousRentalIncome");
    const prevRentNum =
      typeof prevRent === "number" && Number.isFinite(prevRent) ? prevRent : 0;

    const prevExp = snap.get("previousExpenses");
    const prevExpNum =
      typeof prevExp === "number" && Number.isFinite(prevExp) ? prevExp : 0;

    const nextPrevRent = round2(prevRentNum + rentSum.sum);
    const nextPrevExp = round2(prevExpNum + expenseSum.sum);

    t.update(propRef, {
      previousRentalIncome: nextPrevRent,
      previousExpenses: nextPrevExp,

      lastAccruedPeriodStart: toTs,

      // Debug-friendly fields
      lastAccruedRentalAmount: rentSum.sum,
      lastAccruedExpenseAmount: expenseSum.sum,

      lastAccruedAt: admin.firestore.FieldValue.serverTimestamp(),

      // Poke recalc (same pattern as your onRentOverrideWritepoke)
      _recalcTrigger: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

  return {
    action: "accrued",
    periodFrom: fromTs.toDate().toISOString(),
    periodTo: toTs.toDate().toISOString(),
    rentPaymentsCount: rentSum.count,
    rentAccruedAmount: rentSum.sum,
    expensesCount: expenseSum.count,
    expensesAccruedAmount: expenseSum.sum,
  };
}

// ───────────────────────── SUM PAYMENTS ─────────────────────────
// NOTE: These queries will likely require composite indexes on:
// rentPayments(propertyId ASC, occurredAt ASC)
// expenses(propertyId ASC, occurredAt ASC)
// Firebase will give you a link to create them if needed.

async function sumRentPaymentsBetween({ db, propertyId, fromTs, toTs }) {
  let total = 0;
  let count = 0;
  let lastDoc = null;

  while (true) {
    let q = db
      .collection(RENT_PAYMENTS_COLLECTION)
      .where("propertyId", "==", propertyId)
      .where("occurredAt", ">=", fromTs)
      .where("occurredAt", "<", toTs)
      .orderBy("occurredAt", "asc")
      .limit(500);

    if (lastDoc) q = q.startAfter(lastDoc);

    const snap = await q.get();
    if (snap.empty) break;

    for (const doc of snap.docs) {
      const amtRaw = doc.get("amount");
      const amt = typeof amtRaw === "number" ? amtRaw : Number(amtRaw);
      if (Number.isFinite(amt)) {
        total += amt;
        count += 1;
      }
    }

    lastDoc = snap.docs[snap.docs.length - 1];
    if (snap.size < 500) break;
  }

  return { sum: round2(total), count };
}

async function sumExpensesBetween({ db, propertyId, fromTs, toTs }) {
  let total = 0;
  let count = 0;
  let lastDoc = null;

  while (true) {
    let q = db
      .collection(EXPENSES_COLLECTION)
      .where("propertyId", "==", propertyId)
      .where("occurredAt", ">=", fromTs)
      .where("occurredAt", "<", toTs)
      .orderBy("occurredAt", "asc")
      .limit(500);

    if (lastDoc) q = q.startAfter(lastDoc);

    const snap = await q.get();
    if (snap.empty) break;

    for (const doc of snap.docs) {
      const amtRaw = doc.get("amount");
      const amt = typeof amtRaw === "number" ? amtRaw : Number(amtRaw);
      if (Number.isFinite(amt)) {
        total += amt;
        count += 1;
      }
    }

    lastDoc = snap.docs[snap.docs.length - 1];
    if (snap.size < 500) break;
  }

  return { sum: round2(total), count };
}

// ───────────────────────── PERIOD START (CURRENT CYCLE) ─────────────────────────

function resolveCurrentPeriodStartTs(propertyData, now) {
  const joinedTs = propertyData.dateJoinedAddressed;

  // Fallback: 1 Jan of the current London year
  const fallbackYMD = { y: ymdInLondon(now).y, m: 1, d: 1 };
  if (!joinedTs || typeof joinedTs.toDate !== "function") {
    return admin.firestore.Timestamp.fromDate(
      londonMidnightAsUTCDate(fallbackYMD),
    );
  }

  // Use join day/month; ignore join year
  const joinYMD = ymdInLondon(joinedTs.toDate());
  const joinMonth = joinYMD.m;
  const joinDay = joinYMD.d;

  const nowYMD = ymdInLondon(now);
  const annThisYear = makeAnniversaryYMD(nowYMD.y, joinMonth, joinDay);

  const startYear = cmpYMD(nowYMD, annThisYear) >= 0 ? nowYMD.y : nowYMD.y - 1;
  const startYMD = makeAnniversaryYMD(startYear, joinMonth, joinDay);

  // Midnight on the anniversary date (London local), represented as a UTC Date
  return admin.firestore.Timestamp.fromDate(londonMidnightAsUTCDate(startYMD));
}

// ───────────────────────── DATE UTILS ─────────────────────────

function ymdInLondon(dateObj) {
  const parts = new Intl.DateTimeFormat("en-GB", {
    timeZone: LONDON_TZ,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(dateObj);

  const get = (type) => Number(parts.find((p) => p.type === type)?.value);
  return { y: get("year"), m: get("month"), d: get("day") };
}

function hmInLondon(dateObj) {
  const parts = new Intl.DateTimeFormat("en-GB", {
    timeZone: LONDON_TZ,
    hour: "2-digit",
    minute: "2-digit",
    hourCycle: "h23",
  }).formatToParts(dateObj);

  const get = (type) => Number(parts.find((p) => p.type === type)?.value);
  return { h: get("hour"), min: get("minute") };
}

function londonMidnightAsUTCDate(ymd) {
  // Start with UTC midnight of that date; if London time at that instant is not 00:00,
  // shift back by the London hh:mm to land on London-local midnight.
  let dt = new Date(Date.UTC(ymd.y, ymd.m - 1, ymd.d, 0, 0, 0));
  const hm = hmInLondon(dt);
  const mins = hm.h * 60 + hm.min;
  if (mins !== 0) dt = new Date(dt.getTime() - mins * 60 * 1000);
  return dt;
}

function cmpYMD(a, b) {
  if (a.y !== b.y) return a.y < b.y ? -1 : 1;
  if (a.m !== b.m) return a.m < b.m ? -1 : 1;
  if (a.d !== b.d) return a.d < b.d ? -1 : 1;
  return 0;
}

function clampDay(year, month1to12, day) {
  const daysInMonth = new Date(Date.UTC(year, month1to12, 0)).getUTCDate();
  return Math.min(day, daysInMonth);
}

function makeAnniversaryYMD(year, joinMonth, joinDay) {
  return { y: year, m: joinMonth, d: clampDay(year, joinMonth, joinDay) };
}

function round2(n) {
  return Math.round(n * 100) / 100;
}
