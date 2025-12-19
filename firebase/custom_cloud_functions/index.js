const admin = require("firebase-admin/app");
admin.initializeApp();

const computePropertyProjection = require("./compute_property_projection.js");
exports.computePropertyProjection =
  computePropertyProjection.computePropertyProjection;
const recalculatePropertyData = require("./recalculate_property_data.js");
exports.recalculatePropertyData =
  recalculatePropertyData.recalculatePropertyData;
const onUserRetirementChangepoke = require("./on_user_retirement_changepoke.js");
exports.onUserRetirementChangepoke =
  onUserRetirementChangepoke.onUserRetirementChangepoke;
const onTenancyWritepoke = require("./on_tenancy_writepoke.js");
exports.onTenancyWritepoke = onTenancyWritepoke.onTenancyWritepoke;
const onHouseOverrideWritepoke = require("./on_house_override_writepoke.js");
exports.onHouseOverrideWritepoke =
  onHouseOverrideWritepoke.onHouseOverrideWritepoke;
const onRentOverrideWritepoke = require("./on_rent_override_writepoke.js");
exports.onRentOverrideWritepoke =
  onRentOverrideWritepoke.onRentOverrideWritepoke;
const sendPasswordResetEmail = require("./send_password_reset_email.js");
exports.sendPasswordResetEmail = sendPasswordResetEmail.sendPasswordResetEmail;
