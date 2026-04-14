import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/header_back_button_widget.dart';
import '/components/notifications_icon_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/hamburger/hamburger_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'main_header_model.dart';
export 'main_header_model.dart';

class MainHeaderWidget extends StatefulWidget {
  const MainHeaderWidget({
    super.key,
    bool? isRootScreen,
  }) : this.isRootScreen = isRootScreen ?? true;

  final bool isRootScreen;

  @override
  State<MainHeaderWidget> createState() => _MainHeaderWidgetState();
}

class _MainHeaderWidgetState extends State<MainHeaderWidget> {
  late MainHeaderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainHeaderModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 60.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget!.isRootScreen)
              wrapWithModel(
                model: _model.hamburgerModel,
                updateCallback: () => safeSetState(() {}),
                child: HamburgerWidget(),
              ),
            if (!widget!.isRootScreen)
              wrapWithModel(
                model: _model.headerBackButtonModel,
                updateCallback: () => safeSetState(() {}),
                child: HeaderBackButtonWidget(
                  parameter1: !widget!.isRootScreen,
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Adobe_Express_-_file.png',
                        width: 120.0,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment(0.0, 0.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
              child: FutureBuilder<int>(
                future: queryNotificationsRecordCount(
                  parent: currentUserReference,
                  queryBuilder: (notificationsRecord) =>
                      notificationsRecord.where(
                    'viewed',
                    isNotEqualTo: true,
                  ),
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
                  int notificationsIconCount = snapshot.data!;

                  return wrapWithModel(
                    model: _model.notificationsIconModel,
                    updateCallback: () => safeSetState(() {}),
                    child: NotificationsIconWidget(
                      noOfNotifications: notificationsIconCount,
                    ),
                  );
                },
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
      ),
    );
  }
}
