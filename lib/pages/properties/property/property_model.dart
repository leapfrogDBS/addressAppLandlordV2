import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/schema/structs/index.dart';
import '/components/live_earnings_property_widget.dart';
import '/components/main_header_widget.dart';
import '/components/recent_activity_widget.dart';
import '/components/stats_capital_widget.dart';
import '/components/stats_combined_widget.dart';
import '/components/stats_rental_widget.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'property_widget.dart' show PropertyWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class PropertyModel extends FlutterFlowModel<PropertyWidget> {
  ///  Local state fields for this page.

  double? equity = 66.25;

  double? remaining = 43.75;

  String selectedValue = 'CAPITAL';

  List<DateTime> rentDueDates = [];
  void addToRentDueDates(DateTime item) => rentDueDates.add(item);
  void removeFromRentDueDates(DateTime item) => rentDueDates.remove(item);
  void removeAtIndexFromRentDueDates(int index) => rentDueDates.removeAt(index);
  void insertAtIndexInRentDueDates(int index, DateTime item) =>
      rentDueDates.insert(index, item);
  void updateRentDueDatesAtIndex(int index, Function(DateTime) updateFn) =>
      rentDueDates[index] = updateFn(rentDueDates[index]);

  bool hasActiveTenancy = false;

  bool updatingMortgageEstimate = false;

  bool counterRunning = false;

  double? todayYear;

  double monthlyRental = 0.0;

  EstimatedGainResultsStruct? financialSummary;
  void updateFinancialSummaryStruct(
      Function(EstimatedGainResultsStruct) updateFn) {
    updateFn(financialSummary ??= EstimatedGainResultsStruct());
  }

  PropertyProjectionsRecord? pvProjection;

  int? selectedYearIndex;

  int? selectedYear;

  int? currentYearIndex = 0;

  String tabView = 'financial';

  bool isEditingFinancials = false;

  bool updatingPurchaseInfo = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Read Document] action in Property widget.
  PropertiesRecord? output;
  // Stores action output result for [Firestore Query - Query a collection] action in Property widget.
  List<ExpensesRecord>? getExpenses;
  // Stores action output result for [Firestore Query - Query a collection] action in Property widget.
  PropertyProjectionsRecord? projectionDoc;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;
  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;
  // Model for liveEarningsProperty component.
  late LiveEarningsPropertyModel liveEarningsPropertyModel;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  bool isDataUploading_userImages3 = false;
  List<FFUploadedFile> uploadedLocalFiles_userImages3 = [];
  List<String> uploadedFileUrls_userImages3 = [];

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for ProjectionsYearSelector widget.
  int? projectionsYearSelectorValue;
  FormFieldController<int>? projectionsYearSelectorValueController;
  // Model for statsCombined component.
  late StatsCombinedModel statsCombinedModel;
  // Model for statsRental component.
  late StatsRentalModel statsRentalModel;
  // Model for statsCapital component.
  late StatsCapitalModel statsCapitalModel;
  // State field(s) for purchasePrice widget.
  FocusNode? purchasePriceFocusNode;
  TextEditingController? purchasePriceTextController;
  String? Function(BuildContext, String?)? purchasePriceTextControllerValidator;
  // State field(s) for mortgageRemaining widget.
  FocusNode? mortgageRemainingFocusNode;
  TextEditingController? mortgageRemainingTextController;
  String? Function(BuildContext, String?)?
      mortgageRemainingTextControllerValidator;
  // Model for recentActivity component.
  late RecentActivityModel recentActivityModel;

  @override
  void initState(BuildContext context) {
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
    mainHeaderModel = createModel(context, () => MainHeaderModel());
    liveEarningsPropertyModel =
        createModel(context, () => LiveEarningsPropertyModel());
    statsCombinedModel = createModel(context, () => StatsCombinedModel());
    statsRentalModel = createModel(context, () => StatsRentalModel());
    statsCapitalModel = createModel(context, () => StatsCapitalModel());
    recentActivityModel = createModel(context, () => RecentActivityModel());
  }

  @override
  void dispose() {
    slideNavigationModel.dispose();
    mainHeaderModel.dispose();
    liveEarningsPropertyModel.dispose();
    statsCombinedModel.dispose();
    statsRentalModel.dispose();
    statsCapitalModel.dispose();
    purchasePriceFocusNode?.dispose();
    purchasePriceTextController?.dispose();

    mortgageRemainingFocusNode?.dispose();
    mortgageRemainingTextController?.dispose();

    recentActivityModel.dispose();
  }
}
