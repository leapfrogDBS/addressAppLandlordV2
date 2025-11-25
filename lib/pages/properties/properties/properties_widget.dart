import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/main_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import '/property_cards/single_property/single_property_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'properties_model.dart';
export 'properties_model.dart';

class PropertiesWidget extends StatefulWidget {
  const PropertiesWidget({super.key});

  static String routeName = 'Properties';
  static String routePath = '/all-properties';

  @override
  State<PropertiesWidget> createState() => _PropertiesWidgetState();
}

class _PropertiesWidgetState extends State<PropertiesWidget> {
  late PropertiesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PropertiesModel());

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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.mainHeaderModel,
                updateCallback: () => safeSetState(() {}),
                child: MainHeaderWidget(
                  isRootScreen: true,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: StreamBuilder<List<PropertiesRecord>>(
                  stream: queryPropertiesRecord(
                    queryBuilder: (propertiesRecord) => propertiesRecord.where(
                      'ownerID',
                      isEqualTo: currentUserReference?.id,
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
                    List<PropertiesRecord> columnPropertiesRecordList =
                        snapshot.data!;

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: List.generate(
                            columnPropertiesRecordList.length, (columnIndex) {
                          final columnPropertiesRecord =
                              columnPropertiesRecordList[columnIndex];
                          return wrapWithModel(
                            model: _model.singlePropertyModels.getModel(
                              columnPropertiesRecord.reference.id,
                              columnIndex,
                            ),
                            updateCallback: () => safeSetState(() {}),
                            child: SinglePropertyWidget(
                              key: Key(
                                'Keyiwp_${columnPropertiesRecord.reference.id}',
                              ),
                              propImg: columnPropertiesRecord.mainPhoto,
                              propTitle: columnPropertiesRecord.title,
                              propValue: columnPropertiesRecord.estimatedValue,
                              propID: columnPropertiesRecord.reference,
                              propFormattedAddress:
                                  columnPropertiesRecord.addressFormatted,
                            ),
                          );
                        }).divide(SizedBox(height: 0.0)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
