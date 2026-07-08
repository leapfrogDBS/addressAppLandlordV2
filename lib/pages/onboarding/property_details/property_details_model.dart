import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'property_details_widget.dart' show PropertyDetailsWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PropertyDetailsModel extends FlutterFlowModel<PropertyDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for propertyTitle widget.
  FocusNode? propertyTitleFocusNode;
  TextEditingController? propertyTitleTextController;
  String? Function(BuildContext, String?)? propertyTitleTextControllerValidator;
  // State field(s) for purchasePrice widget.
  FocusNode? purchasePriceFocusNode;
  TextEditingController? purchasePriceTextController;
  String? Function(BuildContext, String?)? purchasePriceTextControllerValidator;
  String? _purchasePriceTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'nrmq1j34' /*  Purchase Price is required */,
      );
    }

    return null;
  }

  DateTime? datePicked;
  // State field(s) for averageYearlyCosts widget.
  FocusNode? averageYearlyCostsFocusNode;
  TextEditingController? averageYearlyCostsTextController;
  String? Function(BuildContext, String?)?
      averageYearlyCostsTextControllerValidator;
  String? _averageYearlyCostsTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'dnvaxwkv' /* Average yearly costs is requir... */,
      );
    }

    return null;
  }

  // State field(s) for mortgageValueRemaining widget.
  FocusNode? mortgageValueRemainingFocusNode;
  TextEditingController? mortgageValueRemainingTextController;
  String? Function(BuildContext, String?)?
      mortgageValueRemainingTextControllerValidator;
  String? _mortgageValueRemainingTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '7ao2w5ab' /* Outstanding mortgage value is ... */,
      );
    }

    return null;
  }

  // Stores action output result for [Validate Form] action in Button widget.
  bool? validateForm;

  @override
  void initState(BuildContext context) {
    purchasePriceTextControllerValidator =
        _purchasePriceTextControllerValidator;
    averageYearlyCostsTextControllerValidator =
        _averageYearlyCostsTextControllerValidator;
    mortgageValueRemainingTextControllerValidator =
        _mortgageValueRemainingTextControllerValidator;
  }

  @override
  void dispose() {
    propertyTitleFocusNode?.dispose();
    propertyTitleTextController?.dispose();

    purchasePriceFocusNode?.dispose();
    purchasePriceTextController?.dispose();

    averageYearlyCostsFocusNode?.dispose();
    averageYearlyCostsTextController?.dispose();

    mortgageValueRemainingFocusNode?.dispose();
    mortgageValueRemainingTextController?.dispose();
  }
}
