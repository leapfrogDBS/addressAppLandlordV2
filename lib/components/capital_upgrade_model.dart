import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'capital_upgrade_widget.dart' show CapitalUpgradeWidget;
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CapitalUpgradeModel extends FlutterFlowModel<CapitalUpgradeWidget> {
  ///  Local state fields for this component.

  CapitalAvailableToInvestStruct? capitalAvailableToInvest;
  void updateCapitalAvailableToInvestStruct(
      Function(CapitalAvailableToInvestStruct) updateFn) {
    updateFn(capitalAvailableToInvest ??= CapitalAvailableToInvestStruct());
  }

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Firestore Query - Query a collection] action in capitalUpgrade widget.
  List<PropertiesRecord>? allProperties;
  // Stores action output result for [Firestore Query - Query a collection] action in capitalUpgrade widget.
  List<PropertyProjectionsRecord>? allProjections;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
