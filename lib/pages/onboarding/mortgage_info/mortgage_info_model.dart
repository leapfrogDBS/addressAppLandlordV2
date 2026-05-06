import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/mortgage_prompt_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'mortgage_info_widget.dart' show MortgageInfoWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MortgageInfoModel extends FlutterFlowModel<MortgageInfoWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for mortgagePrompt dynamic component.
  late FlutterFlowDynamicModels<MortgagePromptModel> mortgagePromptModels;

  @override
  void initState(BuildContext context) {
    mortgagePromptModels =
        FlutterFlowDynamicModels(() => MortgagePromptModel());
  }

  @override
  void dispose() {
    mortgagePromptModels.dispose();
  }
}
