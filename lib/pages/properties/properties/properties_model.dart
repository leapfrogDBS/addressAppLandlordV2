import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/notifications_icon_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/hamburger/hamburger_widget.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import '/property_cards/single_property/single_property_widget.dart';
import 'dart:ui';
import 'properties_widget.dart' show PropertiesWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class PropertiesModel extends FlutterFlowModel<PropertiesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Hamburger component.
  late HamburgerModel hamburgerModel;
  // Model for NotificationsIcon component.
  late NotificationsIconModel notificationsIconModel;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;
  // Models for singleProperty dynamic component.
  late FlutterFlowDynamicModels<SinglePropertyModel> singlePropertyModels;

  @override
  void initState(BuildContext context) {
    hamburgerModel = createModel(context, () => HamburgerModel());
    notificationsIconModel =
        createModel(context, () => NotificationsIconModel());
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
    singlePropertyModels =
        FlutterFlowDynamicModels(() => SinglePropertyModel());
  }

  @override
  void dispose() {
    hamburgerModel.dispose();
    notificationsIconModel.dispose();
    slideNavigationModel.dispose();
    singlePropertyModels.dispose();
  }
}
