import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'primary_c_t_a_model.dart';
export 'primary_c_t_a_model.dart';

class PrimaryCTAWidget extends StatefulWidget {
  const PrimaryCTAWidget({
    super.key,
    String? labelText,
    required this.onTap,
  }) : this.labelText = labelText ?? 'Button';

  final String labelText;
  final Future Function()? onTap;

  @override
  State<PrimaryCTAWidget> createState() => _PrimaryCTAWidgetState();
}

class _PrimaryCTAWidgetState extends State<PrimaryCTAWidget> {
  late PrimaryCTAModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PrimaryCTAModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: () async {
        await widget.onTap?.call();
      },
      text: widget!.labelText,
      options: FFButtonOptions(
        width: 200.0,
        height: 40.0,
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: FlutterFlowTheme.of(context).tertiary,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.figtree(
                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
              ),
              color: FlutterFlowTheme.of(context).primary,
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
            ),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(24.0),
      ),
    );
  }
}
