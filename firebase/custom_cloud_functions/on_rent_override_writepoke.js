const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.onRentOverrideWritepoke = functions
  .region("us-central1")
  .runWith({ memory: "128MB" })
  .firestore.document("properties/{propertyId}/rentalIncreaseOverrides/{docId}")
  .onWrite(async (change, context) => {
    const db = admin.firestore();
    await db.collection("properties").doc(context.params.propertyId).update({
      _recalcTrigger: admin.firestore.FieldValue.serverTimestamp(),
    });
    functions.logger.info("[rent-ovr-poke] recalc triggered", {
      propertyId: context.params.propertyId,
    });
    return null;
  });
