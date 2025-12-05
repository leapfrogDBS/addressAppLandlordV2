import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'hamburger_model.dart';
export 'hamburger_model.dart';

class HamburgerWidget extends StatefulWidget {
  const HamburgerWidget({super.key});

  @override
  State<HamburgerWidget> createState() => _HamburgerWidgetState();
}

class _HamburgerWidgetState extends State<HamburgerWidget> {
  late HamburgerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HamburgerModel());

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
      borderColor: Colors.transparent,
      borderWidth: 1.0,
      buttonSize: 60.0,
      icon: Icon(
        Icons.menu_rounded,
        color: FlutterFlowTheme.of(context).primary,
        size: 36.0,
      ),
      onPressed: () async {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
