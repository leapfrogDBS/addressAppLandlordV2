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

    // 6) Loan Inputs
    const startingLoanBalance = num(p.loanBalance, 0);
    const loanTermYears = num(p.loanTermYears, 30);
    const annualLoanPayment = num(p.annualLoanPayment, 0);

    // Calculate a simple fixed annual payment if the specific field is missing
    let annualPaymentEstimate = annualLoanPayment;
    if (
      annualPaymentEstimate === 0 &&
      loanTermYears > 0 &&
      startingLoanBalance > 0
    ) {
      // Very simple estimate: total loan / term, ignores interest
      annualPaymentEstimate = round2(startingLoanBalance / loanTermYears);
    }
    // End Loan Inputs

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

    const expenseBaseAnnual = round2(expenseBase);
    const annualProfit0 = hasActiveTenancy
      ? round2(annualRent0 - expenseBaseAnnual)
      : 0;

    const rentalIncome = [round2(annualRent0)];
    const expenses = [expenseBaseAnnual];
    const rentalProfit = [annualProfit0]; // Anchored profit for startYear
    const yieldPct = [
      purchasePrice > 0 && hasActiveTenancy
        ? round2((rentalProfit[0] / purchasePrice) * 100)
        : 0,
    ];

    // Initialize Loan and Equity arrays at current year
    const loanRemainingBalance = [round2(startingLoanBalance)];
    const ownerEquity = [round2(estimatedValue - startingLoanBalance)];
    // End Initialization

    const combined = [round2(estimatedValue + annualRent0)];

    // Per-year series aligned to years[] (index i corresponds to calendar year years[i])
    const capitalGains = []; // gain for Y → Y+1
    const housePctUsed = []; // % used for that calendar year Y
    const dailyCapitalGain = []; // per-day capital gain for Y
    const combinedDailyGain = []; // NEW: Daily combined gain

    let rollingCapital = estimatedValue; // value at start of current Y
    let rollingRent = annualRent0; // value at start of current Y
    let rollingExpenses = expenseBase; // value at start of current Y
    let rollingLoanBalance = startingLoanBalance; // loan balance at start of current Y
    let currentYearProfit = annualProfit0; // Profit for the current year (y)

    // For each year Y in [startYear .. endYear-1], apply % for Y to get Y+1
    for (let y = startYear; y < endYear; y++) {
      const housePct = pickPct(y, houseOverride, houseGlobal, 3.0);
      const rentPct = pickPct(y, rentOverride, rentGlobal, 3.0);

      // 1. capital for next year (Y+1)
      const capGainY = rollingCapital * (housePct / 100);
      const nextCap = rollingCapital + capGainY;

      // NEW: Calculate Combined Daily Gain for current year 'y'
      // This is (Capital Gain Y->Y+1) + (Profit for Year Y) / 365
      const totalAnnualGainY = capGainY + currentYearProfit;
      combinedDailyGain.push(round2(totalAnnualGainY / 365));
      // End NEW

      // 2. store per-year artifacts (for calendar year Y)
      housePctUsed.push(round2(housePct));
      capitalGains.push(round2(capGainY));
      dailyCapitalGain.push(round2(capGainY / 365));

      // 3. Roll forward calculations for Y+1 values

      // expenses for next year
      rollingExpenses = rollingExpenses * (1 + expenseInflationPct / 100);

      // rent for next year (or keep zero if no tenancy)
      rollingRent = hasActiveTenancy ? rollingRent * (1 + rentPct / 100) : 0;

      // Calculate Loan Paydown and Equity
      if (
        rollingLoanBalance > 0 &&
        annualPaymentEstimate > 0 &&
        y < startYear + loanTermYears
      ) {
        // Reduce loan balance by the calculated annual payment, ensuring it doesn't go below zero
        rollingLoanBalance = Math.max(
          0,
          rollingLoanBalance - annualPaymentEstimate,
        );
      } else {
        rollingLoanBalance = 0; // Loan is fully paid off
      }
      const nextEquity = nextCap - rollingLoanBalance;
      // End Loan/Equity Calculation

      // rental profit for Y+1
      const nextProfit = hasActiveTenancy ? rollingRent - rollingExpenses : 0;
      currentYearProfit = nextProfit; // Update profit variable for next iteration (which will be Y+1's profit)

      // 4. Push Y+1 arrays
      rollingCapital = nextCap;

      years.push(y + 1);
      projectedHousePrice.push(round2(rollingCapital));

      rentalIncome.push(round2(rollingRent));
      expenses.push(round2(rollingExpenses));

      // rental profit & yield (zeroed if no tenancy to avoid confusion)
      rentalProfit.push(round2(nextProfit));
      yieldPct.push(
        purchasePrice > 0 && hasActiveTenancy
          ? round2((nextProfit / purchasePrice) * 100)
          : 0,
      );

      // Push Loan and Equity for Y+1
      loanRemainingBalance.push(round2(rollingLoanBalance));
      ownerEquity.push(round2(nextEquity));
      // End Push

      combined.push(round2(rollingCapital + rollingRent));
    }

    // Also compute the final year's gain using the % for endYear (so the last entries aren’t 0)
    const lastYearPct = pickPct(endYear, houseOverride, houseGlobal, 3.0);
    housePctUsed.push(round2(lastYearPct));
    const lastGain = rollingCapital * (lastYearPct / 100); // gain for endYear → endYear+1
    capitalGains.push(round2(lastGain));
    dailyCapitalGain.push(round2(lastGain / 365));

    // NEW: Calculate final combined daily gain for endYear
    // Uses the final capital gain (for endYear -> endYear+1) and the profit earned during endYear (currentYearProfit)
    const finalTotalAnnualGain = lastGain + currentYearProfit;
    combinedDailyGain.push(round2(finalTotalAnnualGain / 365));
    // END NEW

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

        // START NEW FIELDS TO SAVE
        loanRemainingBalance,
        ownerEquity,
        combinedDailyGain, // <-- The new field
        // END NEW FIELDS TO SAVE

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

        // START NEW RETIREMENT SUMMARY FIELDS
        atRetirementLoanBalance:
          loanRemainingBalance[loanRemainingBalance.length - 1],
        atRetirementOwnerEquity: ownerEquity[ownerEquity.length - 1],
        atRetirementCombinedDailyGain:
          combinedDailyGain[combinedDailyGain.length - 1], // <-- New summary
        // END NEW RETIREMENT SUMMARY FIELDS

        lastComputedAt: admin.firestore.FieldValue.serverTimestamp(),

        // Remove legacy field to avoid duplication/confusion
        capital: admin.firestore.FieldValue.delete(),
        schemaVersion: "v3.10-daily-gain", // Bump version to reflect daily gain changes
      },
      { merge: true },
    );

    functions.logger.info(
      "Projection v3.10 written with equity and daily gain",
      {
        docPath: projRef.path,
        hasActiveTenancy,
        head: {
          years: years.slice(0, 3),
          projectedHousePrice: projectedHousePrice.slice(0, 3),
          ownerEquity: ownerEquity.slice(0, 3),
          combinedDailyGain: combinedDailyGain.slice(0, 3), // Log new field
        },
      },
    );

    return {
      ok: true,
      version: "v3.10-daily-gain",
      docPath: projRef.path,
      hasActiveTenancy,
      counts: {
        years: years.length,
        projectedHousePrice: projectedHousePrice.length,
        rentalIncome: rentalIncome.length,
        expenses: expenses.length,
        rentalProfit: rentalProfit.length,
        yieldPct: yieldPct.length,
        ownerEquity: ownerEquity.length,
        combinedDailyGain: combinedDailyGain.length, // Return new field count
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
