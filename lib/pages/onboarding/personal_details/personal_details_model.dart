import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'personal_details_widget.dart' show PersonalDetailsWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PersonalDetailsModel extends FlutterFlowModel<PersonalDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataEdit = false;
  FFUploadedFile uploadedLocalFile_uploadDataEdit =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataEdit = '';

  // State field(s) for dob widget.
  FocusNode? dobFocusNode;
  TextEditingController? dobTextController;
  String? Function(BuildContext, String?)? dobTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for availableCapital widget.
  FocusNode? availableCapitalFocusNode;
  TextEditingController? availableCapitalTextController;
  String? Function(BuildContext, String?)?
      availableCapitalTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dobFocusNode?.dispose();
    dobTextController?.dispose();

    availableCapitalFocusNode?.dispose();
    availableCapitalTextController?.dispose();
  }
}
