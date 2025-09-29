import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/property_cards/single_property/single_property_widget.dart';
import 'property_slider_widget.dart' show PropertySliderWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PropertySliderModel extends FlutterFlowModel<PropertySliderWidget> {
  ///  State fields for stateful widgets in this component.

  // Models for singleProperty dynamic component.
  late FlutterFlowDynamicModels<SinglePropertyModel> singlePropertyModels;

  @override
  void initState(BuildContext context) {
    singlePropertyModels =
        FlutterFlowDynamicModels(() => SinglePropertyModel());
  }

  @override
  void dispose() {
    singlePropertyModels.dispose();
  }
}
