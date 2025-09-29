import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/key_metrics_dash_widget.dart';
import '/components/live_earnings_all_widget.dart';
import '/components/notifications_icon_widget.dart';
import '/components/portfolio_score_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/hamburger/hamburger_widget.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import '/property_cards/property_slider/property_slider_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for liveEarningsAll component.
  late LiveEarningsAllModel liveEarningsAllModel;
  // Model for portfolioScore component.
  late PortfolioScoreModel portfolioScoreModel;
  // Model for keyMetricsDash component.
  late KeyMetricsDashModel keyMetricsDashModel;
  // Model for PropertySlider component.
  late PropertySliderModel propertySliderModel;
  // Model for Hamburger component.
  late HamburgerModel hamburgerModel;
  // Model for NotificationsIcon component.
  late NotificationsIconModel notificationsIconModel;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;

  @override
  void initState(BuildContext context) {
    liveEarningsAllModel = createModel(context, () => LiveEarningsAllModel());
    portfolioScoreModel = createModel(context, () => PortfolioScoreModel());
    keyMetricsDashModel = createModel(context, () => KeyMetricsDashModel());
    propertySliderModel = createModel(context, () => PropertySliderModel());
    hamburgerModel = createModel(context, () => HamburgerModel());
    notificationsIconModel =
        createModel(context, () => NotificationsIconModel());
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
  }

  @override
  void dispose() {
    liveEarningsAllModel.dispose();
    portfolioScoreModel.dispose();
    keyMetricsDashModel.dispose();
    propertySliderModel.dispose();
    hamburgerModel.dispose();
    notificationsIconModel.dispose();
    slideNavigationModel.dispose();
  }
}
