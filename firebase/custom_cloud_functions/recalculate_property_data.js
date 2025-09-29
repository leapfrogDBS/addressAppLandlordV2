exports.recalculatePropertyData = functions
  .region("us-central1")
  .runWith({ memory: "128MB" })
  .firestore.document("properties/{propertyId}")
  .onUpdate(async (change, context) => {
    const propertyId = context.params.propertyId;
    const before = change.before.data() || {};
    const after = change.after.data() || {};

    // Property-level fields that matter + the poke field
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
      "ownerID",
      "ownerId",
      "_recalcTrigger", // <-- IMPORTANT: poke field
    ];

    const changed = fieldsToWatch.some(
      (k) => (before[k] ?? null) !== (after[k] ?? null),
    );
    if (!changed) return null;

    const db = admin.firestore();
    const ownerOverride = getOwnerUserIdFromPropertyData(after);
    await computePropertyProjectionCore(db, propertyId, ownerOverride);
    return null;
  });

/* ───────────────────── (optional) manual callable for FF button ──────────── */
exports.computePropertyProjection = functions
  .region("us-central1")
  .runWith({ memory: "128MB" })
  .https.onCall(async (data, context) => {
    const propertyId = ((data && data.propertyId) || "").trim();
    if (!propertyId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "propertyId is required",
      );
    }
    const db = admin.firestore();
    await computePropertyProjectionCore(db, propertyId, null);
    return { ok: true, propertyId };
  });

/* ───────────────────────── utils ───────────────────────── */
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
