const functions = require("firebase-functions");

const admin = require("firebase-admin");

// Do NOT call admin.initializeApp() in the FlutterFlow editor

exports.computePropertyProjection = functions

  .region("us-central1") // keep in sync with your FF action region

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

    // ---- Load property

    const propRef = db.collection("properties").doc(propertyId);

    const propSnap = await propRef.get();

    if (!propSnap.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        `Property ${propertyId} not found`,
      );
    }

    const p = propSnap.data() || {};

    // ---- Inputs / defaults

    const startYear = new Date().getFullYear();

    // 1) Estimated value anchor

    const estimatedValue = num(p.estimatedValue, 0);

    // 2) Monthly rent: STRICT — use ONLY active tenancy (no fallback)

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

    // 3) Expenses baseline + inflation

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

    // 4) Purchase price (for yield)

    const purchasePrice = num(
      p.purchasePrice ?? p.pricePaid ?? p.purchase_price,
      0,
    );

    // 5) Retirement window (property or user fallback)

    const endYear = await resolveEndYear(db, p, startYear);

    // ---- Load overrides and global curves

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

    // ---- Build arrays (anchor at startYear with CURRENT values)

    const years = [startYear];

    const projectedHousePrice = [round2(estimatedValue)];

    const rentalIncome = [round2(annualRent0)];

    const expenses = [round2(expenseBase)];

    const rentalProfit = [
      hasActiveTenancy ? round2(annualRent0 - expenseBase) : 0,
    ];

    const yieldPct = [
      purchasePrice > 0 && hasActiveTenancy
        ? round2((rentalProfit[0] / purchasePrice) * 100)
        : 0,
    ];

    const combined = [round2(estimatedValue + annualRent0)];

    // Per-year series aligned to years[] (index i corresponds to calendar year years[i])

    const capitalGains = []; // gain for Y → Y+1

    const housePctUsed = []; // % used for that calendar year Y

    const dailyCapitalGain = []; // per-day capital gain for Y

    let rollingCapital = estimatedValue; // value at start of current Y

    let rollingRent = annualRent0; // value at start of current Y

    let rollingExpenses = expenseBase; // value at start of current Y

    // For each year Y in [startYear .. endYear-1], apply % for Y to get Y+1

    for (let y = startYear; y < endYear; y++) {
      const housePct = pickPct(y, houseOverride, houseGlobal, 3.0);

      const rentPct = pickPct(y, rentOverride, rentGlobal, 3.0);

      // capital for next year

      const capGainY = rollingCapital * (housePct / 100);

      const nextCap = rollingCapital + capGainY;

      // expenses for next year

      rollingExpenses = rollingExpenses * (1 + expenseInflationPct / 100);

      // rent for next year (or keep zero if no tenancy)

      rollingRent = hasActiveTenancy ? rollingRent * (1 + rentPct / 100) : 0;

      // store per-year artifacts (for calendar year Y)

      housePctUsed.push(round2(housePct));

      capitalGains.push(round2(capGainY));

      dailyCapitalGain.push(round2(capGainY / 365));

      // roll forward to Y+1 and push arrays

      rollingCapital = nextCap;

      years.push(y + 1);

      projectedHousePrice.push(round2(rollingCapital));

      rentalIncome.push(round2(rollingRent));

      expenses.push(round2(rollingExpenses));

      // rental profit & yield (zeroed if no tenancy to avoid confusion)

      const prof = hasActiveTenancy ? rollingRent - rollingExpenses : 0;

      rentalProfit.push(round2(prof));

      yieldPct.push(
        purchasePrice > 0 && hasActiveTenancy
          ? round2((prof / purchasePrice) * 100)
          : 0,
      );

      combined.push(round2(rollingCapital + rollingRent));
    }

    // Also compute the final year's gain using the % for endYear (so the last entries aren’t 0)

    const lastYearPct = pickPct(endYear, houseOverride, houseGlobal, 3.0);

    housePctUsed.push(round2(lastYearPct));

    const lastGain = rollingCapital * (lastYearPct / 100); // gain for endYear → endYear+1

    capitalGains.push(round2(lastGain));

    dailyCapitalGain.push(round2(lastGain / 365));

    const projRef = db.collection("propertyProjections").doc(propertyId);

    await projRef.set(
      {
        propertyRef: propRef,

        startYear,

        endYear,

        years,

        projectedHousePrice,

        // NEW canonical names

        rentalIncome, // preferred going forward

        expenses,

        rentalProfit,

        yieldPct,

        // Keep legacy 'rental' for backward compatibility (optional)

        rental: rentalIncome,

        combined,

        capitalGains,

        housePctUsed,

        dailyCapitalGain,

        hasActiveTenancy, // convenience flag for the UI

        atRetirementYear: years[years.length - 1],

        atRetirementCapitalValue:
          projectedHousePrice[projectedHousePrice.length - 1],

        atRetirementAnnualRent: rentalIncome[rentalIncome.length - 1],

        lastComputedAt: admin.firestore.FieldValue.serverTimestamp(),

        // Remove legacy field to avoid duplication/confusion

        capital: admin.firestore.FieldValue.delete(),

        schemaVersion: "v3.8-expenses-profit-yield",
      },
      { merge: true },
    );

    functions.logger.info("Projection v3.8 written", {
      docPath: projRef.path,

      hasActiveTenancy,

      head: {
        years: years.slice(0, 3),

        projectedHousePrice: projectedHousePrice.slice(0, 3),

        rentalIncome: rentalIncome.slice(0, 3),

        expenses: expenses.slice(0, 3),

        rentalProfit: rentalProfit.slice(0, 3),

        yieldPct: yieldPct.slice(0, 3),

        capitalGains: capitalGains.slice(0, 3),

        housePctUsed: housePctUsed.slice(0, 3),

        dailyCapitalGain: dailyCapitalGain.slice(0, 3),
      },
    });

    return {
      ok: true,

      version: "v3.8-expenses-profit-yield",

      docPath: projRef.path,

      hasActiveTenancy,

      counts: {
        years: years.length,

        projectedHousePrice: projectedHousePrice.length,

        rentalIncome: rentalIncome.length,

        expenses: expenses.length,

        rentalProfit: rentalProfit.length,

        yieldPct: yieldPct.length,

        capitalGains: capitalGains.length,

        housePctUsed: housePctUsed.length,

        dailyCapitalGain: dailyCapitalGain.length,
      },
    };
  });

/** ---- Helpers ---- */

function num(v, fallback) {
  const n = typeof v === "string" ? Number(v) : typeof v === "number" ? v : NaN;

  return Number.isFinite(n) ? n : fallback;
}

async function resolveEndYear(db, p, startYear) {
  let dobTs = p.dateOfBirth; // Firestore Timestamp (property)

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

    const year = Number.isFinite(+d.year) ? +d.year : Number(doc.id); // support field or docId

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
