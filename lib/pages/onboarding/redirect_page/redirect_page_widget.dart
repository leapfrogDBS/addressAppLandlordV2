import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'redirect_page_model.dart';
export 'redirect_page_model.dart';

class RedirectPageWidget extends StatefulWidget {
  const RedirectPageWidget({super.key});

  static String routeName = 'redirectPage';
  static String routePath = '/redirectPage';

  @override
  State<RedirectPageWidget> createState() => _RedirectPageWidgetState();
}

class _RedirectPageWidgetState extends State<RedirectPageWidget> {
  late RedirectPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RedirectPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 2000,
        ),
      );
      _model.userCollection =
          await UsersRecord.getDocumentOnce(currentUserReference!);
      if (_model.userCollection?.status != 'active') {
        if (Navigator.of(context).canPop()) {
          context.pop();
        }
        context.pushNamed(WelcomeWidget.routeName);
      } else if (!_model.userCollection!.enteredRetirmentTargets) {
        if (Navigator.of(context).canPop()) {
          context.pop();
        }
        context.pushNamed(RetirementGoalsWidget.routeName);
      } else if (!_model.userCollection!.shownMortgageOnboarding) {
        if (Navigator.of(context).canPop()) {
          context.pop();
        }
        context.pushNamed(MortgageInfoWidget.routeName);
      } else {
        while (valueOrDefault<bool>(
            currentUserDocument?.calculatingProjections, false)) {
          _model.isCalculatingProjections = true;
          safeSetState(() {});
          await Future.delayed(
            Duration(
              milliseconds: 1000,
            ),
          );
        }
        _model.isCalculatingProjections = false;
        safeSetState(() {});
        if (Navigator.of(context).canPop()) {
          context.pop();
        }
        context.pushNamed(DashboardWidget.routeName);
      }
    });

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'One moment ....',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.figtree(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_model.isCalculatingProjections)
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text(
                      'Calculating Projections',
                      style: FlutterFlowTheme.of(context).displayLarge.override(
                            fontFamily: 'Thunder',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                    child: Lottie.asset(
                      'assets/jsons/Material_loading.json',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.contain,
                      animate: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
