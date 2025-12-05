import '/backend/api_requests/api_manager.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

/// Send a message to admin to enquire about an offer
Future enquire(
  BuildContext context, {
  String? prefillText,
}) async {
  context.pushNamed(
    MessageWidget.routeName,
    queryParameters: {
      'prefillText': serializeParam(
        prefillText,
        ParamType.String,
      ),
    }.withoutNulls,
  );
}
