// FlutterFlow-friendly: do NOT call admin.initializeApp() here.
const functions = require("firebase-functions");
const admin = require("firebase-admin");

const REGION = "us-central1";
const RENT_EVENT_TYPE = "rent_due";
const RENT_EVENT_TITLE = "Rent Due";
const RENT_MONTHS_AHEAD = 12;

exports.onTenancyWriteSyncCurrentRent = functions
  .region(REGION)
  .runWith({ memory: "256MB", timeoutSeconds: 120 })
  .firestore.document("properties/{propertyId}/tenancies/{tenancyId}")
  .onWrite(async (change, context) => {
    const propertyId = context.params.propertyId;
    const tenancyId = context.params.tenancyId;

    const db = admin.firestore();
    const propRef = db.collection("properties").doc(propertyId);
    const eventsRef = db.collection("events");

    const beforeExists = change.before.exists;
    const afterExists = change.after.exists;

    const before = beforeExists ? change.before.data() || {} : {};
    const after = afterExists ? change.after.data() || {} : {};

    const now = new Date();
    const nowTs = admin.firestore.Timestamp.fromDate(now);

    const normNum = (v) => {
      if (v == null) return null;
      if (typeof v === "number") return Number.isFinite(v) ? v : null;
      if (typeof v === "string") {
        const x = Number(v);
        return Number.isFinite(x) ? x : null;
      }
      return null;
    };

    const asBool = (v) => v === true;
    const wasActive = asBool(before.isActive);
    const isActive = asBool(after.isActive);

    const beforeRent = Math.max(0, normNum(before.rentAmount) ?? 0);
    const afterRent = Math.max(0, normNum(after.rentAmount) ?? 0);
    const rentChanged = beforeRent !== afterRent;

    const wasDeleted = beforeExists && !afterExists;
    const isCreated = !beforeExists && afterExists;

    // ---- Rule 1: false -> false update => do nothing
    if (beforeExists && afterExists && !wasActive && !isActive) {
      functions.logger.info("[tenancy-sync] inactive->inactive; no action", {
        propertyId,
        tenancyId,
      });
      return null;
    }

    // ---- Rule 2 + 3: Active tenancy created/updated
    // Create/update future rent events when:
    // - new active tenancy created
    // - inactive -> active
    // - active + rent changed
    const shouldUpsertFutureRentEvents =
      (isCreated && isActive) ||
      (!isCreated && beforeExists && !wasActive && isActive) ||
      (!isCreated && beforeExists && wasActive && isActive && rentChanged);

    // ---- Rule 4: active -> inactive (or active doc deleted) => remove future rent events
    const shouldDeleteFutureRentEvents =
      (beforeExists && afterExists && wasActive && !isActive) ||
      (wasDeleted && wasActive);

    // ---- Property current rent sync logic
    // Only update property current rent fields when tenancy is active and created/activated/rent-changed.
    if (shouldUpsertFutureRentEvents) {
      const propSnap = await propRef.get();
      if (propSnap.exists) {
        const p = propSnap.data() || {};
        const prevCurrentRent = normNum(p.currentRentAmount) ?? 0;
        const prevHasActive = p.hasActiveTenancy === true;
        const prevTenancyId = p.currentTenancyId || "";
        const prevSource =
          typeof p.currentRentSource === "string" ? p.currentRentSource : "";

        const propUpdates = {};
        let poke = false;

        if (prevCurrentRent !== afterRent) {
          propUpdates.currentRentAmount = afterRent;
          poke = true;
        }
        if (!prevHasActive) propUpdates.hasActiveTenancy = true;
        if (prevTenancyId !== tenancyId)
          propUpdates.currentTenancyId = tenancyId;
        if (prevSource !== "tenancy") propUpdates.currentRentSource = "tenancy";
        if (poke)
          propUpdates._recalcTrigger =
            admin.firestore.FieldValue.serverTimestamp();

        if (Object.keys(propUpdates).length > 0) {
          await propRef.set(propUpdates, { merge: true });
        }
      }
    }

    if (shouldDeleteFutureRentEvents) {
      await deleteFutureRentDueEvents({
        db,
        eventsRef,
        tenancyRef: change.before.ref,
        nowTs,
      });

      // Optional property flags update: if this tenancy was marked current, clear active flag.
      const propSnap = await propRef.get();
      if (propSnap.exists) {
        const p = propSnap.data() || {};
        if (
          (p.currentTenancyId || "") === tenancyId &&
          p.hasActiveTenancy === true
        ) {
          await propRef.set(
            {
              hasActiveTenancy: false,
              _recalcTrigger: admin.firestore.FieldValue.serverTimestamp(),
            },
            { merge: true },
          );
        }
      }
    }

    if (shouldUpsertFutureRentEvents) {
      const rentDueDayRaw = normNum(after.rentDueDay);
      const rentDueDay = rentDueDayRaw
        ? Math.max(1, Math.min(31, Math.trunc(rentDueDayRaw)))
        : null;

      if (!rentDueDay) {
        functions.logger.warn(
          "[tenancy-sync] Missing/invalid rentDueDay; skipped rent event generation",
          {
            propertyId,
            tenancyId,
            rentDueDay: after.rentDueDay,
          },
        );
        return null;
      }

      const tenancyStartDate = toDate(after.tenancyStartDate);
      const dueDates = generateNextMonthlyDueDates({
        fromDate: now,
        rentDueDay,
        monthsAhead: RENT_MONTHS_AHEAD,
        tenancyStartDate,
      });

      await upsertFutureRentDueEvents({
        db,
        eventsRef,
        propertyRef: propRef,
        tenancyRef: change.after.ref,
        tenancyId,
        amount: afterRent,
        dueDates,
      });
    }

    functions.logger.info("[tenancy-sync] completed", {
      propertyId,
      tenancyId,
      shouldUpsertFutureRentEvents,
      shouldDeleteFutureRentEvents,
      rentChanged,
      wasActive,
      isActive,
      isCreated,
      wasDeleted,
    });

    return null;
  });

// -------------------- Helpers --------------------

function toDate(v) {
  if (!v) return null;
  if (v instanceof Date) return v;
  if (typeof v.toDate === "function") return v.toDate();
  return null;
}

function daysInMonth(year, month1to12) {
  return new Date(Date.UTC(year, month1to12, 0)).getUTCDate();
}

function makeDueDate(year, month1to12, day) {
  const d = Math.min(day, daysInMonth(year, month1to12));
  return new Date(year, month1to12 - 1, d, 12, 0, 0, 0); // midday local to avoid DST edge oddities
}

function startOfDayLocal(d) {
  return new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0, 0);
}

function ymdKey(d) {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}${m}${day}`;
}

function generateNextMonthlyDueDates({
  fromDate,
  rentDueDay,
  monthsAhead,
  tenancyStartDate,
}) {
  const out = [];
  const fromDay = startOfDayLocal(fromDate);
  const floorDate = tenancyStartDate
    ? startOfDayLocal(tenancyStartDate)
    : fromDay;
  const effectiveStart = fromDay > floorDate ? fromDay : floorDate;

  let y = effectiveStart.getFullYear();
  let m = effectiveStart.getMonth() + 1;

  while (out.length < monthsAhead) {
    const due = makeDueDate(y, m, rentDueDay);
    if (due >= effectiveStart) out.push(due);
    m += 1;
    if (m === 13) {
      m = 1;
      y += 1;
    }
  }
  return out;
}

async function upsertFutureRentDueEvents({
  db,
  eventsRef,
  propertyRef,
  tenancyRef,
  tenancyId,
  amount,
  dueDates,
}) {
  const batches = [];
  let batch = db.batch();
  let ops = 0;

  for (const dueDate of dueDates) {
    const id = `rent_due_${tenancyId}_${ymdKey(dueDate)}`;
    const docRef = eventsRef.doc(id);

    batch.set(
      docRef,
      {
        title: RENT_EVENT_TITLE,
        type: RENT_EVENT_TYPE,
        startDate: admin.firestore.Timestamp.fromDate(dueDate),
        status: "pending",
        propertyRef,
        tenancyRef,
        amount: Math.round(amount), // events.amount is int in your schema
        notes: "Auto-generated from active tenancy rent schedule",
        source: "system_rent_schedule",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        // keep first createdAt if already exists; set always for new docs:
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    ops += 1;
    if (ops >= 450) {
      batches.push(batch.commit());
      batch = db.batch();
      ops = 0;
    }
  }

  if (ops > 0) batches.push(batch.commit());
  if (batches.length > 0) await Promise.all(batches);
}

async function deleteFutureRentDueEvents({ db, eventsRef, tenancyRef, nowTs }) {
  while (true) {
    const snap = await eventsRef
      .where("tenancyRef", "==", tenancyRef)
      .where("type", "==", RENT_EVENT_TYPE)
      .where("startDate", ">=", nowTs)
      .limit(400)
      .get();

    if (snap.empty) break;

    const batch = db.batch();
    snap.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();

    if (snap.size < 400) break;
  }
}
