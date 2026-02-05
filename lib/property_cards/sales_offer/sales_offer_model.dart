import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'sales_offer_widget.dart' show SalesOfferWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class SalesOfferModel extends FlutterFlowModel<SalesOfferWidget> {
  ///  Local state fields for this component.

  ProjectionsRecord? projections;

  SalesOfferAtRetirementStruct? offerAtRetirement;
  void updateOfferAtRetirementStruct(
      Function(SalesOfferAtRetirementStruct) updateFn) {
    updateFn(offerAtRetirement ??= SalesOfferAtRetirementStruct());
  }

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Firestore Query - Query a collection] action in salesOffer widget.
  ProjectionsRecord? projectionsDocument;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
