import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/main_header_widget.dart';
import '/components/offers_c_t_a_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import '/property_cards/sales_offer/sales_offer_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'sales_offers_model.dart';
export 'sales_offers_model.dart';

/// I would like to display in a 2 column grid.
class SalesOffersWidget extends StatefulWidget {
  const SalesOffersWidget({super.key});

  static String routeName = 'SalesOffers';
  static String routePath = '/salesOffers';

  @override
  State<SalesOffersWidget> createState() => _SalesOffersWidgetState();
}

class _SalesOffersWidgetState extends State<SalesOffersWidget> {
  late SalesOffersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SalesOffersModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.projectionDocs = await queryPropertyProjectionsRecordOnce(
        queryBuilder: (propertyProjectionsRecord) =>
            propertyProjectionsRecord.where(
          'ownerRef',
          isEqualTo: currentUserReference,
        ),
      );
      _model.pvTotals =
          functions.aggregateAtRetirement(_model.projectionDocs!.toList());
      safeSetState(() {});
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        drawer: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Drawer(
            elevation: 16.0,
            child: WebViewAware(
              child: wrapWithModel(
                model: _model.slideNavigationModel,
                updateCallback: () => safeSetState(() {}),
                child: SlideNavigationWidget(),
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                wrapWithModel(
                  model: _model.mainHeaderModel,
                  updateCallback: () => safeSetState(() {}),
                  child: MainHeaderWidget(),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 20.0),
                  child: StreamBuilder<List<SalesOffersRecord>>(
                    stream: querySalesOffersRecord(),
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
                      List<SalesOffersRecord> listViewSalesOffersRecordList =
                          snapshot.data!;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listViewSalesOffersRecordList.length,
                        itemBuilder: (context, listViewIndex) {
                          final listViewSalesOffersRecord =
                              listViewSalesOffersRecordList[listViewIndex];
                          return wrapWithModel(
                            model: _model.salesOfferModels.getModel(
                              listViewSalesOffersRecord.reference.id,
                              listViewIndex,
                            ),
                            updateCallback: () => safeSetState(() {}),
                            child: SalesOfferWidget(
                              key: Key(
                                'Keybgm_${listViewSalesOffersRecord.reference.id}',
                              ),
                              salesOffer: listViewSalesOffersRecord,
                              pvTotals: _model.pvTotals!,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 100.0),
                  child: wrapWithModel(
                    model: _model.offersCTAModel,
                    updateCallback: () => safeSetState(() {}),
                    child: OffersCTAWidget(
                      message:
                          'Talk through your requirements with one of our friendly team. ',
                      buttonLabel: 'Talk to us',
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
