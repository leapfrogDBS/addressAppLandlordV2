import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/hamburger/hamburger_widget.dart';
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
                ),
              ),
              actions: [],
              centerTitle: true,
              elevation: 2.0,
            )
          ],
          body: Builder(
            builder: (context) {
              return SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        wrapWithModel(
                          model: _model.salesOfferModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: SalesOfferWidget(),
                        ),
                        wrapWithModel(
                          model: _model.salesOfferModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: SalesOfferWidget(),
                        ),
                        wrapWithModel(
                          model: _model.salesOfferModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: SalesOfferWidget(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
