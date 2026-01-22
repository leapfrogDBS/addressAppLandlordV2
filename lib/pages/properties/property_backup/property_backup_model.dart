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
import '/flutter_flow/flutter_flow_button_tabbar.dart';
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
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'property_backup_widget.dart' show PropertyBackupWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class PropertyBackupModel extends FlutterFlowModel<PropertyBackupWidget> {
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

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Read Document] action in PropertyBackup widget.
  PropertiesRecord? output;
  // Stores action output result for [Firestore Query - Query a collection] action in PropertyBackup widget.
  TenanciesRecord? outputTenancy;
  // Stores action output result for [Firestore Query - Query a collection] action in PropertyBackup widget.
  List<ExpensesRecord>? getExpenses;
  // Stores action output result for [Firestore Query - Query a collection] action in PropertyBackup widget.
  PropertyProjectionsRecord? projectionDoc;
  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;
  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;
  bool isDataUploading_userMainImage = false;
  FFUploadedFile uploadedLocalFile_userMainImage =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_userMainImage = '';

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for liveEarningsProperty component.
  late LiveEarningsPropertyModel liveEarningsPropertyModel;
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
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // State field(s) for mortgageRemaining widget.
  FocusNode? mortgageRemainingFocusNode;
  TextEditingController? mortgageRemainingTextController;
  String? Function(BuildContext, String?)?
      mortgageRemainingTextControllerValidator;
  // State field(s) for mortgageTermRemaining widget.
  FocusNode? mortgageTermRemainingFocusNode;
  TextEditingController? mortgageTermRemainingTextController;
  String? Function(BuildContext, String?)?
      mortgageTermRemainingTextControllerValidator;
  // State field(s) for mortgageMonthlyPayment widget.
  FocusNode? mortgageMonthlyPaymentFocusNode;
  TextEditingController? mortgageMonthlyPaymentTextController;
  String? Function(BuildContext, String?)?
      mortgageMonthlyPaymentTextControllerValidator;
  // Model for recentActivity component.
  late RecentActivityModel recentActivityModel;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

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
    tabBarController?.dispose();
    liveEarningsPropertyModel.dispose();
    statsCombinedModel.dispose();
    statsRentalModel.dispose();
    statsCapitalModel.dispose();
    expandableExpandableController.dispose();
    mortgageRemainingFocusNode?.dispose();
    mortgageRemainingTextController?.dispose();

    mortgageTermRemainingFocusNode?.dispose();
    mortgageTermRemainingTextController?.dispose();

    mortgageMonthlyPaymentFocusNode?.dispose();
    mortgageMonthlyPaymentTextController?.dispose();

    recentActivityModel.dispose();
  }
}
