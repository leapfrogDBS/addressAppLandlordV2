import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'live_earnings_property_model.dart';
export 'live_earnings_property_model.dart';

class LiveEarningsPropertyWidget extends StatefulWidget {
  const LiveEarningsPropertyWidget({
    super.key,
    double? yearlyGain,
    double? dailyGain,
    double? secondGain,
    double? earningsToDate,
    String? headingText,
    required this.periodLabel,
  })  : this.yearlyGain = yearlyGain ?? 0.00,
        this.dailyGain = dailyGain ?? 0.00,
        this.secondGain = secondGain ?? 0.00,
        this.earningsToDate = earningsToDate ?? 0.00,
        this.headingText = headingText ?? 'This property has earned you...';

  final double yearlyGain;
  final double dailyGain;
  final double secondGain;
  final double earningsToDate;
  final String headingText;
  final String? periodLabel;

  @override
  State<LiveEarningsPropertyWidget> createState() =>
      _LiveEarningsPropertyWidgetState();
}

class _LiveEarningsPropertyWidgetState
    extends State<LiveEarningsPropertyWidget> {
  late LiveEarningsPropertyModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LiveEarningsPropertyModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 500,
        ),
      );
      _model.liveEarningsTotal = widget!.earningsToDate;
      safeSetState(() {});
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 1000),
        callback: (timer) async {
          _model.liveEarningsTotal =
              _model.liveEarningsTotal! + widget!.secondGain;
          safeSetState(() {});
        },
        startImmediately: false,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondary,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Text(
                  widget!.headingText,
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.figtree(
                          fontWeight: FontWeight.normal,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 3.0, 0.0, 0.0),
                      child: Text(
                        formatNumber(
                          _model.liveEarningsTotal,
                          formatType: FormatType.custom,
                          currency: '£',
                          format: '#,##0.00',
                          locale: 'en_GB',
                        ),
                        style:
                            FlutterFlowTheme.of(context).displayLarge.override(
                                  fontFamily: 'Thunder',
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  fontSize: 64.0,
                                  letterSpacing: 0.0,
                                ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Clip_path_group.png',
                        width: 160.0,
                        height: 10.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          '4afb697w' /* Estimated gain for the year */,
                        ),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.figtree(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                      ),
                      Text(
                        valueOrDefault<String>(
                          widget!.periodLabel,
                          'this year',
                        ),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.figtree(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              fontSize: 15.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(height: 3.0)),
                  ),
                  Text(
                    formatNumber(
                      widget!.yearlyGain,
                      formatType: FormatType.custom,
                      currency: '£',
                      format: '#,##0.00',
                      locale: 'en_GB',
                    ),
                    style: FlutterFlowTheme.of(context).displayLarge.override(
                          fontFamily: 'Thunder',
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          letterSpacing: 0.0,
                        ),
                  ),
                  Text(
                    '(+${formatNumber(
                      widget!.dailyGain,
                      formatType: FormatType.custom,
                      currency: '£',
                      format: '#,##0.00',
                      locale: 'en_GB',
                    )} /day)',
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          font: GoogleFonts.figtree(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                  ),
                ].divide(SizedBox(height: 17.0)),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                child: Text(
                  FFLocalizations.of(context).getText(
                    'ak9pv36y' /* Based on rental profit and cap... */,
                  ),
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        font: GoogleFonts.figtree(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).labelSmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelSmall.fontStyle,
                      ),
                ),
              ),
            ].divide(SizedBox(height: 20.0)),
          ),
        ),
      ),
    );
  }
}
