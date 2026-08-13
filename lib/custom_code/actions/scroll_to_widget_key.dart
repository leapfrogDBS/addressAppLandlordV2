// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Map<String, GlobalKey> scrollAnchors = {};

Future scrollToWidgetKey(
  BuildContext context,
  String? keyName,
) async {
  // Add your function code here!
  BuildContext? ctx;
  for (int i = 0; i < 10; i++) {
    ctx = scrollAnchors[keyName]?.currentContext;
    if (ctx != null) {
      break;
    }
    await Future.delayed(const Duration(milliseconds: 50));
  }
  if (ctx == null) {
    return;
  }
  await Scrollable.ensureVisible(
    ctx,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    alignment: 0.08,
  );
}
