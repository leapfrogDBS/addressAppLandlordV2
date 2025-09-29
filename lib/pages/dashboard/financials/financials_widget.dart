import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/hamburger/hamburger_widget.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'financials_model.dart';
export 'financials_model.dart';

class FinancialsWidget extends StatefulWidget {
  const FinancialsWidget({super.key});

  static String routeName = 'Financials';
  static String routePath = '/financials';

  @override
  State<FinancialsWidget> createState() => _FinancialsWidgetState();
}

class _FinancialsWidgetState extends State<FinancialsWidget> {
  late FinancialsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FinancialsModel());

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
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: FlutterFlowTheme.of(context).primary,
              automaticallyImplyLeading: false,
              leading: wrapWithModel(
                model: _model.hamburgerModel,
                updateCallback: () => safeSetState(() {}),
                child: HamburgerWidget(),
              ),
              title: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/Adobe_Express_-_file.png',
                  width: 150.0,
                  fit: BoxFit.cover,
                  alignment: Alignment(0.0, 0.0),
                ),
              ),
              actions: [],
              centerTitle: true,
              elevation: 2.0,
            )
          ],
          body: Builder(
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                    child: Text(
                      'FINANCIALS PAGE',
                      style: FlutterFlowTheme.of(context).displayLarge.override(
                            fontFamily: 'Thunder',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
