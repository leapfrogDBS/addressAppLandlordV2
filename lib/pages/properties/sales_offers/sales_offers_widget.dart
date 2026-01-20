import '/backend/backend.dart';
import '/components/main_header_widget.dart';
import '/components/offers_c_t_a_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import '/property_cards/sales_offer/sales_offer_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
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
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 80.0),
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
                        List<SalesOffersRecord> columnSalesOffersRecordList =
                            snapshot.data!;

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(columnSalesOffersRecordList.length,
                                  (columnIndex) {
                            final columnSalesOffersRecord =
                                columnSalesOffersRecordList[columnIndex];
                            return SalesOfferWidget(
                              key: Key(
                                  'Keybgm_${columnIndex}_of_${columnSalesOffersRecordList.length}'),
                              salesOffer: columnSalesOffersRecord,
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.offersCTAModel,
                  updateCallback: () => safeSetState(() {}),
                  child: OffersCTAWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
