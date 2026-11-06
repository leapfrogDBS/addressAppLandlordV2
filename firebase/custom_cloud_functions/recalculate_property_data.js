// FlutterFlow-friendly: do NOT call admin.initializeApp() here.
const functions = require("firebase-functions");
const admin = require("firebase-admin");

// ───────────────────────── CONFIG ─────────────────────────
const REGION = "us-central1"; // FF default; change only if your FF project is bound elsewhere.

// ───────────────────────── TRIGGERS ─────────────────────────

exports.recalculatePropertyData = functions
  .region(REGION)
  .runWith({ memory: "256MB", timeoutSeconds: 120 })
  .firestore.document("properties/{propertyId}")
  .onUpdate(async (change, context) => {
    const propertyId = context.params.propertyId;
    const before = change.before.data() || {};
    const after = change.after.data() || {};

    // This function's own year-close write has already rebuilt the projection.
    if (isOwnEngineWrite(before, after)) return null;

    const fieldsToWatch = [
      "estimatedValue",
      "purchasePrice",
      "ownerID",
      "_recalcTrigger",
      "dateJoinedAddressed",
      "currentRentAmount",
      "averageYearlyExpenses",
      "priceValuationOnJoiningAddressed",
      "previousRentalIncome",
      "previousExpenses",
    ];

    const norm = (v) =>
      v && typeof v.toMillis === "function" ? v.toMillis() : (v ?? null);

    const changed = fieldsToWatch.some(
      (k) => norm(before[k]) !== norm(after[k]),
    );
    if (!changed) {
      functions.logger.info("No projection-relevant changes", { propertyId });
      return null;
    }

    const db = admin.firestore();

    try {
      const result = await computePropertyProjectionCore({ db, propertyId });
      if (result && result.skipped) {
        return null;
      }
    } catch (err) {
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

    try {
      const result = await computePropertyProjectionCore({
        db: admin.firestore(),
        propertyId,
      });
      if (result && result.skipped) {
        return { ok: true, skipped: true, propertyId };
      }
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
  const { db, propertyId } = args;

  // Load property
  const propRef = db.collection("properties").doc(propertyId);
  const propSnap = await propRef.get();
  if (!propSnap.exists) throw new Error("Property not found");
  let p = propSnap.data() || {};

  // Resolve owner
  const ownerId = getOwnerUserIdFromPropertyData(p); // reads p.ownerID
  if (!ownerId) throw new Error("Property ownerID missing");
  const userRef = ownerId ? db.collection("users").doc(ownerId) : null;

  const slotReserved = p._projectionSlotReserved === true;

  // Clear marker first (do NOT add this field to fieldsToWatch)
  if (slotReserved) {
    await propRef.update({
      _projectionSlotReserved: admin.firestore.FieldValue.delete(),
    });
  }

  if (userRef) {
    const uSnap = await userRef.get();
    const uData = uSnap.exists ? uSnap.data() || {} : {};
    if (!isCompletedOnboardingForProjections(uData)) {
      functions.logger.info(
        "Projection skipped: completedOnboarding is false (onboarding not finished)",
        { propertyId, ownerId },
      );
      // Batch poke already counted this slot — still consume it
      if (slotReserved) {
        await db.runTransaction(async (t) => {
          const u = await t.get(userRef);
          const cur = Number(u.get("calculatingProjectionsCount") || 0);
          const next = Math.max(0, cur - 1);
          t.update(userRef, {
            calculatingProjectionsCount: next,
            calculatingProjections: next > 0 ? true : false,
            lastProjectionCompletedAt:
              admin.firestore.FieldValue.serverTimestamp(),
          });
        });
      }
      return { skipped: true };
    }
  }

  // START: +1 only for single-property runs.
  // Batch runs were already counted by the poke (_projectionSlotReserved).
  if (userRef && !slotReserved) {
    await db.runTransaction(async (t) => {
      const u = await t.get(userRef);
      const cur = Number(u.get("calculatingProjectionsCount") || 0);
      const update = {
        calculatingProjections: true,
        calculatingProjectionsCount: cur + 1,
        lastProjectionStartedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      t.set(userRef, update, { merge: true });
    });
  }

  try {
    // ==== YOUR PROJECTION MATH (unchanged from your working version) ====

    const now = args.now || new Date();

    // Close any finished property year first, so the rebuild starts from the
    // banked figures. Nothing is written until the projection is ready.
    const yearClose = await resolveYearClose({
      db,
      propRef,
      propertyId,
      p,
      now,
    });
    p = { ...p, ...yearClose.rebuildValues };
    const originalMarkerMs = tsMillis(propSnap.get("lastAccruedPeriodStart"));
    const originalEstimatedValue = propSnap.get("estimatedValue");

    // Pull join day/month (London time)
    const joinedTs = p.dateJoinedAddressed;
    let startYear = now.getFullYear(); // fallback if joinedTs missing

    let joinMonth = null;
    let joinDay = null;

    if (joinedTs && typeof joinedTs.toDate === "function") {
      const joinYMD = ymdInLondon(joinedTs.toDate());
      joinMonth = joinYMD.m;
      joinDay = joinYMD.d;

      const nowYMD = ymdInLondon(now);
      const annThisYear = makeAnniversaryYMD(nowYMD.y, joinMonth, joinDay);

      // If we've already passed the anniversary this year, startYear = this year, else last year
      startYear = cmpYMD(nowYMD, annThisYear) >= 0 ? nowYMD.y : nowYMD.y - 1;
    }

    functions.logger.info("Projection startYear resolved", {
      propertyId,
      now: now.toISOString(),
      joined:
        joinedTs && typeof joinedTs.toDate === "function"
          ? joinedTs.toDate().toISOString()
          : null,
      joinMonth,
      joinDay,
      startYear,
      hasJoinDate: !!(joinedTs && typeof joinedTs.toDate === "function"),
    });

    const estimatedValue = num(p.estimatedValue, 0);

    // rent assumption comes from the property doc only (no tenancy reads)
    let rentPCM = num(p.currentRentAmount, 0);
    if (!Number.isFinite(rentPCM) || rentPCM < 0) rentPCM = 0;
    const annualRent0 = rentPCM * 12;

    const expenseBase = num(p.averageYearlyExpenses, 0);
    const expenseInflationPct = await resolveGlobalExpenseInflationPct({
      db,
      contextId: propertyId,
    });
    const purchasePrice = num(p.purchasePrice, 0);

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

    functions.logger.info("House price percentage maps loaded", {
      propertyId,
      houseOverrideCount: houseOvSnap.size,
      houseGlobalCount: houseGlobalSnap.size,
      houseOverrideKeys: Object.keys(houseOverride)
        .map(Number)
        .sort((a, b) => a - b),
      houseGlobalKeys: Object.keys(houseGlobal)
        .map(Number)
        .sort((a, b) => a - b),
      houseOverrideMap: houseOverride,
      houseGlobalMap: houseGlobal,
      startYear,
      endYear,
    });

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

    const periodStartDates = [];
    const periodEndDates = [];
    const periodLabels = [];
    const periodLabelsShort = [];

    let rollingCapital = estimatedValue;
    let rollingRent = annualRent0;
    let rollingExpenses = expenseBase;
    let runningRentalProfit = 0;

    for (let y = startYear; y <= endYear; y++) {
      // Build property-year period boundaries (anniversary -> day before next anniversary)
      let periodStartYMD;
      let nextStartYMD;
      let periodEndYMD;

      if (joinMonth && joinDay) {
        periodStartYMD = makeAnniversaryYMD(y, joinMonth, joinDay);
        nextStartYMD = makeAnniversaryYMD(y + 1, joinMonth, joinDay);
        periodEndYMD = ymdMinusOneDay(nextStartYMD);

        periodStartDates.push(ymdToString(periodStartYMD));
        periodEndDates.push(ymdToString(periodEndYMD));
        periodLabels.push(
          `${formatYMDLabel(periodStartYMD)} – ${formatYMDLabel(periodEndYMD)}`,
        );

        const startY = periodStartYMD.y;
        const endY = periodEndYMD.y;
        const fmtYY = (v) => String(v % 100).padStart(2, "0");
        periodLabelsShort.push(`${fmtYY(startY)}/${fmtYY(endY)}`);
      } else {
        // Fallback: calendar year period if dateJoinedAddressed missing
        periodStartDates.push(`${y}-01-01`);
        periodEndDates.push(`${y}-12-31`);
        periodLabels.push(`1 Jan ${y} – 31 Dec ${y}`);

        const fmtYY = (v) => String(v % 100).padStart(2, "0");
        periodLabelsShort.push(`${fmtYY(y)}/${fmtYY(y + 1)}`);
      }

      const housePct = pickPct(y, houseOverride, houseGlobal, 3.0);
      const rentPct = pickPct(y, rentOverride, rentGlobal, 3.0);

      if (y <= startYear + 2) {
        functions.logger.info("Year percentage lookup", {
          year: y,
          yearType: typeof y,
          houseOverrideValue: houseOverride[y],
          houseGlobalValue: houseGlobal[y],
          selectedHousePct: housePct,
          periodStart: periodStartDates[periodStartDates.length - 1],
          periodEnd: periodEndDates[periodEndDates.length - 1],
          periodLabel: periodLabels[periodLabels.length - 1],
          overrideMapHasYear: y in houseOverride,
          globalMapHasYear: y in houseGlobal,
        });
      }

      const capGainY = rollingCapital * (housePct / 100);
      const nextCap = rollingCapital + capGainY;

      const annualProfitY = rollingRent - rollingExpenses;

      years.push(y);
      projectedHousePrice.push(round2(nextCap));
      rentalIncome.push(round2(rollingRent));
      expenses.push(round2(rollingExpenses));
      rentalProfit.push(round2(annualProfitY));

      runningRentalProfit += annualProfitY;
      cumulativeRentalProfit.push(round2(runningRentalProfit));

      yieldPct.push(
        purchasePrice > 0 ? round2((rollingRent / purchasePrice) * 100) : 0,
      );

      housePctUsed.push(round2(housePct));
      capitalGains.push(round2(capGainY));
      dailyCapitalGain.push(round2(capGainY / 365));
      const totalAnnualGainY = capGainY + annualProfitY;
      combinedDailyGain.push(round2(totalAnnualGainY / 365));

      if (y < endYear) {
        rollingCapital = nextCap;
        rollingRent = rollingRent * (1 + rentPct / 100);
        rollingExpenses = rollingExpenses * (1 + expenseInflationPct / 100);
      }
    }

    const combined = projectedHousePrice.map((cap, i) =>
      round2(cap + (cumulativeRentalProfit[i] || 0)),
    );

    const prevIncomeCompletedPeriods = num(p.previousRentalIncome, 0);
    const prevExpensesCompletedPeriods = num(p.previousExpenses, 0);
    const prevNetRentalProfitCompletedPeriods =
      prevIncomeCompletedPeriods - prevExpensesCompletedPeriods;

    const estimatedValueAtStartYear = num(p.estimatedValue, 0);
    const purchasePriceAnchor = num(p.purchasePrice, 0);

    const historicalNetProfitBase = round2(
      estimatedValueAtStartYear -
        purchasePriceAnchor +
        prevNetRentalProfitCompletedPeriods,
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
      periodStartDates,
      periodEndDates,
      periodLabels,
      periodLabelsShort,
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
      currentRentAmount: rentPCM,
      historicalNetProfitBase,

      atRetirementPeriodLabel: periodLabels[periodLabels.length - 1],

      atRetirementYear: years[years.length - 1],
      atRetirementCapitalValue:
        projectedHousePrice[projectedHousePrice.length - 1],
      atRetirementAnnualRent: rentalIncome[rentalIncome.length - 1],
      atRetirementCombinedDailyGain:
        combinedDailyGain[combinedDailyGain.length - 1],
      atRetirementCumulativeRentalProfit: round2(runningRentalProfit),

      estimatedValueNow: num(p.estimatedValue, 0),
      priceValuationOnJoiningAddressed: num(
        p.priceValuationOnJoiningAddressed,
        num(p.purchasePrice, 0),
      ),
      previousRentalIncome: num(p.previousRentalIncome, 0),
      previousExpenses: num(p.previousExpenses, 0),

      lastComputedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      ratesVersionUsed: yearClose.ratesVersion,
      schemaVersion: "recalculatePropertyData@2026-11-06",
    };

    if (Object.keys(yearClose.propUpdates).length === 0) {
      await projRef.set(projectionPayload, { merge: false });
    } else {
      // Property and projection change together, so no screen ever counts a
      // closed year twice. If the property moved underneath us, whichever run
      // caused that handles the close instead: closing happens only once.
      const written = await db.runTransaction(async (t) => {
        const latest = await t.get(propRef);
        if (
          tsMillis(latest.get("lastAccruedPeriodStart")) !== originalMarkerMs ||
          latest.get("estimatedValue") !== originalEstimatedValue
        ) {
          return false;
        }
        t.update(propRef, {
          ...yearClose.propUpdates,
          _engineWriteAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        t.set(projRef, projectionPayload);
        for (const v of yearClose.valuationUpdates || []) {
          t.update(v.ref, {
            status: v.status,
            appliedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        }
        return true;
      });
      if (!written) {
        functions.logger.info("Year close abandoned: property changed", {
          propertyId,
        });
        return { skipped: false, abandoned: true };
      }
      functions.logger.info("Year close applied", {
        propertyId,
        ...yearClose.summary,
      });
    }

    functions.logger.info("Projection written", {
      propertyId,
      ownerId,
      years: years.length,
      expenseInflationPctUsed: expenseInflationPct,
    });

    return { skipped: false };
  } finally {
    // END: atomic decrement + flip flag iff last job
    if (userRef) {
      try {
        let nextCount = null;
        await db.runTransaction(async (t) => {
          const u = await t.get(userRef);
          const cur = Number(u.get("calculatingProjectionsCount") || 0);
          const next = Math.max(0, cur - 1);
          nextCount = next;
          const update = {
            calculatingProjectionsCount: next,
            calculatingProjections: next > 0 ? true : false,
            lastProjectionCompletedAt:
              admin.firestore.FieldValue.serverTimestamp(),
          };
          t.update(userRef, update);
        });
        if (nextCount === 0) {
          await maybeSetFirstProjectionsRun(db, userRef, ownerId);
        }
      } catch (err) {
        functions.logger.error("Flag reset failed", {
          ownerId,
          error: err && err.message,
        });
      }
    }
  }
}

// ───────────────────────── YEAR CLOSE ─────────────────────────

const SOURCE_ESTIMATE = "from_estimate";
const SOURCE_MANUAL = "manual_entry";

function isOwnEngineWrite(before, after) {
  return tsMillis(before._engineWriteAt) !== tsMillis(after._engineWriteAt);
}

function tsMillis(v) {
  return v && typeof v.toMillis === "function" ? v.toMillis() : null;
}

/** off: nothing closes. test: isAuditFixture properties only. live: everything. */
function engineEnabledFor(mode, propertyData) {
  if (mode === "live") return true;
  return mode === "test" && propertyData.isAuditFixture === true;
}

function propertyYearStartFor(ymd, joinMonth, joinDay) {
  const ann = makeAnniversaryYMD(ymd.y, joinMonth, joinDay);
  return cmpYMD(ymd, ann) >= 0 ? ymd.y : ymd.y - 1;
}

/**
 * Works out what closing should do. Pure: no reads, no writes, no clock.
 *
 * Rules agreed 5 Nov 2026:
 * - Banks projected rent and expenses, using the stored figures for the year
 *   the app was counting so "since joining" carries on smoothly.
 * - Never backfills: a property the app wasn't counting just starts from its
 *   current year. A stale projection is the exception, because its year was
 *   being counted, so that year closes even with no marker.
 * - A value or expenses figure typed since the projection was built is a real
 *   figure, so it is kept rather than stepped.
 */
function planYearClose(input) {
  const { join, today, marker, stored, housePctFor, expensePct } = input;
  const none = { action: "none" };
  if (!join || cmpYMD(today, join) < 0) return none;

  const currentYear = propertyYearStartFor(today, join.m, join.d);
  const init = { action: "init", markerYear: currentYear };
  const markerYear = marker
    ? propertyYearStartFor(marker, join.m, join.d)
    : null;

  // Never had a projection, so the app wasn't counting anything to bank.
  if (!stored) {
    return markerYear !== null && markerYear >= currentYear ? none : init;
  }

  const firstEnd = (stored.periodEndDates || [])[0];
  const stale = !!firstEnd && firstEnd < ymdToString(today);
  const fromYear =
    markerYear !== null ? markerYear : stale ? stored.startYear : null;

  if (fromYear === null) return init;
  if (fromYear >= currentYear) return none;

  const differs = (a, b) =>
    Number.isFinite(a) && Number.isFinite(b) && Math.abs(a - b) > 0.005;
  const firstOf = (list) =>
    Array.isArray(list) && Number.isFinite(list[0]) ? list[0] : NaN;

  const valueWasTyped = differs(stored.estimatedValueNow, input.estimatedValue);
  const expensesWereTyped = differs(firstOf(stored.expenses), input.expenses);

  let value = input.estimatedValue;
  let expenses = input.expenses;
  let bankedRent = 0;
  let bankedExpenses = 0;
  let valueStepped = false;
  let expensesStepped = false;
  const closedYears = [];

  for (let y = fromYear; y < currentYear; y++) {
    // Skip years that started before this property joined.
    if (cmpYMD(makeAnniversaryYMD(y, join.m, join.d), join) < 0) continue;

    const isStoredYear = y === stored.startYear;
    const storedRent = isStoredYear ? firstOf(stored.rentalIncome) : NaN;
    const storedExpenses = isStoredYear ? firstOf(stored.expenses) : NaN;

    bankedRent += Number.isFinite(storedRent) ? storedRent : input.rentPCM * 12;
    bankedExpenses += Number.isFinite(storedExpenses)
      ? storedExpenses
      : expenses;

    // Growth only moves for years the projection hadn't already rolled past.
    if (y >= stored.startYear && !valueWasTyped && value > 0) {
      const storedGain = isStoredYear ? firstOf(stored.capitalGains) : NaN;
      value += Number.isFinite(storedGain)
        ? storedGain
        : value * (housePctFor(y) / 100);
      valueStepped = true;
    }
    if (!expensesWereTyped && expenses > 0) {
      expenses *= 1 + expensePct / 100;
      expensesStepped = true;
    }
    closedYears.push(y);
  }

  return {
    action: "close",
    markerYear: currentYear,
    closedYears,
    bankedRent: round2(bankedRent),
    bankedExpenses: round2(bankedExpenses),
    value: round2(value),
    expenses: round2(expenses),
    valueStepped,
    expensesStepped,
  };
}

async function resolveYearClose({ db, propRef, propertyId, p, now }) {
  const cfgSnap = await db.collection("appConfig").doc("projections").get();
  const cfg = cfgSnap.exists ? cfgSnap.data() || {} : {};
  const result = {
    propUpdates: {},
    rebuildValues: {},
    summary: {},
    ratesVersion: cfg.ratesVersion || null,
  };
  if (!engineEnabledFor(cfg.propertyYearMode, p)) return result;

  const joinedTs = p.dateJoinedAddressed;
  const join =
    joinedTs && typeof joinedTs.toDate === "function"
      ? ymdInLondon(joinedTs.toDate())
      : null;
  const markerTs = p.lastAccruedPeriodStart;
  const marker =
    markerTs && typeof markerTs.toDate === "function"
      ? ymdInLondon(markerTs.toDate())
      : null;

  const [storedSnap, houseOvSnap, houseGlobalSnap, expensePct, waitingSnap] =
    await Promise.all([
      db.collection("propertyProjections").doc(propertyId).get(),
      propRef.collection("housePriceOverrides").get(),
      db.collection("housePriceYears").get(),
      resolveGlobalExpenseInflationPct({ db, contextId: propertyId }),
      propRef.collection("valuations").where("status", "==", "waiting").get(),
    ]);
  const houseOverride = toYearPctMap(houseOvSnap);
  const houseGlobal = toYearPctMap(houseGlobalSnap);

  const estimatedValue = num(p.estimatedValue, 0);
  const expenses = num(p.averageYearlyExpenses, 0);
  const plan = planYearClose({
    join,
    today: ymdInLondon(now),
    marker,
    stored: storedSnap.exists ? storedSnap.data() : null,
    estimatedValue,
    expenses,
    rentPCM: Math.max(0, num(p.currentRentAmount, 0)),
    housePctFor: (y) => pickPct(y, houseOverride, houseGlobal, 3.0),
    expensePct,
  });

  const u = {};

  // A valuation entered early waits here until its anniversary has passed.
  const today = ymdInLondon(now);
  const chosen = chooseWaitingValuation(
    waitingSnap.docs.map((d) => ({ ref: d.ref, ...d.data() })),
    join && cmpYMD(today, join) >= 0
      ? propertyYearStartFor(today, join.m, join.d)
      : null,
  );

  // A value differing from our last step can only have been typed by someone.
  const valueSource =
    num(p.lastEstimatedStepValue, NaN) === estimatedValue
      ? SOURCE_ESTIMATE
      : SOURCE_MANUAL;
  const expensesSource =
    num(p.lastEstimatedExpensesValue, NaN) === expenses
      ? SOURCE_ESTIMATE
      : SOURCE_MANUAL;
  if (p.valuationSource !== valueSource) u.valuationSource = valueSource;
  if (p.expensesSource !== expensesSource) u.expensesSource = expensesSource;

  if (plan.action !== "none") {
    const y = plan.markerYear;
    u.lastAccruedPeriodStart = admin.firestore.Timestamp.fromDate(
      londonMidnightAsUTCDate(makeAnniversaryYMD(y, join.m, join.d)),
    );
  }

  if (plan.action === "close") {
    const income = round2(num(p.previousRentalIncome, 0) + plan.bankedRent);
    const spent = round2(num(p.previousExpenses, 0) + plan.bankedExpenses);
    u.previousRentalIncome = income;
    u.previousExpenses = spent;
    u.lastAccruedRentalAmount = plan.bankedRent;
    u.lastAccruedExpenseAmount = plan.bankedExpenses;
    u.lastAccruedSource = SOURCE_ESTIMATE;
    u.lastAccruedAt = admin.firestore.FieldValue.serverTimestamp();
    result.rebuildValues.previousRentalIncome = income;
    result.rebuildValues.previousExpenses = spent;

    if (plan.valueStepped && !chosen.apply) {
      u.estimatedValue = plan.value;
      u.lastEstimatedStepValue = plan.value;
      u.valuationSource = SOURCE_ESTIMATE;
      result.rebuildValues.estimatedValue = plan.value;
    }
    if (plan.expensesStepped) {
      u.averageYearlyExpenses = plan.expenses;
      u.lastEstimatedExpensesValue = plan.expenses;
      u.expensesSource = SOURCE_ESTIMATE;
      result.rebuildValues.averageYearlyExpenses = plan.expenses;
    }
    result.summary = {
      closedYears: plan.closedYears,
      bankedRent: plan.bankedRent,
      bankedExpenses: plan.bankedExpenses,
      value: plan.value,
      expenses: plan.expenses,
    };
  }

  if (chosen.apply) {
    u.estimatedValue = chosen.apply.value;
    u.valuationSource = SOURCE_MANUAL;
    result.rebuildValues.estimatedValue = chosen.apply.value;
    result.summary.valuationApplied = chosen.apply.value;
    result.valuationUpdates = [
      { ref: chosen.apply.ref, status: "applied" },
      ...chosen.replaced.map((v) => ({ ref: v.ref, status: "replaced" })),
    ];
  }

  result.propUpdates = u;
  return result;
}

/**
 * Picks the valuation to use from those still waiting. Pure.
 * Only anniversaries that have arrived count. The latest anniversary wins, then
 * the most recently entered, and the others due at the same time are replaced.
 */
function chooseWaitingValuation(waiting, currentYear) {
  if (currentYear === null) return { apply: null, replaced: [] };
  const due = waiting
    .filter(
      (v) =>
        Number.isFinite(Number(v.anniversaryYear)) &&
        Number(v.anniversaryYear) <= currentYear &&
        num(v.value, 0) > 0,
    )
    .map((v) => ({ ...v, value: num(v.value, 0) }))
    .sort(
      (a, b) =>
        Number(b.anniversaryYear) - Number(a.anniversaryYear) ||
        (tsMillis(b.createdAt) || 0) - (tsMillis(a.createdAt) || 0),
    );
  return { apply: due[0] || null, replaced: due.slice(1) };
}

// Tests only. FlutterFlow's index.js wires up named functions, so this is unused live.
exports._test = {
  chooseWaitingValuation,
  planYearClose,
  engineEnabledFor,
  isOwnEngineWrite,
  computePropertyProjectionCore,
};

// ───────────────────────── UTILS ─────────────────────────

/** Legacy: missing completedOnboarding → allow. Only explicit false blocks. */
function isCompletedOnboardingForProjections(userData) {
  const v = userData && userData.completedOnboarding;
  if (v === false) return false;
  return true;
}

/**
 * After the last in-flight projection job for this user (count → 0), set
 * firstProjectionsRun when every owned property has a propertyProjections doc
 * for this ownerRef, and onboarding is complete.
 */
async function maybeSetFirstProjectionsRun(db, userRef, ownerId) {
  try {
    const uSnap = await userRef.get();
    if (!uSnap.exists) return;
    const d = uSnap.data() || {};
    if (d.firstProjectionsRun === true) return;
    if (!isCompletedOnboardingForProjections(d)) return;

    const [propsOwnerID, propsOwnerId] = await Promise.all([
      db.collection("properties").where("ownerID", "==", ownerId).get(),
      db.collection("properties").where("ownerId", "==", ownerId).get(),
    ]);
    const seenPaths = new Set();
    propsOwnerID.docs.forEach((doc) => seenPaths.add(doc.ref.path));
    propsOwnerId.docs.forEach((doc) => seenPaths.add(doc.ref.path));
    const allPaths = Array.from(seenPaths);

    if (allPaths.length === 0) {
      await userRef.set({ firstProjectionsRun: true }, { merge: true });
      functions.logger.info("firstProjectionsRun set (no properties)", {
        ownerId,
      });
      return;
    }

    const projSnap = await db
      .collection("propertyProjections")
      .where("ownerRef", "==", userRef)
      .get();

    const coveredPaths = new Set();
    projSnap.docs.forEach((doc) => {
      const pr = doc.get("propertyRef");
      if (pr && typeof pr.path === "string") coveredPaths.add(pr.path);
    });

    const missing = allPaths.filter((path) => !coveredPaths.has(path));
    if (missing.length > 0) {
      functions.logger.debug(
        "firstProjectionsRun not set yet; missing coverage",
        {
          ownerId,
          missingCount: missing.length,
        },
      );
      return;
    }

    await userRef.set({ firstProjectionsRun: true }, { merge: true });
    functions.logger.info("firstProjectionsRun set", { ownerId });
  } catch (err) {
    functions.logger.error("maybeSetFirstProjectionsRun failed", {
      ownerId,
      error: err && err.message,
    });
  }
}

function getOwnerUserIdFromPropertyData(p) {
  return String(p.ownerID || "").trim() || null;
}

function num(v, fallback) {
  const n = typeof v === "string" ? Number(v) : typeof v === "number" ? v : NaN;
  return Number.isFinite(n) ? n : fallback;
}

async function resolveGlobalExpenseInflationPct(args) {
  const { db, contextId } = args;
  const DEFAULT_PCT = 3.0;

  try {
    const cfgSnap = await db.collection("appConfig").doc("projections").get();

    if (!cfgSnap.exists) {
      functions.logger.warn(
        "Global projections config missing; using default expenseInflationPct",
        { contextId, fallback: DEFAULT_PCT },
      );
      return DEFAULT_PCT;
    }

    const raw = cfgSnap.get("expenseInflationPct");
    const pct = num(raw, NaN);

    if (!Number.isFinite(pct) || pct <= 0) {
      functions.logger.warn(
        "Invalid global expenseInflationPct; using default",
        { contextId, raw, parsed: pct, fallback: DEFAULT_PCT },
      );
      return DEFAULT_PCT;
    }

    return pct;
  } catch (err) {
    functions.logger.error(
      "Failed reading global expenseInflationPct; using default",
      { contextId, error: err && err.message, fallback: DEFAULT_PCT },
    );
    return DEFAULT_PCT;
  }
}

async function resolveEndYear(db, p, startYear) {
  let dobTs = null; // property doesn't store this
  let retirementAge = NaN; // property doesn't store this

  const ownerId = getOwnerUserIdFromPropertyData(p) || "";

  if (ownerId) {
    const userSnap = await db.collection("users").doc(ownerId).get();
    if (userSnap.exists) {
      const u = userSnap.data() || {};
      dobTs = u.dob || null; // strict
      retirementAge = num(u.planned_retirement_age, NaN); // strict
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
    // Try to get year from field first, fallback to doc ID only if field is missing
    let year;
    if (d.year != null) {
      year = Number(d.year);
    } else {
      // Only use doc.id as fallback if it's numeric
      const docIdNum = Number(doc.id);
      year = Number.isFinite(docIdNum) ? docIdNum : null;
    }

    const pct = d.pct != null ? Number(d.pct) : null;

    if (Number.isFinite(year) && Number.isFinite(pct)) {
      out[year] = pct;
    } else {
      functions.logger.warn("Skipped invalid year/pct document", {
        docId: doc.id,
        year: d.year,
        yearParsed: year,
        pct: d.pct,
        pctParsed: pct,
      });
    }
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

const LONDON_TZ = "Europe/London";

function ymdInLondon(dateObj) {
  // Returns { y, m, d } as numbers in Europe/London, avoiding timezone off-by-one.
  const parts = new Intl.DateTimeFormat("en-GB", {
    timeZone: LONDON_TZ,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(dateObj);

  const get = (type) => Number(parts.find((p) => p.type === type)?.value);
  return { y: get("year"), m: get("month"), d: get("day") };
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

function ymdToUTCDate(ymd) {
  return new Date(Date.UTC(ymd.y, ymd.m - 1, ymd.d));
}

function ymdMinusOneDay(ymd) {
  const dt = ymdToUTCDate(ymd);
  dt.setUTCDate(dt.getUTCDate() - 1);
  return {
    y: dt.getUTCFullYear(),
    m: dt.getUTCMonth() + 1,
    d: dt.getUTCDate(),
  };
}

function londonMidnightAsUTCDate(ymd) {
  // UTC midnight of that date, shifted back by whatever London's clock reads then.
  const dt = new Date(Date.UTC(ymd.y, ymd.m - 1, ymd.d, 0, 0, 0));
  const parts = new Intl.DateTimeFormat("en-GB", {
    timeZone: LONDON_TZ,
    hour: "2-digit",
    minute: "2-digit",
    hourCycle: "h23",
  }).formatToParts(dt);
  const get = (type) => Number(parts.find((x) => x.type === type)?.value);
  return new Date(dt.getTime() - (get("hour") * 60 + get("minute")) * 60000);
}

function ymdToString(ymd) {
  const pad = (n) => String(n).padStart(2, "0");
  return `${ymd.y}-${pad(ymd.m)}-${pad(ymd.d)}`;
}

function formatYMDLabel(ymd) {
  return new Intl.DateTimeFormat("en-GB", {
    timeZone: LONDON_TZ,
    day: "numeric",
    month: "short",
    year: "numeric",
  }).format(ymdToUTCDate(ymd));
}
