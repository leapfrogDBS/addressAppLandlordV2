import '/components/main_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import '/property_cards/sales_offer/sales_offer_widget.dart';
import 'dart:ui';
import 'sales_offers_widget.dart' show SalesOffersWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class SalesOffersModel extends FlutterFlowModel<SalesOffersWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;
  // Model for salesOffer component.
  late SalesOfferModel salesOfferModel1;
  // Model for salesOffer component.
  late SalesOfferModel salesOfferModel2;
  // Model for salesOffer component.
  late SalesOfferModel salesOfferModel3;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;

  @override
  void initState(BuildContext context) {
    mainHeaderModel = createModel(context, () => MainHeaderModel());
    salesOfferModel1 = createModel(context, () => SalesOfferModel());
    salesOfferModel2 = createModel(context, () => SalesOfferModel());
    salesOfferModel3 = createModel(context, () => SalesOfferModel());
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
  }

  @override
  void dispose() {
    mainHeaderModel.dispose();
    salesOfferModel1.dispose();
    salesOfferModel2.dispose();
    salesOfferModel3.dispose();
    slideNavigationModel.dispose();
  }
}
