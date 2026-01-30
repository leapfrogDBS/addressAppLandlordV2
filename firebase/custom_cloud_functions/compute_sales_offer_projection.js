const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (!admin.apps.length) {
  admin.initializeApp();
}

const REGION = "us-central1";
const PROJECTION_END_YEAR = 2050;

const fieldsToWatch = ["price", "monthlyRental", "estimatedYearlyExpenses"];

function num(v, fallback) {
  const n = typeof v === "string" ? Number(v) : typeof v === "number" ? v : NaN;
  return Number.isFinite(n) ? n : fallback;
}

function toYearPctMap(querySnap) {
  const out = {};
  querySnap.forEach((doc) => {
    const d = doc.data() || {};
    let year = d.year != null ? Number(d.year) : Number(doc.id);
    const pct = d.pct != null ? Number(d.pct) : null;
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

exports.computeSalesOfferProjection = functions
  .region(REGION)
  .runWith({ memory: "256MB", timeoutSeconds: 60 })
  .firestore.document("salesOffers/{offerId}")
  .onWrite(async (change, context) => {
    const offerId = context.params.offerId;
    const db = admin.firestore();

    if (!change.before.exists) {
      try {
        await computeSalesOfferProjectionCore(db, offerId, change.after.data());
      } catch (err) {
        functions.logger.error("Sales offer projection failed (onCreate)", {
          offerId,
          error: err && err.message,
        });
      }
      return null;
    }

    const before = change.before.data() || {};
    const after = change.after.data() || {};
    const changed = fieldsToWatch.some(
      (k) => String(before[k]) !== String(after[k]),
    );
    if (!changed) {
      functions.logger.info("No projection-relevant changes", { offerId });
      return null;
    }
    try {
      await computeSalesOfferProjectionCore(db, offerId, after);
    } catch (err) {
      functions.logger.error("Sales offer projection failed (onUpdate)", {
        offerId,
        error: err && err.message,
      });
    }
    return null;
  });

async function computeSalesOfferProjectionCore(db, offerId, offer) {
  const now = new Date();
  const startYear = now.getFullYear();
  const endYear = Math.min(PROJECTION_END_YEAR, startYear + 50);

  const price = num(offer.price, 0);
  const monthlyRental = num(offer.monthlyRental, 0);
  const annualRent0 = monthlyRental * 12;
  const expenseBase = num(offer.estimatedYearlyExpenses, 0);
  const expenseInflationPct = 3.0;

  const [houseGlobalSnap, rentGlobalSnap] = await Promise.all([
    db.collection("housePriceYears").get(),
    db.collection("rentIncreaseYears").get(),
  ]);
  const houseGlobal = toYearPctMap(houseGlobalSnap);
  const rentGlobal = toYearPctMap(rentGlobalSnap);

  const years = [];
  const projectedHousePrice = [];
  const rentalIncome = [];
  const expenses = [];
  const rentalProfit = [];
  const cumulativeRentalProfit = [];
  const combinedDailyGain = [];

  let rollingCapital = price;
  let rollingRent = annualRent0;
  let rollingExpenses = expenseBase;
  let runningRentalProfit = 0;

  for (let y = startYear; y <= endYear; y++) {
    const housePct = pickPct(y, {}, houseGlobal, 3.0);
    const rentPct = pickPct(y, {}, rentGlobal, 3.0);

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

    const totalAnnualGainY = capGainY + annualProfitY;
    combinedDailyGain.push(round2(totalAnnualGainY / 365));

    if (y < endYear) {
      rollingCapital = nextCap;
      rollingRent = rollingRent * (1 + rentPct / 100);
      rollingExpenses = rollingExpenses * (1 + expenseInflationPct / 100);
    }
  }

  const projRef = db
    .collection("salesOffers")
    .doc(offerId)
    .collection("projections")
    .doc("default");

  const payload = {
    salesOfferRef: db.collection("salesOffers").doc(offerId),
    startYear,
    endYear,
    years,
    projectedHousePrice,
    rentalIncome,
    expenses,
    rentalProfit,
    cumulativeRentalProfit,
    combinedDailyGain,
    lastComputedAt: admin.firestore.FieldValue.serverTimestamp(),
    schemaVersion: "computeSalesOfferProjection@2026-01-30",
  };

  await projRef.set(payload, { merge: false });

  functions.logger.info("Sales offer projection written", {
    offerId,
    startYear,
    endYear,
    yearsCount: years.length,
  });
}
