// FlutterFlow-friendly: do NOT call admin.initializeApp() here.
const functions = require("firebase-functions");
const admin = require("firebase-admin");

const REGION = "us-central1";

exports.onTenancyWriteSyncCurrentRent = functions
  .region(REGION)
  .runWith({ memory: "128MB" })
  .firestore.document("properties/{propertyId}/tenancies/{tenancyId}")
  .onWrite(async (change, context) => {
    const propertyId = context.params.propertyId;

    const db = admin.firestore();
    const propRef = db.collection("properties").doc(propertyId);
    const tenanciesRef = propRef.collection("tenancies");

    const normNum = (v) => {
      if (v == null) return null;
      if (typeof v === "number") return Number.isFinite(v) ? v : null;
      if (typeof v === "string") {
        const x = Number(v);
        return Number.isFinite(x) ? x : null;
      }
      return null;
    };

    // Prefer latest tenancyStartDate; fallback to last_updated_at.
    // NOTE: if tenancyStartDate is null on some docs, Firestore ordering can be awkward.
    // Ideally tenancyStartDate is always set for real tenancies.
    let activeSnap;
    try {
      activeSnap = await tenanciesRef
        .where("isActive", "==", true)
        .orderBy("tenancyStartDate", "desc")
        .limit(2)
        .get();
    } catch (e) {
      // Fallback index/order if tenancyStartDate isn't present or index missing
      functions.logger.warn(
        "[tenancy-sync] tenancyStartDate orderBy failed, falling back to last_updated_at",
        {
          propertyId,
          error: e && e.message ? e.message : String(e),
        },
      );

      activeSnap = await tenanciesRef
        .where("isActive", "==", true)
        .orderBy("last_updated_at", "desc")
        .limit(2)
        .get();
    }

    // Read property once so we can avoid pointless writes/pokes
    const propSnap = await propRef.get();
    if (!propSnap.exists) return null;
    const p = propSnap.data() || {};

    const prevRent = normNum(p.currentRentAmount) ?? 0;
    const prevHasActive =
      typeof p.hasActiveTenancy === "boolean" ? p.hasActiveTenancy : false;
    const prevTenancyId = p.currentTenancyId || "";

    const updates = {};
    let poke = false;

    if (activeSnap.empty) {
      // No active tenancy -> keep last known rent, but mark inactive
      if (prevHasActive !== false) {
        updates.hasActiveTenancy = false;
        poke = true; // optional; harmless. If you don't care, remove this poke.
      } else {
        // still set explicitly only if you want property to always have the field
        // updates.hasActiveTenancy = false;
      }
      // do NOT change currentRentAmount
      // do NOT change currentTenancyId (optional; you can clear it if you prefer)
      // updates.currentTenancyId = admin.firestore.FieldValue.delete();
    } else {
      const chosen = activeSnap.docs[0];

      const rentPCM = Math.max(0, normNum(chosen.get("rentAmount")) ?? 0);
      const chosenId = chosen.id;

      if (prevHasActive !== true) {
        updates.hasActiveTenancy = true;
        poke = true; // optional UI signal
      } else {
        // keep it set if you want it always present
        updates.hasActiveTenancy = true;
      }

      if (prevRent !== rentPCM) {
        updates.currentRentAmount = rentPCM;
        poke = true; // projections depend on rent
      } else {
        // still ensure the field exists if you want
        // updates.currentRentAmount = rentPCM;
      }

      if (prevTenancyId !== chosenId) {
        updates.currentTenancyId = chosenId; // optional debug
        // no need to poke for this alone
      }

      // Log if 2+ active tenancies exist (your enforcement should prevent this)
      if (activeSnap.size > 1) {
        functions.logger.warn(
          "[tenancy-sync] multiple active tenancies detected",
          {
            propertyId,
            activeTenancyIds: activeSnap.docs.map((d) => d.id),
          },
        );
      }
    }

    if (poke) {
      updates._recalcTrigger = admin.firestore.FieldValue.serverTimestamp();
    }

    if (Object.keys(updates).length === 0) return null;

    await propRef.set(updates, { merge: true });

    functions.logger.info("[tenancy-sync] synced tenancy -> property", {
      propertyId,
      updates,
    });

    return null;
  });
