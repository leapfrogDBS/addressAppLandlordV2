import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'redirect_page_widget.dart' show RedirectPageWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RedirectPageModel extends FlutterFlowModel<RedirectPageWidget> {
  ///  Local state fields for this page.

  bool isCalculatingProjections = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Read Document] action in redirectPage widget.
  UsersRecord? userCollection;
  // Stores action output result for [Firestore Query - Query a collection] action in redirectPage widget.
  List<PropertiesRecord>? noPurchasePrice;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
