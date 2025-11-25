import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/header_back_button_widget.dart';
import '/components/notifications_icon_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/hamburger/hamburger_widget.dart';
import 'dart:ui';
import 'main_header_widget.dart' show MainHeaderWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainHeaderModel extends FlutterFlowModel<MainHeaderWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for Hamburger component.
  late HamburgerModel hamburgerModel;
  // Model for headerBackButton component.
  late HeaderBackButtonModel headerBackButtonModel;
  // Model for NotificationsIcon component.
  late NotificationsIconModel notificationsIconModel;

  @override
  void initState(BuildContext context) {
    hamburgerModel = createModel(context, () => HamburgerModel());
    headerBackButtonModel = createModel(context, () => HeaderBackButtonModel());
    notificationsIconModel =
        createModel(context, () => NotificationsIconModel());
  }

  @override
  void dispose() {
    hamburgerModel.dispose();
    headerBackButtonModel.dispose();
    notificationsIconModel.dispose();
  }
}
