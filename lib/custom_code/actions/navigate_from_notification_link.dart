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

import 'package:cloud_firestore/cloud_firestore.dart';

Future navigateFromNotificationLink(
  BuildContext context,
  String? linkType,
  String? linkRef,
) async {
  // Add your function code here!
  // if (linkType.isEmpty) return;
  if (linkType == null || linkType.isEmpty) return;

  switch (linkType) {
    case 'SalesOffers':
      context.pushNamed('SalesOffers');
      break;
    case 'dashboard':
      context.pushNamed('dashboard');
      break;
    case 'Properties':
      context.pushNamed('Properties');
      break;
    case 'Property':
      if (linkRef != null && linkRef!.isNotEmpty) {
        final propRef = linkRef!.contains('/')
            ? FirebaseFirestore.instance.doc(linkRef!)
            : FirebaseFirestore.instance.collection('properties').doc(linkRef!);
        final serialized = serializeParam(propRef, ParamType.DocumentReference);
        if (serialized != null) {
          context.pushNamed(
            'Property',
            queryParameters: {'propID': serialized},
          );
        }
      }
      break;
    case 'Articles':
      context.pushNamed('Articles');
      break;
    case 'AllMessages':
      context.pushNamed('AllMessages');
      break;
    default:
      break;
  }
}
