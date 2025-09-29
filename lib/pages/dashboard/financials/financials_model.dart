import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/hamburger/hamburger_widget.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import 'dart:ui';
import 'financials_widget.dart' show FinancialsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class FinancialsModel extends FlutterFlowModel<FinancialsWidget> {
  ///  Local state fields for this page.

  String selectedView = 'Combined';

  ///  State fields for stateful widgets in this page.

  // Model for Hamburger component.
  late HamburgerModel hamburgerModel;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;

  @override
  void initState(BuildContext context) {
    hamburgerModel = createModel(context, () => HamburgerModel());
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
  }

  @override
  void dispose() {
    hamburgerModel.dispose();
    slideNavigationModel.dispose();
  }
}
