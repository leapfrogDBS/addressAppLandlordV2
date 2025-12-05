import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'header_back_button_model.dart';
export 'header_back_button_model.dart';

class HeaderBackButtonWidget extends StatefulWidget {
  const HeaderBackButtonWidget({
    super.key,
    this.parameter1,
  });

  final bool? parameter1;

  @override
  State<HeaderBackButtonWidget> createState() => _HeaderBackButtonWidgetState();
}

class _HeaderBackButtonWidgetState extends State<HeaderBackButtonWidget> {
  late HeaderBackButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HeaderBackButtonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFlowIconButton(
      borderRadius: 0.0,
      buttonSize: 60.0,
      icon: Icon(
        Icons.arrow_back_rounded,
        color: FlutterFlowTheme.of(context).primary,
        size: 36.0,
      ),
      onPressed: () async {
        context.safePop();
      },
    );
  }
}
