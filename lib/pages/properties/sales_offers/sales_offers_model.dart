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
import 'sales_offers_widget.dart' show SalesOffersWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class SalesOffersModel extends FlutterFlowModel<SalesOffersWidget> {
  ///  Local state fields for this page.

  PortfolioTotalsStruct? pvTotals;
  void updatePvTotalsStruct(Function(PortfolioTotalsStruct) updateFn) {
    updateFn(pvTotals ??= PortfolioTotalsStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in SalesOffers widget.
  List<PropertyProjectionsRecord>? projectionDocs;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;
  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;
  // Models for salesOffer dynamic component.
  late FlutterFlowDynamicModels<SalesOfferModel> salesOfferModels;
  // Model for Offers_CTA component.
  late OffersCTAModel offersCTAModel;

  @override
  void initState(BuildContext context) {
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
    mainHeaderModel = createModel(context, () => MainHeaderModel());
    salesOfferModels = FlutterFlowDynamicModels(() => SalesOfferModel());
    offersCTAModel = createModel(context, () => OffersCTAModel());
  }

  @override
  void dispose() {
    slideNavigationModel.dispose();
    mainHeaderModel.dispose();
    salesOfferModels.dispose();
    offersCTAModel.dispose();
  }
}
