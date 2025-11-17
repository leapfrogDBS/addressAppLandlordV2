import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_manager.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Send a message to admin to enquire about an offer
Future enquire(
  BuildContext context, {
  /// Title of message thread
  String? conversationName,
}) async {
  ThreadsRecord? threadCreated;

  var threadsRecordReference = ThreadsRecord.collection.doc();
  await threadsRecordReference.set({
    ...createThreadsRecordData(
      landlordId: currentUserReference?.id,
      status: 'open',
      createdAt: getCurrentTimestamp,
      landlordName: currentUserDisplayName,
      landlordPhotoUrl: currentUserPhoto,
      title: conversationName,
      messagesSent: false,
    ),
    ...mapToFirestore(
      {
        'adminLastReadAt': FieldValue.serverTimestamp(),
      },
    ),
  });
  threadCreated = ThreadsRecord.getDocumentFromData({
    ...createThreadsRecordData(
      landlordId: currentUserReference?.id,
      status: 'open',
      createdAt: getCurrentTimestamp,
      landlordName: currentUserDisplayName,
      landlordPhotoUrl: currentUserPhoto,
      title: conversationName,
      messagesSent: false,
    ),
    ...mapToFirestore(
      {
        'adminLastReadAt': DateTime.now(),
      },
    ),
  }, threadsRecordReference);

  context.pushNamed(
    MessageWidget.routeName,
    queryParameters: {
      'threadRef': serializeParam(
        threadCreated?.reference,
        ParamType.DocumentReference,
      ),
    }.withoutNulls,
  );
}
