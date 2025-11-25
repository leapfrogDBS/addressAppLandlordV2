import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/key_metrics_dash_widget.dart';
import '/components/live_earnings_property_widget.dart';
import '/components/main_header_widget.dart';
import '/components/portfolio_score_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import '/property_cards/property_slider/property_slider_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  PortfolioTotalsStruct? pvTotals;
  void updatePvTotalsStruct(Function(PortfolioTotalsStruct) updateFn) {
    updateFn(pvTotals ??= PortfolioTotalsStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in dashboard widget.
  List<PropertyProjectionsRecord>? projectionDocs;
  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;
  // Model for liveEarningsProperty component.
  late LiveEarningsPropertyModel liveEarningsPropertyModel;
  // Model for portfolioScore component.
  late PortfolioScoreModel portfolioScoreModel;
  // Model for keyMetricsDash component.
  late KeyMetricsDashModel keyMetricsDashModel;
  // Model for PropertySlider component.
  late PropertySliderModel propertySliderModel;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;

  @override
  void initState(BuildContext context) {
    mainHeaderModel = createModel(context, () => MainHeaderModel());
    liveEarningsPropertyModel =
        createModel(context, () => LiveEarningsPropertyModel());
    portfolioScoreModel = createModel(context, () => PortfolioScoreModel());
    keyMetricsDashModel = createModel(context, () => KeyMetricsDashModel());
    propertySliderModel = createModel(context, () => PropertySliderModel());
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
  }

  @override
  void dispose() {
    mainHeaderModel.dispose();
    liveEarningsPropertyModel.dispose();
    portfolioScoreModel.dispose();
    keyMetricsDashModel.dispose();
    propertySliderModel.dispose();
    slideNavigationModel.dispose();
  }
}
