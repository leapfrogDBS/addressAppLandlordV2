const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.onTenancyWritepoke = functions
  .region("us-central1")
  .runWith({ memory: "128MB" })
  .firestore.document("properties/{propertyId}/tenancies/{tenancyId}")
  .onWrite(async (change, context) => {
    const before = change.before.exists ? change.before.data() : null;
    const after = change.after.exists ? change.after.data() : null;

    // Treat create/delete as change; on update check rentAmount / isActive
    const rentChanged =
      before && after ? before.rentAmount !== after.rentAmount : true;
    const activeChanged =
      before && after
        ? (before.isActive ?? false) !== (after.isActive ?? false)
        : true;

    if (!rentChanged && !activeChanged) return null;

    const db = admin.firestore();
    await db.collection("properties").doc(context.params.propertyId).update({
      _recalcTrigger: admin.firestore.FieldValue.serverTimestamp(),
    });
    functions.logger.info("[tenancy-poke] recalc triggered", {
      propertyId: context.params.propertyId,
    });
    return null;
  });
