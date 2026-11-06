// FlutterFlow-friendly: do NOT call admin.initializeApp() here.
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const crypto = require("crypto");

const REGION = "us-central1";
const LONDON_TZ = "Europe/London";
const MAX_POKES_PER_RUN = 100; // anything over this waits for the next night

// Finds properties that are due and pokes them. recalculatePropertyData does
// the actual close and rebuild, the same way the override pokes already work.
exports.propertyYearNightly = functions
  .region(REGION)
  .runWith({ memory: "256MB", timeoutSeconds: 300 })
  .pubsub.schedule("30 2 * * *")
  .timeZone(LONDON_TZ)
  .onRun(async () => {
    const result = await runNightly({ db: admin.firestore(), now: new Date() });
    functions.logger.info("[property-year] nightly finished", result);
    return null;
  });

async function runNightly({ db, now }) {
  const cfgRef = db.collection("appConfig").doc("projections");
  const cfgSnap = await cfgRef.get();
  const cfg = cfgSnap.exists ? cfgSnap.data() || {} : {};
  const mode = cfg.propertyYearMode || "off";
  if (mode !== "test" && mode !== "live") return { mode, poked: 0 };

  const [houseSnap, rentSnap, propsSnap, projSnap, usersSnap] =
    await Promise.all([
      db.collection("housePriceYears").get(),
      db.collection("rentIncreaseYears").get(),
      db.collection("properties").get(),
      db.collection("propertyProjections").get(),
      db.collection("users").select("completedOnboarding").get(),
    ]);

  // A global rate change gets a new version. Properties catch up in batches.
  const ratesVersion = hashRates(houseSnap, rentSnap, cfg.expenseInflationPct);
  if (cfg.ratesVersion !== ratesVersion) {
    await cfgRef.set({ ratesVersion }, { merge: true });
  }

  const projections = new Map(projSnap.docs.map((d) => [d.id, d.data()]));
  const users = new Map(usersSnap.docs.map((d) => [d.id, d.data()]));
  const today = ymdInLondon(now);

  const due = [];
  for (const doc of propsSnap.docs) {
    const prop = doc.data() || {};
    if (mode === "test" && prop.isAuditFixture !== true) continue;
    const reason = dueReason({
      prop,
      projection: projections.get(doc.id) || null,
      owner: users.get(String(prop.ownerID || "").trim()) || null,
      today,
      ratesVersion,
    });
    if (reason) due.push({ ref: doc.ref, reason });
  }

  // Anniversaries go first, so a big rate change can't delay a year close.
  const rank = { year_ended: 0, close_behind: 0, missing: 1, rates: 2 };
  due.sort((a, b) => rank[a.reason] - rank[b.reason]);
  const batch = due.slice(0, MAX_POKES_PER_RUN);

  await Promise.all(
    batch.map((d) =>
      d.ref
        .update({
          _recalcTrigger: admin.firestore.FieldValue.serverTimestamp(),
        })
        .catch((err) =>
          functions.logger.error("[property-year] poke failed", {
            path: d.ref.path,
            error: err && err.message,
          }),
        ),
    ),
  );

  const counts = {};
  for (const d of due) counts[d.reason] = (counts[d.reason] || 0) + 1;
  return { mode, due: due.length, poked: batch.length, counts };
}

/** Returns why this property needs a recalculation, or null. Pure. */
function dueReason({ prop, projection, owner, today, ratesVersion }) {
  // Owners who haven't finished onboarding get projections from the onboarding
  // poke, so they are deliberately left alone here.
  if (!owner || owner.completedOnboarding === false) return null;
  if (!projection) return "missing";

  const firstEnd = (projection.periodEndDates || [])[0];
  if (firstEnd && firstEnd < ymdToString(today)) return "year_ended";

  const joined = prop.dateJoinedAddressed;
  const marker = prop.lastAccruedPeriodStart;
  if (
    joined &&
    typeof joined.toDate === "function" &&
    marker &&
    typeof marker.toDate === "function"
  ) {
    const j = ymdInLondon(joined.toDate());
    if (
      cmpYMD(today, j) >= 0 &&
      propertyYearStart(ymdInLondon(marker.toDate()), j) <
        propertyYearStart(today, j)
    ) {
      return "close_behind";
    }
  }

  return projection.ratesVersionUsed === ratesVersion ? null : "rates";
}

function hashRates(houseSnap, rentSnap, expenseInflationPct) {
  const rows = (snap) =>
    snap.docs
      .map((d) => [d.id, d.get("year") ?? null, d.get("pct") ?? null])
      .sort((a, b) => String(a[0]).localeCompare(String(b[0])));
  const text = JSON.stringify([
    rows(houseSnap),
    rows(rentSnap),
    expenseInflationPct ?? null,
  ]);
  return crypto.createHash("sha256").update(text).digest("hex").slice(0, 16);
}

function propertyYearStart(ymd, join) {
  const ann = { y: ymd.y, m: join.m, d: clampDay(ymd.y, join.m, join.d) };
  return cmpYMD(ymd, ann) >= 0 ? ymd.y : ymd.y - 1;
}

function clampDay(year, month1to12, day) {
  return Math.min(day, new Date(Date.UTC(year, month1to12, 0)).getUTCDate());
}

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

function cmpYMD(a, b) {
  if (a.y !== b.y) return a.y < b.y ? -1 : 1;
  if (a.m !== b.m) return a.m < b.m ? -1 : 1;
  if (a.d !== b.d) return a.d < b.d ? -1 : 1;
  return 0;
}

function ymdToString(ymd) {
  const pad = (n) => String(n).padStart(2, "0");
  return `${ymd.y}-${pad(ymd.m)}-${pad(ymd.d)}`;
}

// Tests only. FlutterFlow's index.js wires up named functions, so this is unused live.
exports._test = { runNightly, dueReason };
