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

    const fieldsToWatch = [
      "estimatedValue",
      "purchasePrice",
      "ownerID",
      "_recalcTrigger",
      "dateJoinedAddressed",
      "currentRentAmount",
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
  const p = propSnap.data() || {};

  // Resolve owner
  const ownerId = getOwnerUserIdFromPropertyData(p); // reads p.ownerID
  if (!ownerId) throw new Error("Property ownerID missing");
  const userRef = ownerId ? db.collection("users").doc(ownerId) : null;

  if (userRef) {
    const uSnap = await userRef.get();
    const uData = uSnap.exists ? uSnap.data() || {} : {};
    if (!isCompletedOnboardingForProjections(uData)) {
      functions.logger.info(
        "Projection skipped: completedOnboarding is false (onboarding not finished)",
        { propertyId, ownerId },
      );
      return { skipped: true };
    }
  }

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
      t.set(userRef, update, { merge: true });
    });
  }

  try {
    // ==== YOUR PROJECTION MATH (unchanged from your working version) ====

    const now = new Date();

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
      schemaVersion: "recalculatePropertyData@2026-01-30",
    };

    await projRef.set(projectionPayload, { merge: false });

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
