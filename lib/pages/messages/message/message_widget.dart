import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/main_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'message_model.dart';
export 'message_model.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    super.key,
    this.prefillText,
  });

  final String? prefillText;

  static String routeName = 'Message';
  static String routePath = '/message';

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  late MessageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.threadsForLandlord = await queryThreadsRecordOnce(
        queryBuilder: (threadsRecord) => threadsRecord.where(
          'landlordId',
          isEqualTo: currentUserReference?.id,
        ),
        limit: 1,
      );
      if (_model.threadsForLandlord != null &&
          (_model.threadsForLandlord)!.isNotEmpty) {
        _model.threadRef = _model.threadsForLandlord?.firstOrNull?.reference;
        safeSetState(() {});

        await _model.threadsForLandlord!.firstOrNull!.reference
            .update(createThreadsRecordData(
          landlordLastReadAt: getCurrentTimestamp,
        ));
      } else {
        var threadsRecordReference = ThreadsRecord.collection.doc();
        await threadsRecordReference.set({
          ...createThreadsRecordData(
            landlordId: currentUserReference?.id,
            status: 'open',
            createdAt: getCurrentTimestamp,
            landlordName: currentUserDisplayName,
            landlordPhotoUrl: currentUserPhoto,
            messagesSent: false,
          ),
          ...mapToFirestore(
            {
              'adminLastReadAt': FieldValue.serverTimestamp(),
            },
          ),
        });
        _model.newThreadRef = ThreadsRecord.getDocumentFromData({
          ...createThreadsRecordData(
            landlordId: currentUserReference?.id,
            status: 'open',
            createdAt: getCurrentTimestamp,
            landlordName: currentUserDisplayName,
            landlordPhotoUrl: currentUserPhoto,
            messagesSent: false,
          ),
          ...mapToFirestore(
            {
              'adminLastReadAt': DateTime.now(),
            },
          ),
        }, threadsRecordReference);
        _model.threadRef = _model.newThreadRef?.reference;
        safeSetState(() {});
      }

      await Future.delayed(
        Duration(
          milliseconds: 200,
        ),
      );
      await _model.scrollColumnScrollController?.animateTo(
        _model.scrollColumnScrollController!.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    });

    _model.textController ??= TextEditingController(text: widget!.prefillText);
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        drawer: Drawer(
          elevation: 16.0,
          child: WebViewAware(
            child: wrapWithModel(
              model: _model.slideNavigationModel,
              updateCallback: () => safeSetState(() {}),
              child: SlideNavigationWidget(),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wrapWithModel(
                model: _model.mainHeaderModel,
                updateCallback: () => safeSetState(() {}),
                child: MainHeaderWidget(
                  isRootScreen: true,
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent1,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: Image.asset(
                                'assets/images/logo-add-icon-box-col-rgb@2x.png',
                                width: 53.9,
                                height: 44.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 5.0, 0.0, 0.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'ow7hdn9f' /* Addressed Admin */,
                            ),
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.dmSans(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 8.0, 20.0, 5.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'gw9i9bkl' /* Please leave a message and a m... */,
                            ),
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.dmSans(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                        Divider(
                          height: 2.0,
                          thickness: 2.0,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _model.scrollColumnScrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (_model.threadRef != null)
                        StreamBuilder<List<MessagesRecord>>(
                          stream: queryMessagesRecord(
                            parent: _model.threadRef,
                            queryBuilder: (messagesRecord) => messagesRecord
                                .orderBy('createdAt', descending: true),
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<MessagesRecord> listViewMessagesRecordList =
                                snapshot.data!;

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              reverse: true,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listViewMessagesRecordList.length,
                              itemBuilder: (context, listViewIndex) {
                                final listViewMessagesRecord =
                                    listViewMessagesRecordList[listViewIndex];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15.0, 8.0, 15.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(
                                            valueOrDefault<double>(
                                              listViewMessagesRecord
                                                      .senderIsAdmin
                                                  ? 1.0
                                                  : -1.0,
                                              -1.0,
                                            ),
                                            0.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 1.0, 0.0, 0.0),
                                          child: Material(
                                            color: Colors.transparent,
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.77,
                                              decoration: BoxDecoration(
                                                color: valueOrDefault<Color>(
                                                  listViewMessagesRecord
                                                          .senderIsAdmin
                                                      ? Color(0x34377C74)
                                                      : Color(0xFFE3E2E9),
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    8.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            RichText(
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: valueOrDefault<
                                                                        String>(
                                                                      dateTimeFormat(
                                                                        "relative",
                                                                        listViewMessagesRecord
                                                                            .createdAt,
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      ),
                                                                      'Today',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.dmSans(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  )
                                                                ],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .dmSans(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          12.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                listViewMessagesRecord
                                                                    .text,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .dmSans(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            if (listViewMessagesRecord
                                                                .senderIsAdmin)
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            2.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: StreamBuilder<
                                                                    List<
                                                                        UsersRecord>>(
                                                                  stream:
                                                                      queryUsersRecord(
                                                                    queryBuilder:
                                                                        (usersRecord) =>
                                                                            usersRecord.where(
                                                                      'uid',
                                                                      isEqualTo:
                                                                          listViewMessagesRecord
                                                                              .senderId,
                                                                    ),
                                                                    singleRecord:
                                                                        true,
                                                                  ),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    // Customize what your widget looks like when it's loading.
                                                                    if (!snapshot
                                                                        .hasData) {
                                                                      return Center(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              50.0,
                                                                          height:
                                                                              50.0,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    List<UsersRecord>
                                                                        rowUsersRecordList =
                                                                        snapshot
                                                                            .data!;
                                                                    // Return an empty Container when the item does not exist.
                                                                    if (snapshot
                                                                        .data!
                                                                        .isEmpty) {
                                                                      return Container();
                                                                    }
                                                                    final rowUsersRecord = rowUsersRecordList
                                                                            .isNotEmpty
                                                                        ? rowUsersRecordList
                                                                            .first
                                                                        : null;

                                                                    return Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children:
                                                                          [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                22.0,
                                                                            height:
                                                                                22.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                width: 0.0,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.all(2.0),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(100.0),
                                                                                child: Image.network(
                                                                                  valueOrDefault<String>(
                                                                                    rowUsersRecord?.photoUrl,
                                                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/addressed-app-design-dxidz2/assets/y3lck4nhzkbs/profileDefault.jpg',
                                                                                  ),
                                                                                  width: 32.0,
                                                                                  height: 32.0,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            rowUsersRecord?.displayName,
                                                                            'Adressed Admin',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodySmall
                                                                              .override(
                                                                                font: GoogleFonts.dmSans(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                ),
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              width: 5.0)),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                          ].divide(SizedBox(
                                                              height: 5.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              controller: _model.listViewController,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 2.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 70.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300.0,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        onFieldSubmitted: (_) async {
                          await _model.sendMessage(context);

                          await EmailRecord.collection
                              .doc()
                              .set(createEmailRecordData(
                                to: 'info@leapfrogdbs.co.uk',
                                message: createMessageStruct(
                                  subject:
                                      'New message from ${currentUserDisplayName}',
                                  text: _model.textController.text,
                                  html:
                                      '<!DOCTYPE html> <html> <head>   <meta charset=\"utf-8\">   <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"> </head> <body style=\"margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, sans-serif; background-color: #f5f5f5;\">   <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #f5f5f5; padding: 20px;\">     <tr>       <td align=\"center\">         <table width=\"600\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08);\">           <!-- Header with Logo -->           <tr>             <td style=\"background-color: #ffffff; padding: 30px 30px 20px 30px; text-align: center; border-bottom: 1px solid #e8e8e8;\">               <img src=\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/addressed-app-admin-tfpanq/assets/oxku0gyz828s/Addressed_logo_-_Transparent.png\" alt=\"Addressed\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />             </td>           </tr>           <!-- Content -->           <tr>             <td style=\"padding: 40px 30px;\">               <p style=\"color: #333333; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0; font-weight: 500;\">You have received a new message from ${currentUserDisplayName}:</p>               <div style=\"background-color: #f9f9f9; border-left: 4px solid #153048; padding: 20px; margin: 20px 0; border-radius: 4px;\">                 <p style=\"color: #333333; font-size: 16px; line-height: 1.8; margin: 0; white-space: pre-wrap;\">${_model.textController.text}                </p>               </div>               <p style=\"color: #666666; font-size: 15px; line-height: 1.6; margin: 30px 0 0 0;\">Please log in to the Addressed app to reply.</p>             </td>           </tr>           <!-- Footer -->           <tr>             <td style=\"background-color: #f9f9f9; padding: 25px 30px; border-top: 1px solid #e8e8e8;\">               <p style=\"color: #999999; font-size: 12px; line-height: 1.6; margin: 0 0 10px 0; text-align: center;\">This is an automated message from Addressed. Please do not reply to this email.</p>               <p style=\"color: #999999; font-size: 11px; line-height: 1.6; margin: 0; text-align: center;\">Addressed National Ltd | pm@addressed.co | +44 (0)333 038 6633</p>             </td>           </tr>         </table>       </td>     </tr>   </table> </body> </html>',
                                  clearUnsetFields: false,
                                  create: true,
                                ),
                              ));
                          safeSetState(() {
                            _model.textController?.text = '';
                          });
                          await Future.delayed(
                            Duration(
                              milliseconds: 200,
                            ),
                          );
                          await _model.scrollColumnScrollController?.animateTo(
                            _model.scrollColumnScrollController!.position
                                .maxScrollExtent,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.ease,
                          );
                        },
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.dmSans(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                          hintText: FFLocalizations.of(context).getText(
                            '3nu438u0' /* Write a message.... */,
                          ),
                          hintStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.dmSans(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).alternate,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.dmSans(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        validator:
                            _model.textControllerValidator.asValidator(context),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await _model.sendMessage(context);

                        await _model.threadRef!.update(createThreadsRecordData(
                          messagesSent: true,
                        ));

                        await EmailRecord.collection
                            .doc()
                            .set(createEmailRecordData(
                              to: 'info@leapfrogdbs.co.uk',
                              message: createMessageStruct(
                                subject:
                                    'New message from ${currentUserDisplayName}',
                                text: _model.textController.text,
                                html:
                                    '<!DOCTYPE html> <html> <head>   <meta charset=\"utf-8\">   <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"> </head> <body style=\"margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, sans-serif; background-color: #f5f5f5;\">   <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #f5f5f5; padding: 20px;\">     <tr>       <td align=\"center\">         <table width=\"600\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08);\">           <!-- Header with Logo -->           <tr>             <td style=\"background-color: #ffffff; padding: 30px 30px 20px 30px; text-align: center; border-bottom: 1px solid #e8e8e8;\">               <img src=\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/addressed-app-admin-tfpanq/assets/oxku0gyz828s/Addressed_logo_-_Transparent.png\" alt=\"Addressed\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />             </td>           </tr>           <!-- Content -->           <tr>             <td style=\"padding: 40px 30px;\">               <p style=\"color: #333333; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0; font-weight: 500;\">You have received a new message from ${currentUserDisplayName}:</p>               <div style=\"background-color: #f9f9f9; border-left: 4px solid #153048; padding: 20px; margin: 20px 0; border-radius: 4px;\">                 <p style=\"color: #333333; font-size: 16px; line-height: 1.8; margin: 0; white-space: pre-wrap;\">${_model.textController.text}                </p>               </div>               <p style=\"color: #666666; font-size: 15px; line-height: 1.6; margin: 30px 0 0 0;\">Please log in to the Addressed app to reply.</p>             </td>           </tr>           <!-- Footer -->           <tr>             <td style=\"background-color: #f9f9f9; padding: 25px 30px; border-top: 1px solid #e8e8e8;\">               <p style=\"color: #999999; font-size: 12px; line-height: 1.6; margin: 0 0 10px 0; text-align: center;\">This is an automated message from Addressed. Please do not reply to this email.</p>               <p style=\"color: #999999; font-size: 11px; line-height: 1.6; margin: 0; text-align: center;\">Addressed National Ltd | pm@addressed.co | +44 (0)333 038 6633</p>             </td>           </tr>         </table>       </td>     </tr>   </table> </body> </html>',
                                clearUnsetFields: false,
                                create: true,
                              ),
                            ));
                        safeSetState(() {
                          _model.textController?.text = '';
                        });
                        await Future.delayed(
                          Duration(
                            milliseconds: 200,
                          ),
                        );
                        await _model.scrollColumnScrollController?.animateTo(
                          _model.scrollColumnScrollController!.position
                              .maxScrollExtent,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.ease,
                        );
                      },
                      child: Icon(
                        Icons.send,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                  ].divide(SizedBox(width: 7.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
