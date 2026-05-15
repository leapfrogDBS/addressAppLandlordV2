import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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
      _model.noPurchasePrice = await queryPropertiesRecordOnce(
        queryBuilder: (propertiesRecord) => propertiesRecord
            .where(
              'ownerID',
              isEqualTo: currentUserReference?.id,
            )
            .where(
              'purchasePrice',
              isLessThanOrEqualTo: 0.0,
            ),
        limit: 1,
      );
      if (_model.userCollection?.status != 'active') {
        context.goNamed(WelcomeWidget.routeName);
      } else if (!_model.userCollection!.enteredRetirmentTargets) {
        context.goNamed(RetirementGoalsWidget.routeName);
      } else if (_model.noPurchasePrice != null &&
          (_model.noPurchasePrice)!.isNotEmpty) {
        context.goNamed(PurchaseInfoWidget.routeName);
      } else if (!_model.userCollection!.shownMortgageOnboarding) {
        context.goNamed(MortgageInfoWidget.routeName);
      } else {
        if (valueOrDefault<bool>(
                currentUserDocument?.completedOnboarding, false) &&
            valueOrDefault<bool>(
                currentUserDocument?.firstProjectionsRun, false)) {
          context.pushNamed(DashboardWidget.routeName);
        } else {
          await currentUserReference!.update(createUsersRecordData(
            completedOnboarding: true,
          ));
          _model.isCalculatingProjections = true;
          safeSetState(() {});
          _model.waitOutput = await actions.waitForFirstProjectionsRun();
          if (_model.waitOutput == true) {
            context.pushNamed(DashboardWidget.routeName);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please pull down to refresh the app, or log out and back in. If it keeps happening, contact support.',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                ),
                duration: Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }

          _model.isCalculatingProjections = false;
        }
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
            FFLocalizations.of(context).getText(
              'ksmmgllu' /* One moment .... */,
            ),
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
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Visibility(
                        visible: _model.isCalculatingProjections,
                        child: Text(
                          FFLocalizations.of(context).getText(
                            '164a2u9a' /* Calculating projections for ev... */,
                          ),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineLarge
                              .override(
                                font: GoogleFonts.figtree(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineLarge
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineLarge
                                    .fontStyle,
                              ),
                        ),
                      ),
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
