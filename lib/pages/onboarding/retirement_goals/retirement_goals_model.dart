import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'retirement_goals_widget.dart' show RetirementGoalsWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RetirementGoalsModel extends FlutterFlowModel<RetirementGoalsWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for reitementAge widget.
  FocusNode? reitementAgeFocusNode;
  TextEditingController? reitementAgeTextController;
  String? Function(BuildContext, String?)? reitementAgeTextControllerValidator;
  String? _reitementAgeTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '0q39mest' /* Planned retirement age is requ... */,
      );
    }

    return null;
  }

  // State field(s) for equity widget.
  FocusNode? equityFocusNode;
  TextEditingController? equityTextController;
  String? Function(BuildContext, String?)? equityTextControllerValidator;
  String? _equityTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'tnmg513q' /* Target Equity is required */,
      );
    }

    return null;
  }

  // State field(s) for income widget.
  FocusNode? incomeFocusNode;
  TextEditingController? incomeTextController;
  String? Function(BuildContext, String?)? incomeTextControllerValidator;
  String? _incomeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '43texmea' /* Target Income is required */,
      );
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    reitementAgeTextControllerValidator = _reitementAgeTextControllerValidator;
    equityTextControllerValidator = _equityTextControllerValidator;
    incomeTextControllerValidator = _incomeTextControllerValidator;
  }

  @override
  void dispose() {
    reitementAgeFocusNode?.dispose();
    reitementAgeTextController?.dispose();

    equityFocusNode?.dispose();
    equityTextController?.dispose();

    incomeFocusNode?.dispose();
    incomeTextController?.dispose();
  }
}
