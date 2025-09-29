import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'portfolio_score_model.dart';
export 'portfolio_score_model.dart';

class PortfolioScoreWidget extends StatefulWidget {
  const PortfolioScoreWidget({
    super.key,
    int? userScore,
  }) : this.userScore = userScore ?? 0;

  final int userScore;

  @override
  State<PortfolioScoreWidget> createState() => _PortfolioScoreWidgetState();
}

class _PortfolioScoreWidgetState extends State<PortfolioScoreWidget> {
  late PortfolioScoreModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PortfolioScoreModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'PORTFOLIO SCORE',
                style: FlutterFlowTheme.of(context).displayLarge.override(
                      fontFamily: 'Thunder',
                      letterSpacing: 0.0,
                    ),
              ),
              custom_widgets.PortfolioGauge(
                width: double.infinity,
                height: 180.0,
                score: widget!.userScore,
                maxScore: 999,
                durationMs: 3500,
                delayMs: 1000,
                sweepDegrees: 300.0,
                strokeWidth: 18.0,
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Text(
                  'Based on your estimated portfolio performance and stated retirement goals',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        font: GoogleFonts.figtree(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).labelSmall.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelSmall.fontStyle,
                      ),
                ),
              ),
            ].divide(SizedBox(height: 10.0)),
          ),
        ),
      ),
    );
  }
}
