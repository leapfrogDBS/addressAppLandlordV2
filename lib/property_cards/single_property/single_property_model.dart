import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'single_property_widget.dart' show SinglePropertyWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SinglePropertyModel extends FlutterFlowModel<SinglePropertyWidget> {
  ///  Local state fields for this component.

  int? currentYearIndex;

  PropertyProjectionsRecord? projections;

  CardStatsStruct? cardStats;
  void updateCardStatsStruct(Function(CardStatsStruct) updateFn) {
    updateFn(cardStats ??= CardStatsStruct());
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
