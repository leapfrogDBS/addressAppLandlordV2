import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/main_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import 'dart:ui';
import '/actions/actions.dart' as action_blocks;
import '/index.dart';
import 'all_messages_widget.dart' show AllMessagesWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class AllMessagesModel extends FlutterFlowModel<AllMessagesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;
  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for conversationName widget.
  FocusNode? conversationNameFocusNode;
  TextEditingController? conversationNameTextController;
  String? Function(BuildContext, String?)?
      conversationNameTextControllerValidator;

  @override
  void initState(BuildContext context) {
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
    mainHeaderModel = createModel(context, () => MainHeaderModel());
  }

  @override
  void dispose() {
    slideNavigationModel.dispose();
    mainHeaderModel.dispose();
    tabBarController?.dispose();
    conversationNameFocusNode?.dispose();
    conversationNameTextController?.dispose();
  }
}
