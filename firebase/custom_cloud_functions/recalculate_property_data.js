// FlutterFlow-friendly: do NOT call admin.initializeApp() here.
const functions = require("firebase-functions");
const admin = require("firebase-admin");

// ───────────────────────── CONFIG ─────────────────────────
const REGION = "us-central1"; // FF default; change only if your FF project is bound elsewhere.

// ───────────────────────── TRIGGERS ─────────────────────────

// Firestore trigger: recompute when relevant property fields change
exports.recalculatePropertyData = functions
  .region(REGION)
  .runWith({ memory: "256MB", timeoutSeconds: 120 })
  .firestore.document("properties/{propertyId}")
  .onUpdate(async (change, context) => {
    const propertyId = context.params.propertyId;
    const before = change.before.data() || {};
    const after = change.after.data() || {};

    const fieldsToWatch = [
      "estimatedValue",
      "averageYearlyExpenses",
      "avgYearlyExpenses",
      "annualExpensesEstimate",
      "expenseInflationPct",
      "expensesInflationPct",
      "purchasePrice",
      "pricePaid",
      "purchase_price",
      "retirementAge",
      "dateOfBirth",
      "previousRentalIncome",
      "previousExpenses",
      "ownerID",
      "ownerId",
      "_recalcTrigger",
      "_recalcRequestId",
    ];

    const changed = fieldsToWatch.some(
      (k) => (before[k] ?? null) !== (after[k] ?? null),
    );
    if (!changed) {
      functions.logger.info("No projection-relevant changes", { propertyId });
      return null;
    }

    const db = admin.firestore();
    const ownerOverride = getOwnerUserIdFromPropertyData(after);
    const requestId =
      (typeof after._recalcRequestId === "string" &&
        after._recalcRequestId.trim()) ||
      (typeof after._recalcTrigger === "string" &&
        after._recalcTrigger.trim()) ||
      null;

    try {
      await computePropertyProjectionCore({
        db,
        propertyId,
        ownerOverride,
        requestId,
      });
    } catch (err) {
      // Log only; background triggers shouldn't throw (avoids retries)
      functions.logger.error("Background projection failed", {
        propertyId,
        error: err && err.message,
      });
    }
    return null;
  });

// HTTPS callable: manual recompute
exports.computePropertyProjection = functions
  .region(REGION)
  .runWith({ memory: "256MB", timeoutSeconds: 120 })
  .https.onCall(async (data, context) => {
    const propertyId = String((data && data.propertyId) || "").trim();
    if (!propertyId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "propertyId is required",
      );
    }
    const ownerOverride =
      (data && typeof data.ownerId === "string" && data.ownerId.trim()) || null;
    const requestId =
      (data && typeof data.requestId === "string" && data.requestId.trim()) ||
      null;

    try {
      await computePropertyProjectionCore({
        db: admin.firestore(),
        propertyId,
        ownerOverride,
        requestId,
      });
      return { ok: true, propertyId };
    } catch (err) {
      functions.logger.error("Callable projection failed", {
        propertyId,
        error: err && err.message,
      });
      throw new functions.https.HttpsError(
        "internal",
        "Projection calculation failed.",
        String(err && err.message),
      );
    }
  });

// ───────────────────── CORE PROJECTION LOGIC ─────────────────────
async function computePropertyProjectionCore(args) {
  const { db, propertyId, ownerOverride, requestId } = args;

  // Load property
  const propRef = db.collection("properties").doc(propertyId);
  const propSnap = await propRef.get();
  if (!propSnap.exists) throw new Error("Property not found");
  const p = propSnap.data() || {};

  // Resolve owner
  const derivedOwnerId = getOwnerUserIdFromPropertyData(p);
  const ownerId =
    (typeof ownerOverride === "string" && ownerOverride.trim()) ||
    derivedOwnerId ||
    null;
  const userRef = ownerId ? db.collection("users").doc(ownerId) : null;

  // START: atomic increment + set flag
  if (userRef) {
    await db.runTransaction(async (t) => {
      const u = await t.get(userRef);
      const cur = Number(u.get("calculatingProjectionsCount") || 0);
      const update = {
        calculatingProjections: true,
        calculatingProjectionsCount: cur + 1,
        lastProjectionStartedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      if (requestId) update.recalcRequestId = requestId;
      t.set(userRef, update, { merge: true });
    });
  }

  try {
    // ==== YOUR PROJECTION MATH (unchanged from your working version) ====

    const startYear = new Date().getFullYear();

    const estimatedValue = num(p.estimatedValue, 0);

    const activeSnap = await propRef
      .collection("tenancies")
      .where("isActive", "==", true)
      .limit(1)
      .get();
    const hasActiveTenancy = !activeSnap.empty;
    let rentPCM = 0;
    if (hasActiveTenancy) {
      rentPCM = num(activeSnap.docs[0].get("rentAmount"), 0);
      if (!Number.isFinite(rentPCM) || rentPCM < 0) rentPCM = 0;
    }
    const annualRent0 = rentPCM * 12;

    const expenseBase = num(
      p.averageYearlyExpenses ??
        p.avgYearlyExpenses ??
        p.annualExpensesEstimate,
      0,
    );
    const expenseInflationPct = num(
      p.expenseInflationPct ?? p.expensesInflationPct,
      3.0,
    );
    const purchasePrice = num(
      p.purchasePrice ?? p.pricePaid ?? p.purchase_price,
      0,
    );

    const endYear = await resolveEndYear(db, p, startYear);

    const [houseOvSnap, rentOvSnap, houseGlobalSnap, rentGlobalSnap] =
      await Promise.all([
        propRef.collection("housePriceOverrides").get(),
        propRef.collection("rentalIncreaseOverrides").get(),
        db.collection("housePriceYears").get(),
        db.collection("rentIncreaseYears").get(),
      ]);

    const houseOverride = toYearPctMap(houseOvSnap);
    const rentOverride = toYearPctMap(rentOvSnap);
    const houseGlobal = toYearPctMap(houseGlobalSnap);
    const rentGlobal = toYearPctMap(rentGlobalSnap);

    const years = [];
    const projectedHousePrice = [];
    const rentalIncome = [];
    const expenses = [];
    const rentalProfit = [];
    const cumulativeRentalProfit = [];
    const yieldPct = [];
    const capitalGains = [];
    const housePctUsed = [];
    const dailyCapitalGain = [];
    const combinedDailyGain = [];

    let rollingCapital = estimatedValue;
    let rollingRent = annualRent0;
    let rollingExpenses = expenseBase;
    let runningRentalProfit = 0;

    for (let y = startYear; y <= endYear; y++) {
      const housePct = pickPct(y, houseOverride, houseGlobal, 3.0);
      const rentPct = pickPct(y, rentOverride, rentGlobal, 3.0);

      const capGainY = rollingCapital * (housePct / 100);
      const nextCap = rollingCapital + capGainY;

      const annualProfitY = hasActiveTenancy
        ? rollingRent - rollingExpenses
        : 0;

      years.push(y);
      projectedHousePrice.push(round2(nextCap));
      rentalIncome.push(round2(rollingRent));
      expenses.push(round2(rollingExpenses));
      rentalProfit.push(round2(annualProfitY));

      runningRentalProfit += annualProfitY;
      cumulativeRentalProfit.push(round2(runningRentalProfit));

      yieldPct.push(
        purchasePrice > 0 && hasActiveTenancy
          ? round2((rollingRent / purchasePrice) * 100)
          : 0,
      );

      housePctUsed.push(round2(housePct));
      capitalGains.push(round2(capGainY));
      dailyCapitalGain.push(round2(capGainY / 365));
      const totalAnnualGainY = capGainY + annualProfitY;
      combinedDailyGain.push(round2(totalAnnualGainY / 365));

      if (y < endYear) {
        rollingCapital = nextCap;
        rollingRent = hasActiveTenancy ? rollingRent * (1 + rentPct / 100) : 0;
        rollingExpenses = rollingExpenses * (1 + expenseInflationPct / 100);
      }
    }

    const combined = projectedHousePrice.map((cap, i) =>
      round2(cap + (cumulativeRentalProfit[i] || 0)),
    );

    const prevIncomeToJan1 = num(p.previousRentalIncome, 0);
    const prevExpensesToJan1 = num(p.previousExpenses, 0);
    const prevNetRentalProfitToJan1 = prevIncomeToJan1 - prevExpensesToJan1;

    const estimatedValueAtStartYear = num(p.estimatedValue, 0);
    const purchasePriceAnchor = num(
      p.purchasePrice ?? p.pricePaid ?? p.purchase_price,
      0,
    );

    const historicalNetProfitBaseToJan1 = round2(
      estimatedValueAtStartYear -
        purchasePriceAnchor +
        prevNetRentalProfitToJan1,
    );

    const projRef = db.collection("propertyProjections").doc(propertyId);
    const projectionPayload = {
      ownerId: ownerId || null,
      ownerRef: ownerId ? db.collection("users").doc(ownerId) : null,
      propertyId,
      propertyRef: propRef,

      startYear,
      endYear,
      years,
      projectedHousePrice,
      rentalIncome,
      expenses,
      rentalProfit,
      cumulativeRentalProfit,
      yieldPct,
      combinedDailyGain,
      rental: rentalIncome,
      combined,
      capitalGains,
      housePctUsed,
      dailyCapitalGain,
      hasActiveTenancy,
      historicalNetProfitBaseToJan1,

      atRetirementYear: years[years.length - 1],
      atRetirementCapitalValue:
        projectedHousePrice[projectedHousePrice.length - 1],
      atRetirementAnnualRent: rentalIncome[rentalIncome.length - 1],
      atRetirementCombinedDailyGain:
        combinedDailyGain[combinedDailyGain.length - 1],
      atRetirementCumulativeRentalProfit: round2(runningRentalProfit),

      lastComputedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      schemaVersion: "v3.18-combined-uses-cumRental",
    };
    if (requestId) projectionPayload.recalcRequestId = requestId;

    await projRef.set(projectionPayload, { merge: false });

    functions.logger.info("Projection written", {
      propertyId,
      ownerId,
      years: years.length,
      requestId: requestId || null,
    });
  } finally {
    // END: atomic decrement + flip flag iff last job
    if (userRef) {
      try {
        await db.runTransaction(async (t) => {
          const u = await t.get(userRef);
          const cur = Number(u.get("calculatingProjectionsCount") || 0);
          const next = Math.max(0, cur - 1);
          const update = {
            calculatingProjectionsCount: next,
            calculatingProjections: next > 0 ? true : false,
            lastProjectionCompletedAt:
              admin.firestore.FieldValue.serverTimestamp(),
          };
          if (requestId && next === 0) {
            update.lastCompletedRequestId = requestId;
          }
          t.update(userRef, update);
        });
      } catch (err) {
        functions.logger.error("Flag reset failed", {
          ownerId,
          error: err && err.message,
        });
      }
    }
  }
}

// ───────────────────────── UTILS ─────────────────────────
function getOwnerUserIdFromPropertyData(p) {
  return (
    String(p.ownerID || p.ownerId || "").trim() ||
    (p.ownerRef && p.ownerRef.id) ||
    (p.landlordRef && p.landlordRef.id) ||
    null
  );
}

function num(v, fallback) {
  const n = typeof v === "string" ? Number(v) : typeof v === "number" ? v : NaN;
  return Number.isFinite(n) ? n : fallback;
}

async function resolveEndYear(db, p, startYear) {
  let dobTs = p.dateOfBirth;
  let retirementAge = num(p.retirementAge, NaN);

  const ownerId =
    String(p.ownerID || p.ownerId || "").trim() ||
    (p.ownerRef && p.ownerRef.id) ||
    (p.landlordRef && p.landlordRef.id) ||
    "";

  if ((!dobTs || !Number.isFinite(retirementAge)) && ownerId) {
    const userSnap = await db.collection("users").doc(ownerId).get();
    if (userSnap.exists) {
      const u = userSnap.data() || {};
      if (!dobTs) dobTs = u.dateOfBirth || u.dob || u.birthDate;
      if (!Number.isFinite(retirementAge)) {
        retirementAge =
          num(u.planned_retirement_age, NaN) ||
          num(u.retirementAge, NaN) ||
          num(u.plannedRetirementAge, NaN);
      }
    }
  }

  let retirementYear;
  if (
    dobTs &&
    typeof dobTs.toDate === "function" &&
    Number.isFinite(retirementAge) &&
    retirementAge > 0
  ) {
    retirementYear = dobTs.toDate().getFullYear() + retirementAge;
  }
  const endYear = Math.max(startYear + 5, retirementYear || startYear + 5);
  functions.logger.info("Retirement horizon", {
    startYear,
    retirementYear,
    endYear,
  });
  return endYear;
}

function toYearPctMap(querySnap) {
  const out = {};
  querySnap.forEach((doc) => {
    const d = doc.data() || {};
    const year = Number.isFinite(+d.year) ? +d.year : Number(doc.id);
    const pct = Number(d.pct);
    if (Number.isFinite(year) && Number.isFinite(pct)) out[year] = pct;
  });
  return out;
}

function pickPct(year, overrideMap, globalMap, def) {
  return overrideMap[year] != null
    ? overrideMap[year]
    : globalMap[year] != null
      ? globalMap[year]
      : def;
}

function round2(n) {
  return Math.round(n * 100) / 100;
}
