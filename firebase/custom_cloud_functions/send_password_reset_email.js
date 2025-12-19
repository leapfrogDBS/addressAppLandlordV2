const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code

exports.sendPasswordResetEmail = functions.https.onCall((data, _context) => {
  const email = String(data?.email || "")
    .trim()
    .toLowerCase();

  // Validate input
  if (!email) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Email is required.",
    );
  }

  // Always return the same response (don’t leak whether the user exists)
  const okResponse = {
    ok: true,
    message: "If that email exists, a password reset link has been sent.",
  };

  return admin
    .auth()
    .getUserByEmail(email)
    .then(() => {
      // User exists - generate password reset link
      return admin.auth().generatePasswordResetLink(email);
    })
    .then((firebaseLink) => {
      // Extract the oobCode from the Firebase link
      let oobCode = null;

      try {
        // Prefer WHATWG URL parsing
        const { URL } = require("url");
        const u = new URL(firebaseLink);
        oobCode = u.searchParams.get("oobCode");
      } catch (parseError) {
        // Fallback: manual parsing with regex
        const match = firebaseLink.match(/[?&]oobCode=([^&]+)/);
        oobCode = match ? decodeURIComponent(match[1]) : null;
      }

      if (!oobCode) {
        throw new Error("Failed to extract oobCode from password reset link");
      }

      // Create custom link to your password reset page
      const customLink =
        "https://adminapp.addressed.co/passwordReset?oobCode=" +
        encodeURIComponent(oobCode);

      // Build HTML email content
      const htmlContent =
        "<!DOCTYPE html>" +
        "<html>" +
        "<head>" +
        '<meta charset="utf-8">' +
        '<meta name="viewport" content="width=device-width, initial-scale=1.0">' +
        "</head>" +
        "<body style=\"margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f5f5f5;\">" +
        '<table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f5f5f5; padding: 20px;">' +
        "<tr>" +
        '<td align="center">' +
        '<table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08);">' +
        "<tr>" +
        '<td style="background-color: #ffffff; padding: 30px 30px 20px 30px; text-align: center; border-bottom: 1px solid #e8e8e8;">' +
        '<img src="https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/addressed-app-admin-tfpanq/assets/oxku0gyz828s/Addressed_logo_-_Transparent.png" alt="Addressed" style="max-width: 180px; height: auto; display: block; margin: 0 auto;" />' +
        "</td>" +
        "</tr>" +
        "<tr>" +
        '<td style="padding: 40px 30px;">' +
        '<p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0; font-weight: 500;">Reset Your Password</p>' +
        '<p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">We received a request to reset your password. Click the button below to set a new password:</p>' +
        '<div style="text-align: center; margin: 30px 0;">' +
        '<a href="' +
        customLink +
        '" style="display: inline-block; background-color: #153048; color: #ffffff; text-decoration: none; padding: 14px 32px; border-radius: 6px; font-size: 16px; font-weight: 500;">Reset Password</a>' +
        "</div>" +
        '<p style="color: #666666; font-size: 14px; line-height: 1.6; margin: 30px 0 0 0;">If you didn\'t request a password reset, you can safely ignore this email. Your password will remain unchanged.</p>' +
        '<p style="color: #999999; font-size: 12px; line-height: 1.6; margin: 20px 0 0 0;">This link is time-limited for security reasons.</p>' +
        "</td>" +
        "</tr>" +
        "<tr>" +
        '<td style="background-color: #f9f9f9; padding: 25px 30px; border-top: 1px solid #e8e8e8;">' +
        '<p style="color: #999999; font-size: 12px; line-height: 1.6; margin: 0 0 10px 0; text-align: center;">This is an automated message from Addressed. Please do not reply to this email.</p>' +
        '<p style="color: #999999; font-size: 11px; line-height: 1.6; margin: 0; text-align: center;">Addressed National Ltd | pm@addressed.co | +44 (0)333 038 6633</p>' +
        "</td>" +
        "</tr>" +
        "</table>" +
        "</td>" +
        "</tr>" +
        "</table>" +
        "</body>" +
        "</html>";

      const textContent =
        "Reset Your Password - Addressed\n\n" +
        "We received a request to reset your password. Use the link below to set a new password:\n\n" +
        customLink +
        "\n\n" +
        "If you didn't request a password reset, you can safely ignore this email. Your password will remain unchanged.\n\n" +
        "This link is time-limited for security reasons.\n\n" +
        "---\n" +
        "This is an automated message from Addressed. Please do not reply to this email.\n" +
        "Addressed National Ltd | pm@addressed.co | +44 (0)333 038 6633";

      // Create a document in the 'email' collection to trigger the email extension
      return admin
        .firestore()
        .collection("email")
        .add({
          to: email,
          message: {
            subject: "Reset Your Password - Addressed",
            html: htmlContent,
            text: textContent,
          },
        });
    })
    .then(() => okResponse)
    .catch((error) => {
      // If user doesn't exist, still return success (security best practice)
      if (error?.code === "auth/user-not-found") {
        return okResponse;
      }

      console.error("Error sending password reset email:", error);
      throw new functions.https.HttpsError(
        "internal",
        error?.message ||
          "Failed to send password reset email. Please try again.",
      );
    });
});
