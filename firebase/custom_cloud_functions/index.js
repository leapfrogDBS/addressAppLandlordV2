const admin = require("firebase-admin/app");
admin.initializeApp();

const recalculatePropertyData = require("./recalculate_property_data.js");
exports.recalculatePropertyData =
  recalculatePropertyData.recalculatePropertyData;
const onUserRetirementChangepoke = require("./on_user_retirement_changepoke.js");
exports.onUserRetirementChangepoke =
  onUserRetirementChangepoke.onUserRetirementChangepoke;
const onTenancyWriteSyncCurrentRent = require("./on_tenancy_write_sync_current_rent.js");
exports.onTenancyWriteSyncCurrentRent =
  onTenancyWriteSyncCurrentRent.onTenancyWriteSyncCurrentRent;
const onHouseOverrideWritepoke = require("./on_house_override_writepoke.js");
exports.onHouseOverrideWritepoke =
  onHouseOverrideWritepoke.onHouseOverrideWritepoke;
const onRentOverrideWritepoke = require("./on_rent_override_writepoke.js");
exports.onRentOverrideWritepoke =
  onRentOverrideWritepoke.onRentOverrideWritepoke;
const sendPasswordResetEmail = require("./send_password_reset_email.js");
exports.sendPasswordResetEmail = sendPasswordResetEmail.sendPasswordResetEmail;
const accrueRentalIncomeOnValuationUpdate = require("./accrue_rental_income_on_valuation_update.js");
exports.accrueRentalIncomeOnValuationUpdate =
  accrueRentalIncomeOnValuationUpdate.accrueRentalIncomeOnValuationUpdate;
