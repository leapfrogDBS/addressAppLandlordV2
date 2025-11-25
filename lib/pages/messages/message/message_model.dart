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

  ///  State fields for stateful widgets in this page.

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
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;

  @override
  void initState(BuildContext context) {
    mainHeaderModel = createModel(context, () => MainHeaderModel());
    scrollColumnScrollController = ScrollController();
    listViewController = ScrollController();
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
  }

  @override
  void dispose() {
    mainHeaderModel.dispose();
    scrollColumnScrollController?.dispose();
    listViewController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    slideNavigationModel.dispose();
  }

  /// Action blocks.
  Future sendMessage(BuildContext context) async {
    MessagesRecord? createMessage;

    var messagesRecordReference = MessagesRecord.createDoc(widget!.threadRef!);
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

    await widget!.threadRef!.update(createThreadsRecordData(
      lastMessageText: textController.text,
      lastMessageAt: getCurrentTimestamp,
      lastMessageSenderId: currentUserReference?.id,
      lastMessageRef: createMessage?.reference,
    ));
  }
}
