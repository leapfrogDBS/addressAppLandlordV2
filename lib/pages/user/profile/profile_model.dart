import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_language_selector.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  Local state fields for this page.

  bool goalsChanged = false;

  bool isEditing = false;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadData = false;
  FFUploadedFile uploadedLocalFile_uploadData =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadData = '';

  // State field(s) for retirementAge widget.
  FocusNode? retirementAgeFocusNode;
  TextEditingController? retirementAgeTextController;
  String? Function(BuildContext, String?)? retirementAgeTextControllerValidator;
  // State field(s) for Equity widget.
  FocusNode? equityFocusNode;
  TextEditingController? equityTextController;
  String? Function(BuildContext, String?)? equityTextControllerValidator;
  // State field(s) for incomeGoal widget.
  FocusNode? incomeGoalFocusNode1;
  TextEditingController? incomeGoalTextController1;
  String? Function(BuildContext, String?)? incomeGoalTextController1Validator;
  // State field(s) for incomeGoal widget.
  FocusNode? incomeGoalFocusNode2;
  TextEditingController? incomeGoalTextController2;
  String? Function(BuildContext, String?)? incomeGoalTextController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    retirementAgeFocusNode?.dispose();
    retirementAgeTextController?.dispose();

    equityFocusNode?.dispose();
    equityTextController?.dispose();

    incomeGoalFocusNode1?.dispose();
    incomeGoalTextController1?.dispose();

    incomeGoalFocusNode2?.dispose();
    incomeGoalTextController2?.dispose();
  }

  /// Action blocks.
  Future profileUpdated(BuildContext context) async {
    // ProfileUpdatedShowSnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile Updated',
          style: FlutterFlowTheme.of(context).bodySmall.override(
                font: GoogleFonts.dmSans(
                  fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).secondary,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
              ),
        ),
        duration: Duration(milliseconds: 4000),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      ),
    );
  }
}
