import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'purchase_prompt_widget.dart' show PurchasePromptWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PurchasePromptModel extends FlutterFlowModel<PurchasePromptWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for propertyTitle widget.
  FocusNode? propertyTitleFocusNode;
  TextEditingController? propertyTitleTextController;
  String? Function(BuildContext, String?)? propertyTitleTextControllerValidator;
  // State field(s) for purchasePrice widget.
  FocusNode? purchasePriceFocusNode;
  TextEditingController? purchasePriceTextController;
  String? Function(BuildContext, String?)? purchasePriceTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    propertyTitleFocusNode?.dispose();
    propertyTitleTextController?.dispose();

    purchasePriceFocusNode?.dispose();
    purchasePriceTextController?.dispose();
  }
}
