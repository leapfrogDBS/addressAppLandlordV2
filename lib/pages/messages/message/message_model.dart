import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/main_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import 'dart:ui';
import 'message_widget.dart' show MessageWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class MessageModel extends FlutterFlowModel<MessageWidget> {
  ///  Local state fields for this page.

  List<String> adminUids = [];
  void addToAdminUids(String item) => adminUids.add(item);
  void removeFromAdminUids(String item) => adminUids.remove(item);
  void removeAtIndexFromAdminUids(int index) => adminUids.removeAt(index);
  void insertAtIndexInAdminUids(int index, String item) =>
      adminUids.insert(index, item);
  void updateAdminUidsAtIndex(int index, Function(String) updateFn) =>
      adminUids[index] = updateFn(adminUids[index]);

  DocumentReference? threadRef;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in Message widget.
  List<ThreadsRecord>? threadsForLandlord;
  // Stores action output result for [Backend Call - Create Document] action in Message widget.
  ThreadsRecord? newThreadRef;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;
  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;
  // State field(s) for scrollColumn widget.
  ScrollController? scrollColumnScrollController;
  // State field(s) for ListView widget.
  ScrollController? listViewController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
    mainHeaderModel = createModel(context, () => MainHeaderModel());
    scrollColumnScrollController = ScrollController();
    listViewController = ScrollController();
  }

  @override
  void dispose() {
    slideNavigationModel.dispose();
    mainHeaderModel.dispose();
    scrollColumnScrollController?.dispose();
    listViewController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  /// Action blocks.
  Future sendMessage(BuildContext context) async {
    MessagesRecord? createMessage;

    var messagesRecordReference = MessagesRecord.createDoc(threadRef!);
    await messagesRecordReference.set(createMessagesRecordData(
      text: textController.text,
      senderId: currentUserReference?.id,
      senderIsAdmin: false,
      createdAt: getCurrentTimestamp,
    ));
    createMessage = MessagesRecord.getDocumentFromData(
        createMessagesRecordData(
          text: textController.text,
          senderId: currentUserReference?.id,
          senderIsAdmin: false,
          createdAt: getCurrentTimestamp,
        ),
        messagesRecordReference);

    await threadRef!.update(createThreadsRecordData(
      lastMessageText: textController.text,
      lastMessageAt: getCurrentTimestamp,
      lastMessageSenderId: currentUserReference?.id,
      lastMessageRef: createMessage?.reference,
      messagesSent: true,
      adminHasUnread: true,
    ));
  }
}
