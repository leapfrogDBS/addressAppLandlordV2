import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'key_metrics_dash_widget.dart' show KeyMetricsDashWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class KeyMetricsDashModel extends FlutterFlowModel<KeyMetricsDashWidget> {
  ///  Local state fields for this component.

  CapitalAvailableToInvestStruct? capitalAvailableToInvest;
  void updateCapitalAvailableToInvestStruct(
      Function(CapitalAvailableToInvestStruct) updateFn) {
    updateFn(capitalAvailableToInvest ??= CapitalAvailableToInvestStruct());
  }

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Firestore Query - Query a collection] action in keyMetricsDash widget.
  List<PropertiesRecord>? allProperties;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
