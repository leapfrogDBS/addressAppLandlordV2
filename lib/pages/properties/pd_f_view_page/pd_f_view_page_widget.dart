import '/components/main_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_pdf_viewer.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pd_f_view_page_model.dart';
export 'pd_f_view_page_model.dart';

class PdFViewPageWidget extends StatefulWidget {
  const PdFViewPageWidget({
    super.key,
    required this.pdfUrl,
    this.fileName,
  });

  final String? pdfUrl;
  final String? fileName;

  static String routeName = 'pdFViewPage';
  static String routePath = '/pdFViewPage';

  @override
  State<PdFViewPageWidget> createState() => _PdFViewPageWidgetState();
}

class _PdFViewPageWidgetState extends State<PdFViewPageWidget> {
  late PdFViewPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PdFViewPageModel());

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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.mainHeaderModel,
                updateCallback: () => safeSetState(() {}),
                child: MainHeaderWidget(),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 44.0,
                        icon: Icon(
                          Icons.arrow_back,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          context.safePop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              FlutterFlowPdfViewer(
                networkPath: widget!.pdfUrl!,
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 500.0,
                horizontalScroll: false,
              ),
              FFButtonWidget(
                onPressed: () async {
                  await downloadFile(
                    filename: 'Energy Certificate',
                    url: valueOrDefault<String>(
                      widget!.pdfUrl,
                      'https://firebasestorage.googleapis.com/v0/b/addressedapp.firebasestorage.app/o/users%2FtCbHTXny61hWI94Ki602HbgIdZi2%2Fuploads%2F1754923299608000.pdf?alt=media&token=fa9ed858-4973-4f0b-bd70-847e104faa35',
                    ),
                  );
                },
                text: FFLocalizations.of(context).getText(
                  't8a1mgwf' /* Download */,
                ),
                options: FFButtonOptions(
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.dmSans(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
