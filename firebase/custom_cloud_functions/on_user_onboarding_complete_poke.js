const functions = require("firebase-functions");
const admin = require("firebase-admin");
// Do NOT call admin.initializeApp() in FF editor

exports.onUserOnboardingCompletePoke = functions
  .region("us-central1")
  .runWith({ memory: "128MB" })
  .firestore.document("users/{userId}")
  .onUpdate(async (change, context) => {
    const db = admin.firestore();
    const userId = context.params.userId;
    const userRef = db.collection("users").doc(userId);

    const before = change.before.data() || {};
    const after = change.after.data() || {};

    const becameComplete =
      before.completedOnboarding !== true && after.completedOnboarding === true;

    if (!becameComplete) {
      return null;
    }

    if (after.status !== "active") {
      functions.logger.info(
        "[onboarding-poke] skipped because user not active",
        { userId, status: after.status || null },
      );
      return null;
    }

    if (after.completedOnboarding === false) {
      functions.logger.info(
        "[onboarding-poke] skipped because completedOnboarding is false",
        { userId },
      );
      return null;
    }

    const [s1, s2] = await Promise.all([
      db.collection("properties").where("ownerID", "==", userId).get(),
      db.collection("properties").where("ownerId", "==", userId).get(),
    ]);

    const seen = new Set();
    const propRefs = [];
    [s1, s2].forEach((snap) =>
      snap.forEach((doc) => {
        if (seen.has(doc.id)) return;
        seen.add(doc.id);
        propRefs.push(db.collection("properties").doc(doc.id));
      }),
    );
    const n = propRefs.length;
    functions.logger.info("[onboarding-poke] triggering properties", {
      userId,
      count: n,
    });
    if (n > 0) {
      // Seed counter for the whole batch BEFORE poking properties
      await userRef.set(
        {
          calculatingProjections: true,
          calculatingProjectionsCount: admin.firestore.FieldValue.increment(n),
          lastProjectionStartedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true },
      );
      await Promise.all(
        propRefs.map((ref) =>
          ref.update({
            _recalcTrigger: admin.firestore.FieldValue.serverTimestamp(),
            _projectionSlotReserved: true,
          }),
        ),
      );
    }
    await userRef.set(
      {
        lastOnboardingProjectionsPokeAt:
          admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
    return null;
  });
