import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/capital_upgrade_widget.dart';
import '/components/live_earnings_dash_widget.dart';
import '/components/main_header_widget.dart';
import '/components/offers_c_t_a_widget.dart';
import '/components/portfolio_score_dash_n_e_w_widget.dart';
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
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  PortfolioTotalsStruct? pvTotals;
  void updatePvTotalsStruct(Function(PortfolioTotalsStruct) updateFn) {
    updateFn(pvTotals ??= PortfolioTotalsStruct());
  }

  bool canShowDashboard = false;

  int? propertyCountState = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in dashboard widget.
  List<PropertyProjectionsRecord>? projectionDocs;
  // Stores action output result for [Firestore Query - Query a collection] action in dashboard widget.
  int? propertyCount;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;
  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;
  // Model for liveEarningsDash component.
  late LiveEarningsDashModel liveEarningsDashModel;
  // Model for PortfolioScoreDashNEW component.
  late PortfolioScoreDashNEWModel portfolioScoreDashNEWModel;
  // Model for capitalUpgrade component.
  late CapitalUpgradeModel capitalUpgradeModel;
  // Model for PropertySlider component.
  late PropertySliderModel propertySliderModel;
  // Model for Offers_CTA component.
  late OffersCTAModel offersCTAModel;

  @override
  void initState(BuildContext context) {
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
    mainHeaderModel = createModel(context, () => MainHeaderModel());
    liveEarningsDashModel = createModel(context, () => LiveEarningsDashModel());
    portfolioScoreDashNEWModel =
        createModel(context, () => PortfolioScoreDashNEWModel());
    capitalUpgradeModel = createModel(context, () => CapitalUpgradeModel());
    propertySliderModel = createModel(context, () => PropertySliderModel());
    offersCTAModel = createModel(context, () => OffersCTAModel());
  }

  @override
  void dispose() {
    slideNavigationModel.dispose();
    mainHeaderModel.dispose();
    liveEarningsDashModel.dispose();
    portfolioScoreDashNEWModel.dispose();
    capitalUpgradeModel.dispose();
    propertySliderModel.dispose();
    offersCTAModel.dispose();
  }
}
