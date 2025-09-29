const functions = require("firebase-functions");
const admin = require("firebase-admin");
// Do NOT call admin.initializeApp() in FF editor

exports.onUserRetirementChangepoke = functions
  .region("us-central1")
  .runWith({ memory: "128MB" })
  .firestore.document("users/{userId}")
  .onUpdate(async (change, context) => {
    const db = admin.firestore();
    const userId = context.params.userId;

    const before = change.before.data() || {};
    const after = change.after.data() || {};

    // Only react if one of these changed
    const watched = ["dateOfBirth", "planned_retirement_age", "retirementAge"];
    const changed = watched.some(
      (k) => JSON.stringify(before[k]) !== JSON.stringify(after[k]),
    );
    if (!changed) {
      functions.logger.debug("[user-poke] no relevant change", { userId });
      return null;
    }

    // Find all properties owned by this user (ownerID OR ownerId)
    const [s1, s2] = await Promise.all([
      db.collection("properties").where("ownerID", "==", userId).get(),
      db.collection("properties").where("ownerId", "==", userId).get(),
    ]);

    const seen = new Set();
    const updates = [];
    [s1, s2].forEach((snap) =>
      snap.forEach((doc) => {
        if (seen.has(doc.id)) return;
        seen.add(doc.id);
        updates.push(
          db.collection("properties").doc(doc.id).update({
            _recalcTrigger: admin.firestore.FieldValue.serverTimestamp(),
          }),
        );
      }),
    );

    functions.logger.info("[user-poke] triggering properties", {
      count: updates.length,
    });
    if (updates.length) await Promise.all(updates);
    return null;
  });
