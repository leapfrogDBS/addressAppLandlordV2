import '/backend/backend.dart';
import '/components/main_header_widget.dart';
import '/components/offers_c_t_a_widget.dart';
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
  // Model for Offers_CTA component.
  late OffersCTAModel offersCTAModel;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;

  @override
  void initState(BuildContext context) {
    mainHeaderModel = createModel(context, () => MainHeaderModel());
    offersCTAModel = createModel(context, () => OffersCTAModel());
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
  }

  @override
  void dispose() {
    mainHeaderModel.dispose();
    offersCTAModel.dispose();
    slideNavigationModel.dispose();
  }
}
