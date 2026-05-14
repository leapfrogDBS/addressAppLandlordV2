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

Future<bool> waitForFirstProjectionsRun() async {
  if (!loggedIn || currentUserReference == null) {
    return false;
  }
  final deadline = DateTime.now().add(const Duration(seconds: 120));
  while (DateTime.now().isBefore(deadline)) {
    final user = await UsersRecord.getDocumentOnce(currentUserReference!);
    if (user.firstProjectionsRun) {
      return true;
    }
    await Future.delayed(const Duration(milliseconds: 800));
  }
  return false;
}
