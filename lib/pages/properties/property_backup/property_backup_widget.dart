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
import 'property_backup_model.dart';
export 'property_backup_model.dart';

class PropertyBackupWidget extends StatefulWidget {
  const PropertyBackupWidget({
    super.key,
    required this.propID,
  });

  final DocumentReference? propID;

  static String routeName = 'PropertyBackup';
  static String routePath = '/singlepropertyV2';

  @override
  State<PropertyBackupWidget> createState() => _PropertyBackupWidgetState();
}

class _PropertyBackupWidgetState extends State<PropertyBackupWidget>
    with TickerProviderStateMixin {
  late PropertyBackupModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PropertyBackupModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.output = await PropertiesRecord.getDocumentOnce(widget!.propID!);
      _model.outputTenancy = await queryTenanciesRecordOnce(
        parent: widget!.propID,
        queryBuilder: (tenanciesRecord) => tenanciesRecord.where(
          'isActive',
          isEqualTo: true,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if (_model.outputTenancy?.reference != null) {
        _model.hasActiveTenancy = true;
        _model.monthlyRental = _model.outputTenancy!.rentAmount;
        _model.rentDueDates = functions
            .generateRentDueDates(_model.outputTenancy?.tenancyStartDate,
                _model.outputTenancy?.rentDueDay)!
            .toList()
            .cast<DateTime>();
        safeSetState(() {});
      } else {
        _model.hasActiveTenancy = false;
        safeSetState(() {});
      }

      _model.getExpenses = await queryExpensesRecordOnce(
        queryBuilder: (expensesRecord) => expensesRecord
            .where(
              'propertyId',
              isEqualTo: widget!.propID?.id,
            )
            .where(
              'occuredAt',
              isGreaterThanOrEqualTo: functions.getStartOfYear(),
            )
            .where(
              'occuredAt',
              isLessThanOrEqualTo: functions.getEndOfYear(),
            ),
      );
      _model.projectionDoc = await queryPropertyProjectionsRecordOnce(
        queryBuilder: (propertyProjectionsRecord) =>
            propertyProjectionsRecord.where(
          'propertyRef',
          isEqualTo: widget!.propID,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      _model.pvProjection = _model.projectionDoc;
      safeSetState(() {});
      _model.selectedYear = functions.getCurrentYear();
      _model.selectedYearIndex = functions.yearIndex(
          _model.pvProjection?.years?.toList(), functions.getCurrentYear()!);
      _model.currentYearIndex = functions.yearIndex(
          _model.projectionDoc?.years?.toList(), functions.getCurrentYear()!);
      safeSetState(() {});
      _model.financialSummary = functions.calculateEstimatedAnnualGain(
          _model.output!.estimatedValue,
          _model.output!.purchasePrice,
          _model.output!.previousRentalIncome,
          _model.output!.previousExpenses,
          _model.pvProjection,
          _model.currentYearIndex!);
      safeSetState(() {});
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.expandableExpandableController =
        ExpandableController(initialExpanded: false);

    _model.mortgageRemainingFocusNode ??= FocusNode();

    _model.mortgageTermRemainingFocusNode ??= FocusNode();

    _model.mortgageMonthlyPaymentFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PropertiesRecord>(
      stream: PropertiesRecord.getDocument(widget!.propID!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        final propertyBackupPropertiesRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
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
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                wrapWithModel(
                  model: _model.mainHeaderModel,
                  updateCallback: () => safeSetState(() {}),
                  child: MainHeaderWidget(
                    isRootScreen: false,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Stack(
                            alignment: AlignmentDirectional(0.0, 1.0),
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      1.0, 0.0, 0.0, 0.0),
                                  child: Hero(
                                    tag: propertyBackupPropertiesRecord
                                        .mainPhoto,
                                    transitionOnUserGestures: true,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.network(
                                        propertyBackupPropertiesRecord
                                            .mainPhoto,
                                        width: double.infinity,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (propertyBackupPropertiesRecord.title !=
                                      null &&
                                  propertyBackupPropertiesRecord.title != '')
                                Align(
                                  alignment: AlignmentDirectional(0.0, 1.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0x000C2337),
                                          FlutterFlowTheme.of(context).primary
                                        ],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      ),
                                    ),
                                    alignment: AlignmentDirectional(0.0, 1.0),
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            50.0, 0.0, 50.0, 30.0),
                                        child: Text(
                                          propertyBackupPropertiesRecord.title
                                              .maybeHandleOverflow(
                                            maxChars: 50,
                                            replacement: '…',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'Thunder',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (propertyBackupPropertiesRecord.title ==
                                      null ||
                                  propertyBackupPropertiesRecord.title == '')
                                Align(
                                  alignment: AlignmentDirectional(0.0, 1.16),
                                  child: Container(
                                    width: double.infinity,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0x000C2337),
                                          FlutterFlowTheme.of(context).primary
                                        ],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      ),
                                    ),
                                    alignment: AlignmentDirectional(0.0, 1.0),
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            50.0, 0.0, 50.0, 30.0),
                                        child: Text(
                                          propertyBackupPropertiesRecord
                                              .addressFormatted
                                              .maybeHandleOverflow(
                                            maxChars: 50,
                                            replacement: '…',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .displayLarge
                                              .override(
                                                fontFamily: 'Thunder',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: AlignmentDirectional(1.0, -1.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 12.0, 12.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      var confirmDialogResponse =
                                          await showDialog<bool>(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return WebViewAware(
                                                    child: AlertDialog(
                                                      title:
                                                          Text('Change Image'),
                                                      content: Text(
                                                          'Do you want to change the main image for this property?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  false),
                                                          child: Text('No'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext,
                                                                  true),
                                                          child: Text('Yes'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ) ??
                                              false;
                                      if (confirmDialogResponse) {
                                        final selectedMedia =
                                            await selectMediaWithSourceBottomSheet(
                                          context: context,
                                          allowPhoto: true,
                                        );
                                        if (selectedMedia != null &&
                                            selectedMedia.every((m) =>
                                                validateFileFormat(
                                                    m.storagePath, context))) {
                                          safeSetState(() => _model
                                                  .isDataUploading_userMainImage =
                                              true);
                                          var selectedUploadedFiles =
                                              <FFUploadedFile>[];

                                          var downloadUrls = <String>[];
                                          try {
                                            selectedUploadedFiles =
                                                selectedMedia
                                                    .map((m) => FFUploadedFile(
                                                          name: m.storagePath
                                                              .split('/')
                                                              .last,
                                                          bytes: m.bytes,
                                                          height: m.dimensions
                                                              ?.height,
                                                          width: m.dimensions
                                                              ?.width,
                                                          blurHash: m.blurHash,
                                                          originalFilename: m
                                                              .originalFilename,
                                                        ))
                                                    .toList();

                                            downloadUrls = (await Future.wait(
                                              selectedMedia.map(
                                                (m) async => await uploadData(
                                                    m.storagePath, m.bytes),
                                              ),
                                            ))
                                                .where((u) => u != null)
                                                .map((u) => u!)
                                                .toList();
                                          } finally {
                                            _model.isDataUploading_userMainImage =
                                                false;
                                          }
                                          if (selectedUploadedFiles.length ==
                                                  selectedMedia.length &&
                                              downloadUrls.length ==
                                                  selectedMedia.length) {
                                            safeSetState(() {
                                              _model.uploadedLocalFile_userMainImage =
                                                  selectedUploadedFiles.first;
                                              _model.uploadedFileUrl_userMainImage =
                                                  downloadUrls.first;
                                            });
                                          } else {
                                            safeSetState(() {});
                                            return;
                                          }
                                        }

                                        await widget!.propID!
                                            .update(createPropertiesRecordData(
                                          mainPhoto: _model
                                              .uploadedFileUrl_userMainImage,
                                        ));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Image Updated!',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    font: GoogleFonts.figtree(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                          ),
                                        );
                                      } else {
                                        await Future.delayed(
                                          Duration(
                                            milliseconds: 10,
                                          ),
                                        );
                                      }
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 28.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              50.0, 20.0, 50.0, 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Text(
                                            FFLocalizations.of(context).getText(
                                              '9pacpwnm' /* Purchase Price */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.figtree(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .greyBlue,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Text(
                                            formatNumber(
                                              propertyBackupPropertiesRecord
                                                  .purchasePrice,
                                              formatType: FormatType.decimal,
                                              decimalType:
                                                  DecimalType.automatic,
                                              currency: '£',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .displayLarge
                                                .override(
                                                  fontFamily: 'Thunder',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Text(
                                            FFLocalizations.of(context).getText(
                                              'cv65xn2p' /* Estimated Value */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.figtree(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .greyBlue,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Text(
                                                formatNumber(
                                                  propertyBackupPropertiesRecord
                                                      .estimatedValue,
                                                  formatType:
                                                      FormatType.decimal,
                                                  decimalType:
                                                      DecimalType.automatic,
                                                  currency: '£',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displayLarge
                                                        .override(
                                                          fontFamily: 'Thunder',
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    functions.percentageIncreaseAlltime(
                                                        propertyBackupPropertiesRecord
                                                            .purchasePrice,
                                                        propertyBackupPropertiesRecord
                                                            .estimatedValue),
                                                    'Unkown',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.figtree(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 4.0)),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'zy5uxmok' /* Time held */,
                                              ),
                                              textAlign: TextAlign.start,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.figtree(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .greyBlue,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              valueOrDefault<String>(
                                                functions.timeHeldFunction(
                                                    propertyBackupPropertiesRecord
                                                        .purchaseDate),
                                                'Unkown',
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .displayLarge
                                                      .override(
                                                        fontFamily: 'Thunder',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 8.0)),
                                      ),
                                    ),
                                    if (_model.hasActiveTenancy)
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: StreamBuilder<
                                            List<TenanciesRecord>>(
                                          stream: queryTenanciesRecord(
                                            parent: widget!.propID,
                                            queryBuilder: (tenanciesRecord) =>
                                                tenanciesRecord.where(
                                              'isActive',
                                              isEqualTo: true,
                                            ),
                                            singleRecord: true,
                                          ),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            List<TenanciesRecord>
                                                columnTenanciesRecordList =
                                                snapshot.data!;
                                            // Return an empty Container when the item does not exist.
                                            if (snapshot.data!.isEmpty) {
                                              return Container();
                                            }
                                            final columnTenanciesRecord =
                                                columnTenanciesRecordList
                                                        .isNotEmpty
                                                    ? columnTenanciesRecordList
                                                        .first
                                                    : null;

                                            return Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'lim2ptr8' /* Rent (£pcm) */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .figtree(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .greyBlue,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: Text(
                                                    formatNumber(
                                                      columnTenanciesRecord!
                                                          .rentAmount,
                                                      formatType:
                                                          FormatType.decimal,
                                                      decimalType:
                                                          DecimalType.automatic,
                                                      currency: '£',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .displayLarge
                                                        .override(
                                                          fontFamily: 'Thunder',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 8.0)),
                                            );
                                          },
                                        ),
                                      ),
                                  ].divide(SizedBox(width: 4.0)),
                                ),
                              ),
                            ].divide(SizedBox(height: 17.0)),
                          ),
                        ),
                        Container(
                          height: 1800.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment(0.0, 0),
                                child: FlutterFlowButtonTabBar(
                                  useToggleButtonStyle: false,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .override(
                                        fontFamily: 'Thunder',
                                        fontSize: 20.0,
                                        letterSpacing: 1.0,
                                      ),
                                  unselectedLabelStyle:
                                      FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .override(
                                            fontFamily: 'Thunder',
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                          ),
                                  labelColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  unselectedLabelColor:
                                      FlutterFlowTheme.of(context).greyBlue,
                                  backgroundColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  unselectedBackgroundColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  borderWidth: 0.0,
                                  borderRadius: 4.0,
                                  elevation: 0.0,
                                  buttonMargin: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 8.0, 0.0),
                                  padding: EdgeInsets.all(10.0),
                                  tabs: [
                                    Tab(
                                      text: FFLocalizations.of(context).getText(
                                        'qqq7h37u' /* FINANCIAL */,
                                      ),
                                    ),
                                    Tab(
                                      text: FFLocalizations.of(context).getText(
                                        'p88cvozw' /* TIMELINE */,
                                      ),
                                    ),
                                    Tab(
                                      text: FFLocalizations.of(context).getText(
                                        '3snwt6a7' /* MEDIA */,
                                      ),
                                    ),
                                  ],
                                  controller: _model.tabBarController,
                                  onTap: (i) async {
                                    [
                                      () async {},
                                      () async {},
                                      () async {}
                                    ][i]();
                                  },
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _model.tabBarController,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  16.0,
                                                                  16.0,
                                                                  0.0),
                                                      child:
                                                          AuthUserStreamWidget(
                                                        builder: (context) =>
                                                            wrapWithModel(
                                                          model: _model
                                                              .liveEarningsPropertyModel,
                                                          updateCallback: () =>
                                                              safeSetState(
                                                                  () {}),
                                                          child:
                                                              LiveEarningsPropertyWidget(
                                                            yearlyGain:
                                                                valueOrDefault<
                                                                    double>(
                                                              _model
                                                                  .financialSummary
                                                                  ?.gainThisYear,
                                                              0.0,
                                                            ),
                                                            dailyGain:
                                                                valueOrDefault<
                                                                    double>(
                                                              _model
                                                                  .financialSummary
                                                                  ?.gainPerDay,
                                                              0.0,
                                                            ),
                                                            secondGain:
                                                                valueOrDefault<
                                                                    double>(
                                                              _model
                                                                  .financialSummary
                                                                  ?.gainPerSecond,
                                                              0.0,
                                                            ),
                                                            earningsToDate: _model
                                                                .financialSummary!
                                                                .earningsAsOfNow,
                                                            headingText:
                                                                'This property has earned you since ${dateTimeFormat(
                                                              "yyyy",
                                                              currentUserDocument
                                                                  ?.createdTime,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            )}.....',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (_model.hasActiveTenancy)
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  1.0,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          10.0),
                                                              child:
                                                                  FlutterFlowChoiceChips(
                                                                options: [
                                                                  ChipData(FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'jn5d3e1d' /* COMBINED */,
                                                                  )),
                                                                  ChipData(FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    '6aua16u0' /* CAPITAL */,
                                                                  )),
                                                                  ChipData(FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'va292u65' /* RENTAL */,
                                                                  ))
                                                                ],
                                                                onChanged:
                                                                    (val) async {
                                                                  safeSetState(() =>
                                                                      _model.choiceChipsValue =
                                                                          val?.firstOrNull);
                                                                  _model.selectedValue =
                                                                      _model
                                                                          .choiceChipsValue!;
                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                selectedChipStyle:
                                                                    ChipStyle(
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .tertiary,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .figtree(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                  iconColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .info,
                                                                  iconSize:
                                                                      14.0,
                                                                  labelPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  elevation:
                                                                      0.0,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                unselectedChipStyle:
                                                                    ChipStyle(
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .figtree(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                  iconColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  iconSize:
                                                                      16.0,
                                                                  labelPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  elevation:
                                                                      0.0,
                                                                  borderColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  borderWidth:
                                                                      1.0,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                chipSpacing:
                                                                    8.0,
                                                                rowSpacing: 8.0,
                                                                multiselect:
                                                                    false,
                                                                initialized:
                                                                    _model.choiceChipsValue !=
                                                                        null,
                                                                alignment:
                                                                    WrapAlignment
                                                                        .start,
                                                                controller: _model
                                                                        .choiceChipsValueController ??=
                                                                    FormFieldController<
                                                                        List<
                                                                            String>>(
                                                                  [
                                                                    FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'lsczoata' /* CAPITAL */,
                                                                    )
                                                                  ],
                                                                ),
                                                                wrapped: true,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    10.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child:
                                                            AuthUserStreamWidget(
                                                          builder: (context) =>
                                                              Container(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width *
                                                                1.0,
                                                            height: 320.0,
                                                            child: custom_widgets
                                                                .PropertyProjectionChart2(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  1.0,
                                                              height: 320.0,
                                                              chartViewType: _model
                                                                  .selectedValue,
                                                              projection: _model
                                                                  .pvProjection,
                                                              hasActiveTenancy:
                                                                  _model
                                                                      .hasActiveTenancy,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 20.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    40.0,
                                                                    0.0,
                                                                    40.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          6.0,
                                                                          0.0),
                                                              child: RichText(
                                                                textScaler: MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: FFLocalizations.of(
                                                                              context)
                                                                          .getText(
                                                                        'jquhazqe' /* PROJECTIONS FOR  */,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .displayLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                'Thunder',
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    )
                                                                  ],
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .figtree(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            FlutterFlowDropDown<
                                                                int>(
                                                              controller: _model
                                                                      .projectionsYearSelectorValueController ??=
                                                                  FormFieldController<
                                                                      int>(
                                                                _model.projectionsYearSelectorValue ??=
                                                                    functions
                                                                        .getCurrentYear(),
                                                              ),
                                                              options: List<
                                                                      int>.from(
                                                                  _model
                                                                      .pvProjection!
                                                                      .years),
                                                              optionLabels: <String>[],
                                                              onChanged:
                                                                  (val) async {
                                                                safeSetState(() =>
                                                                    _model.projectionsYearSelectorValue =
                                                                        val);
                                                                _model.selectedYear =
                                                                    _model
                                                                        .projectionsYearSelectorValue;
                                                                _model.selectedYearIndex = functions.yearIndex(
                                                                    _model
                                                                        .pvProjection
                                                                        ?.years
                                                                        ?.toList(),
                                                                    _model
                                                                        .projectionsYearSelectorValue!);
                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              width: 120.0,
                                                              height: 36.0,
                                                              textStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .displayLarge
                                                                      .override(
                                                                        fontFamily:
                                                                            'Thunder',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                              icon: Icon(
                                                                Icons
                                                                    .keyboard_arrow_down_rounded,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                size: 32.0,
                                                              ),
                                                              fillColor: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              elevation: 2.0,
                                                              borderColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                              borderWidth: 2.0,
                                                              borderRadius: 8.0,
                                                              margin:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          6.0,
                                                                          12.0,
                                                                          6.0),
                                                              hidesUnderline:
                                                                  true,
                                                              isOverButton:
                                                                  false,
                                                              isSearchable:
                                                                  false,
                                                              isMultiSelect:
                                                                  false,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (_model
                                                              .selectedValue ==
                                                          'COMBINED')
                                                        Expanded(
                                                          child: wrapWithModel(
                                                            model: _model
                                                                .statsCombinedModel,
                                                            updateCallback: () =>
                                                                safeSetState(
                                                                    () {}),
                                                            child:
                                                                StatsCombinedWidget(
                                                              selectedYearIndex:
                                                                  _model
                                                                      .selectedYearIndex!,
                                                              projections: _model
                                                                  .pvProjection!,
                                                            ),
                                                          ),
                                                        ),
                                                      if (_model
                                                              .selectedValue ==
                                                          'RENTAL')
                                                        wrapWithModel(
                                                          model: _model
                                                              .statsRentalModel,
                                                          updateCallback: () =>
                                                              safeSetState(
                                                                  () {}),
                                                          child:
                                                              StatsRentalWidget(
                                                            selectedYearIndex:
                                                                valueOrDefault<
                                                                    int>(
                                                              _model
                                                                  .selectedYearIndex,
                                                              0,
                                                            ),
                                                            projections: _model
                                                                .pvProjection!,
                                                          ),
                                                        ),
                                                      if (_model
                                                              .selectedValue ==
                                                          'CAPITAL')
                                                        wrapWithModel(
                                                          model: _model
                                                              .statsCapitalModel,
                                                          updateCallback: () =>
                                                              safeSetState(
                                                                  () {}),
                                                          child:
                                                              StatsCapitalWidget(
                                                            selectedYearIndex:
                                                                valueOrDefault<
                                                                    int>(
                                                              _model
                                                                  .selectedYearIndex,
                                                              0,
                                                            ),
                                                            projections: _model
                                                                .pvProjection!,
                                                          ),
                                                        ),
                                                    ].divide(
                                                        SizedBox(height: 14.0)),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 0.0)),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 20.0, 20.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    2.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .accent4,
                                                          child:
                                                              ExpandableNotifier(
                                                            controller: _model
                                                                .expandableExpandableController,
                                                            child:
                                                                ExpandablePanel(
                                                              header: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            20.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'vyygmetm' /* EQUITY */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .displayMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Thunder',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                              ),
                                                              collapsed:
                                                                  Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 0.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                              ),
                                                              expanded: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  if ((propertyBackupPropertiesRecord
                                                                              .mortgageRemaining >
                                                                          0.0) &&
                                                                      !_model
                                                                          .updatingMortgageEstimate)
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          20.0,
                                                                          10.0,
                                                                          20.0,
                                                                          5.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Text(
                                                                            FFLocalizations.of(context).getText(
                                                                              '57wcr3pg' /* Estimated mortage remaing */,
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  font: GoogleFonts.figtree(
                                                                                    fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                                  ),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            formatNumber(
                                                                              propertyBackupPropertiesRecord.mortgageRemaining,
                                                                              formatType: FormatType.decimal,
                                                                              decimalType: DecimalType.automatic,
                                                                              currency: '£',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                                                  fontFamily: 'Thunder',
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                5.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                _model.updatingMortgageEstimate = true;
                                                                                safeSetState(() {});
                                                                              },
                                                                              child: Icon(
                                                                                Icons.edit,
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                size: 18.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 10.0)),
                                                                      ),
                                                                    ),
                                                                  if ((propertyBackupPropertiesRecord
                                                                              .mortgageRemaining >
                                                                          0.0) &&
                                                                      !_model
                                                                          .updatingMortgageEstimate)
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          20.0,
                                                                          5.0,
                                                                          20.0,
                                                                          5.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Text(
                                                                            FFLocalizations.of(context).getText(
                                                                              'u9kzdjfg' /* Mortgage term remaining */,
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  font: GoogleFonts.figtree(
                                                                                    fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                                  ),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            propertyBackupPropertiesRecord.mortgageTermRemaining.toString(),
                                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                                                  fontFamily: 'Thunder',
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 10.0)),
                                                                      ),
                                                                    ),
                                                                  if ((propertyBackupPropertiesRecord
                                                                              .mortgageRemaining >
                                                                          0.0) &&
                                                                      !_model
                                                                          .updatingMortgageEstimate)
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          20.0,
                                                                          5.0,
                                                                          20.0,
                                                                          10.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Text(
                                                                            FFLocalizations.of(context).getText(
                                                                              'ift27so0' /* Monthly  repayment */,
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  font: GoogleFonts.figtree(
                                                                                    fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                                  ),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            formatNumber(
                                                                              propertyBackupPropertiesRecord.mortgageMonthlyPayment,
                                                                              formatType: FormatType.decimal,
                                                                              decimalType: DecimalType.automatic,
                                                                              currency: '£',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                                                  fontFamily: 'Thunder',
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                        ].divide(SizedBox(width: 10.0)),
                                                                      ),
                                                                    ),
                                                                  if (!propertyBackupPropertiesRecord
                                                                          .mortgageEntered ||
                                                                      _model
                                                                          .updatingMortgageEstimate)
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              16.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Text(
                                                                            FFLocalizations.of(context).getText(
                                                                              'di46qnyg' /* Please enter the estimated mor... */,
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  font: GoogleFonts.figtree(
                                                                                    fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                                  ),
                                                                                  color: FlutterFlowTheme.of(context).greyBlue,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                16.0),
                                                                            child:
                                                                                Container(
                                                                              width: double.infinity,
                                                                              child: TextFormField(
                                                                                controller: _model.mortgageRemainingTextController ??= TextEditingController(
                                                                                  text: propertyBackupPropertiesRecord.mortgageRemaining.toString(),
                                                                                ),
                                                                                focusNode: _model.mortgageRemainingFocusNode,
                                                                                autofocus: true,
                                                                                autofillHints: [
                                                                                  AutofillHints.email
                                                                                ],
                                                                                obscureText: false,
                                                                                decoration: InputDecoration(
                                                                                  labelText: FFLocalizations.of(context).getText(
                                                                                    '62v98rsl' /* Enter outstanding mortgage val... */,
                                                                                  ),
                                                                                  labelStyle: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                        font: GoogleFonts.figtree(
                                                                                          fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                        ),
                                                                                        color: FlutterFlowTheme.of(context).greyBlue,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                      ),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).alternate,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  errorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  focusedErrorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  contentPadding: EdgeInsets.all(24.0),
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                                keyboardType: TextInputType.number,
                                                                                cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                validator: _model.mortgageRemainingTextControllerValidator.asValidator(context),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                16.0),
                                                                            child:
                                                                                Container(
                                                                              width: double.infinity,
                                                                              child: TextFormField(
                                                                                controller: _model.mortgageTermRemainingTextController ??= TextEditingController(
                                                                                  text: propertyBackupPropertiesRecord.mortgageTermRemaining.toString(),
                                                                                ),
                                                                                focusNode: _model.mortgageTermRemainingFocusNode,
                                                                                autofocus: true,
                                                                                autofillHints: [
                                                                                  AutofillHints.email
                                                                                ],
                                                                                obscureText: false,
                                                                                decoration: InputDecoration(
                                                                                  labelText: FFLocalizations.of(context).getText(
                                                                                    'e3cabe6w' /* Enter mortgage term remaining ... */,
                                                                                  ),
                                                                                  labelStyle: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                        font: GoogleFonts.figtree(
                                                                                          fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                        ),
                                                                                        color: FlutterFlowTheme.of(context).greyBlue,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                      ),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).alternate,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  errorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  focusedErrorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  contentPadding: EdgeInsets.all(24.0),
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                                keyboardType: TextInputType.number,
                                                                                cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                validator: _model.mortgageTermRemainingTextControllerValidator.asValidator(context),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                16.0),
                                                                            child:
                                                                                Container(
                                                                              width: double.infinity,
                                                                              child: TextFormField(
                                                                                controller: _model.mortgageMonthlyPaymentTextController ??= TextEditingController(
                                                                                  text: propertyBackupPropertiesRecord.mortgageMonthlyPayment.toString(),
                                                                                ),
                                                                                focusNode: _model.mortgageMonthlyPaymentFocusNode,
                                                                                autofocus: true,
                                                                                autofillHints: [
                                                                                  AutofillHints.email
                                                                                ],
                                                                                obscureText: false,
                                                                                decoration: InputDecoration(
                                                                                  labelText: FFLocalizations.of(context).getText(
                                                                                    'qenbu2bg' /* Enter monthly repayment */,
                                                                                  ),
                                                                                  labelStyle: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                        font: GoogleFonts.figtree(
                                                                                          fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                        ),
                                                                                        color: FlutterFlowTheme.of(context).greyBlue,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                      ),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).alternate,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  errorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  focusedErrorBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).error,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  contentPadding: EdgeInsets.all(24.0),
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                                keyboardType: TextInputType.number,
                                                                                cursorColor: FlutterFlowTheme.of(context).primary,
                                                                                validator: _model.mortgageMonthlyPaymentTextControllerValidator.asValidator(context),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                AlignmentDirectional(-1.0, 0.0),
                                                                            child:
                                                                                FFButtonWidget(
                                                                              onPressed: () async {
                                                                                await widget!.propID!.update(createPropertiesRecordData(
                                                                                  mortgageRemaining: double.tryParse(_model.mortgageRemainingTextController.text),
                                                                                  mortgageTermRemaining: int.tryParse(_model.mortgageTermRemainingTextController.text),
                                                                                  mortgageMonthlyPayment: double.tryParse(_model.mortgageMonthlyPaymentTextController.text),
                                                                                ));
                                                                                _model.updatingMortgageEstimate = false;
                                                                                safeSetState(() {});
                                                                              },
                                                                              text: FFLocalizations.of(context).getText(
                                                                                'kh41m60h' /* Save */,
                                                                              ),
                                                                              options: FFButtonOptions(
                                                                                height: 40.0,
                                                                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                      ),
                                                                                      color: Colors.white,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                    ),
                                                                                elevation: 0.0,
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(height: 10.0)),
                                                                      ),
                                                                    ),
                                                                  if ((propertyBackupPropertiesRecord
                                                                              .mortgageRemaining >
                                                                          0.0) &&
                                                                      !_model
                                                                          .updatingMortgageEstimate)
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              16.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children:
                                                                            [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'g2r6q31u' /* Estimated Value */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                formatNumber(
                                                                                  propertyBackupPropertiesRecord.estimatedValue,
                                                                                  formatType: FormatType.decimal,
                                                                                  decimalType: DecimalType.automatic,
                                                                                  currency: '£',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'crtjq8nt' /* Remaing Mortgage */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                formatNumber(
                                                                                  propertyBackupPropertiesRecord.mortgageRemaining,
                                                                                  formatType: FormatType.decimal,
                                                                                  decimalType: DecimalType.automatic,
                                                                                  currency: '£',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'bs0x5uzu' /* Equity */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                formatNumber(
                                                                                  functions.subtractDoubles(propertyBackupPropertiesRecord.estimatedValue, propertyBackupPropertiesRecord.mortgageRemaining),
                                                                                  formatType: FormatType.decimal,
                                                                                  decimalType: DecimalType.automatic,
                                                                                  currency: '£',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                FFLocalizations.of(context).getText(
                                                                                  'rbecxjty' /* Equity Share */,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                formatNumber(
                                                                                  functions.percentOfDifferenceRelativeToLarge(propertyBackupPropertiesRecord.estimatedValue, propertyBackupPropertiesRecord.mortgageRemaining),
                                                                                  formatType: FormatType.percent,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                double.infinity,
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Container(
                                                                              width: 370.0,
                                                                              height: 230.0,
                                                                              child: FlutterFlowPieChart(
                                                                                data: FFPieChartData(
                                                                                  values: [
                                                                                    functions.percentOfDifferenceRelativeToLarge(propertyBackupPropertiesRecord.estimatedValue, propertyBackupPropertiesRecord.mortgageRemaining).toString(),
                                                                                    functions.percentOfDifferenceRelativeToLargeOther(propertyBackupPropertiesRecord.estimatedValue, propertyBackupPropertiesRecord.mortgageRemaining).toString()
                                                                                  ],
                                                                                  colors: [
                                                                                    FlutterFlowTheme.of(context).primary,
                                                                                    FlutterFlowTheme.of(context).accent2
                                                                                  ],
                                                                                  radius: [
                                                                                    100.0,
                                                                                    100.0
                                                                                  ],
                                                                                  borderColor: [
                                                                                    Colors.transparent,
                                                                                    Color(0x00000000)
                                                                                  ],
                                                                                ),
                                                                                donutHoleRadius: 0.0,
                                                                                donutHoleColor: Colors.transparent,
                                                                                sectionLabelType: PieChartSectionLabelType.percent,
                                                                                sectionLabelStyle: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                      font: GoogleFonts.figtree(
                                                                                        fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                      ),
                                                                                      color: FlutterFlowTheme.of(context).accent4,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ].divide(SizedBox(height: 9.0)),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                              theme:
                                                                  ExpandableThemeData(
                                                                tapHeaderToExpand:
                                                                    true,
                                                                tapBodyToExpand:
                                                                    false,
                                                                tapBodyToCollapse:
                                                                    false,
                                                                headerAlignment:
                                                                    ExpandablePanelHeaderAlignment
                                                                        .center,
                                                                hasIcon: true,
                                                                expandIcon: Icons
                                                                    .add_circle,
                                                                collapseIcon: Icons
                                                                    .remove_circle,
                                                                iconSize: 28.0,
                                                                iconColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                iconPadding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0.0,
                                                                            20.0,
                                                                            20.0,
                                                                            20.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 7.0)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 20.0, 0.0, 0.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      50.0, 20.0, 50.0, 20.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  if (_model.hasActiveTenancy)
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -1.0,
                                                                        0.0),
                                                                child: Text(
                                                                  FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'gu21mo4s' /* Tenancy Start */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .figtree(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .greyBlue,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  dateTimeFormat(
                                                                    "d/M/y",
                                                                    _model
                                                                        .outputTenancy
                                                                        ?.tenancyStartDate,
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ),
                                                                  'N/A',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .displayLarge
                                                                    .override(
                                                                      fontFamily:
                                                                          'Thunder',
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 8.0)),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -1.0,
                                                                        0.0),
                                                                child: Text(
                                                                  FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'vq63oouw' /* Next Rent Review */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .figtree(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .greyBlue,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  dateTimeFormat(
                                                                    "d/M/y",
                                                                    propertyBackupPropertiesRecord
                                                                        .nextRentReviewDate,
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ),
                                                                  'N/A',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .displayLarge
                                                                    .override(
                                                                      fontFamily:
                                                                          'Thunder',
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 8.0)),
                                                          ),
                                                        ),
                                                      ].divide(
                                                          SizedBox(width: 4.0)),
                                                    ),
                                                  if (_model.hasActiveTenancy)
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1.0, 0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    -1.0, 0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          -1.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'vjdcqhsk' /* Rent Amount */,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.figtree(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).greyBlue,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    RichText(
                                                                      textScaler:
                                                                          MediaQuery.of(context)
                                                                              .textScaler,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                valueOrDefault<String>(
                                                                              formatNumber(
                                                                                _model.outputTenancy?.rentAmount,
                                                                                formatType: FormatType.decimal,
                                                                                decimalType: DecimalType.automatic,
                                                                                currency: '£',
                                                                              ),
                                                                              'N/A',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).displayLarge.override(
                                                                                  fontFamily: 'Thunder',
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          )
                                                                        ],
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .displayLarge
                                                                            .override(
                                                                              fontFamily: 'Thunder',
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      FFLocalizations.of(
                                                                              context)
                                                                          .getText(
                                                                        'z8hs4e5y' /* per month */,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.figtree(
                                                                              fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ].divide(SizedBox(
                                                                  height: 8.0)),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    -1.0, 0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          -1.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'y9qofxmb' /* Rent Due Date */,
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.figtree(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).greyBlue,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          -1.0,
                                                                          0.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      RichText(
                                                                        textScaler:
                                                                            MediaQuery.of(context).textScaler,
                                                                        text:
                                                                            TextSpan(
                                                                          children: [
                                                                            TextSpan(
                                                                              text: valueOrDefault<String>(
                                                                                _model.outputTenancy?.rentDueDay.toString(),
                                                                                'N/A',
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).displayLarge.override(
                                                                                    fontFamily: 'Thunder',
                                                                                    letterSpacing: 0.0,
                                                                                  ),
                                                                            )
                                                                          ],
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.figtree(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        FFLocalizations.of(context)
                                                                            .getText(
                                                                          'gdxklgrq' /* of each month */,
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelSmall
                                                                            .override(
                                                                              font: GoogleFonts.figtree(
                                                                                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  height: 8.0)),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 4.0)),
                                                      ),
                                                    ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -1.0,
                                                                        0.0),
                                                                child: Text(
                                                                  FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'pe0cvk1o' /* Last Valuation Date */,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .figtree(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .greyBlue,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                              Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  dateTimeFormat(
                                                                    "d/M/y",
                                                                    propertyBackupPropertiesRecord
                                                                        .lastValuationDate,
                                                                    locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                                  ),
                                                                  'N/A',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .displayLarge
                                                                    .override(
                                                                      fontFamily:
                                                                          'Thunder',
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 8.0)),
                                                          ),
                                                        ),
                                                      ].divide(
                                                          SizedBox(width: 4.0)),
                                                    ),
                                                  ),
                                                ].divide(
                                                    SizedBox(height: 17.0)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 0.0, 20.0, 0.0),
                                            child: StreamBuilder<
                                                List<EventsRecord>>(
                                              stream: queryEventsRecord(
                                                queryBuilder: (eventsRecord) =>
                                                    eventsRecord.where(
                                                  'propertyRef',
                                                  isEqualTo: widget!.propID,
                                                ),
                                              ),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                List<EventsRecord>
                                                    rentDueCalendarEventsRecordList =
                                                    snapshot.data!;

                                                return Container(
                                                  width: double.infinity,
                                                  height: 400.0,
                                                  child: custom_widgets
                                                      .RentDueCalendar(
                                                    width: double.infinity,
                                                    height: 400.0,
                                                    rentDueDates:
                                                        _model.rentDueDates,
                                                    otherEventDates:
                                                        rentDueCalendarEventsRecordList
                                                            .map((e) =>
                                                                e.startDate)
                                                            .withoutNulls
                                                            .toList(),
                                                    events:
                                                        rentDueCalendarEventsRecordList,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          wrapWithModel(
                                            model: _model.recentActivityModel,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: RecentActivityWidget(
                                              propId: widget!.propID!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            if (propertyBackupPropertiesRecord
                                                .gallery.isNotEmpty)
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 20.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        '74u4gjvd' /* MEDIA GALLERY */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .displayLarge
                                                          .override(
                                                            fontFamily:
                                                                'Thunder',
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ),
                                                  Builder(
                                                    builder: (context) {
                                                      final galleryImages =
                                                          propertyBackupPropertiesRecord
                                                              .gallery
                                                              .toList();

                                                      return Container(
                                                        width: double.infinity,
                                                        height: 200.0,
                                                        child: CarouselSlider
                                                            .builder(
                                                          itemCount:
                                                              galleryImages
                                                                  .length,
                                                          itemBuilder: (context,
                                                              galleryImagesIndex,
                                                              _) {
                                                            final galleryImagesItem =
                                                                galleryImages[
                                                                    galleryImagesIndex];
                                                            return Stack(
                                                              children: [
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    await Navigator
                                                                        .push(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .fade,
                                                                        child:
                                                                            FlutterFlowExpandedImageView(
                                                                          image:
                                                                              Image.network(
                                                                            galleryImagesItem,
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                          allowRotation:
                                                                              false,
                                                                          tag:
                                                                              galleryImagesItem,
                                                                          useHeroAnimation:
                                                                              true,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Hero(
                                                                    tag:
                                                                        galleryImagesItem,
                                                                    transitionOnUserGestures:
                                                                        true,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: Image
                                                                          .network(
                                                                        galleryImagesItem,
                                                                        width:
                                                                            200.0,
                                                                        height:
                                                                            200.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (galleryImagesItem !=
                                                                        null &&
                                                                    galleryImagesItem !=
                                                                        '')
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1.0,
                                                                            -1.0),
                                                                    child:
                                                                        FlutterFlowIconButton(
                                                                      borderRadius:
                                                                          8.0,
                                                                      buttonSize:
                                                                          48.0,
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .delete_forever,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            28.0,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        var confirmDialogResponse = await showDialog<bool>(
                                                                              context: context,
                                                                              builder: (alertDialogContext) {
                                                                                return WebViewAware(
                                                                                  child: AlertDialog(
                                                                                    title: Text('Confirm Deletion'),
                                                                                    content: Text('Are you sure you want to delete this image?'),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                        onPressed: () => Navigator.pop(alertDialogContext, false),
                                                                                        child: Text('No'),
                                                                                      ),
                                                                                      TextButton(
                                                                                        onPressed: () => Navigator.pop(alertDialogContext, true),
                                                                                        child: Text('Yes'),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ) ??
                                                                            false;
                                                                        if (confirmDialogResponse) {
                                                                          await widget!
                                                                              .propID!
                                                                              .update({
                                                                            ...mapToFirestore(
                                                                              {
                                                                                'gallery': FieldValue.arrayRemove([
                                                                                  galleryImagesItem
                                                                                ]),
                                                                              },
                                                                            ),
                                                                          });
                                                                        } else {
                                                                          await Future
                                                                              .delayed(
                                                                            Duration(
                                                                              milliseconds: 10,
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                              ],
                                                            );
                                                          },
                                                          carouselController: _model
                                                                  .carouselController ??=
                                                              CarouselSliderController(),
                                                          options:
                                                              CarouselOptions(
                                                            initialPage: max(
                                                                0,
                                                                min(
                                                                    1,
                                                                    galleryImages
                                                                            .length -
                                                                        1)),
                                                            viewportFraction:
                                                                0.5,
                                                            disableCenter: true,
                                                            enlargeCenterPage:
                                                                true,
                                                            enlargeFactor: 0.25,
                                                            enableInfiniteScroll:
                                                                true,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            autoPlay: false,
                                                            onPageChanged: (index,
                                                                    _) =>
                                                                _model.carouselCurrentIndex =
                                                                    index,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 10.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: FFButtonWidget(
                                                      onPressed: () {
                                                        print(
                                                            'Button pressed ...');
                                                      },
                                                      text: FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'ewm064z5' /* Add to Image Gallery */,
                                                      ),
                                                      options: FFButtonOptions(
                                                        height: 40.0,
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .figtree(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              thickness: 2.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            if ((propertyBackupPropertiesRecord
                                                            .energyCert !=
                                                        null &&
                                                    propertyBackupPropertiesRecord
                                                            .energyCert !=
                                                        '') ||
                                                (propertyBackupPropertiesRecord
                                                            .gasCert !=
                                                        null &&
                                                    propertyBackupPropertiesRecord
                                                            .gasCert !=
                                                        '') ||
                                                (propertyBackupPropertiesRecord
                                                            .elecCert !=
                                                        null &&
                                                    propertyBackupPropertiesRecord
                                                            .elecCert !=
                                                        ''))
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 20.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  20.0,
                                                                  0.0,
                                                                  10.0),
                                                      child: Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          'tjvtqrsd' /* CERTIFICATES */,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .displayLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Thunder',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                    if (propertyBackupPropertiesRecord
                                                                .energyCert !=
                                                            null &&
                                                        propertyBackupPropertiesRecord
                                                                .energyCert !=
                                                            '')
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            PdFViewPageWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'pdfUrl':
                                                                  serializeParam(
                                                                propertyBackupPropertiesRecord
                                                                    .energyCert,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'fileName':
                                                                  serializeParam(
                                                                'Energy Performance Certificate',
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .energy_savings_leaf_outlined,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 32.0,
                                                            ),
                                                            Text(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'af7r131k' /* ENERGY PERFORMANCE CERTIFICATE */,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .displaySmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Thunder',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .chevron_right,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 24.0,
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 13.0)),
                                                        ),
                                                      ),
                                                    if (propertyBackupPropertiesRecord
                                                                .gasCert !=
                                                            null &&
                                                        propertyBackupPropertiesRecord
                                                                .gasCert !=
                                                            '')
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            PdFViewPageWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'pdfUrl':
                                                                  serializeParam(
                                                                propertyBackupPropertiesRecord
                                                                    .gasCert,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'fileName':
                                                                  serializeParam(
                                                                'Gas Safety Certificate',
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .gas_meter_outlined,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 32.0,
                                                            ),
                                                            Text(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                '30cuiyu2' /* GAS SAFETY CERTIFICATE */,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .displaySmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Thunder',
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .chevron_right,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 24.0,
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 13.0)),
                                                        ),
                                                      ),
                                                    if (propertyBackupPropertiesRecord
                                                                .elecCert !=
                                                            null &&
                                                        propertyBackupPropertiesRecord
                                                                .elecCert !=
                                                            '')
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            PdFViewPageWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'pdfUrl':
                                                                  serializeParam(
                                                                propertyBackupPropertiesRecord
                                                                    .elecCert,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'fileName':
                                                                  serializeParam(
                                                                'Electrical Installation Report',
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .electric_bolt,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondary,
                                                              size: 32.0,
                                                            ),
                                                            Text(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'son9p8rn' /* ELECTRICAL INSTALATION REPORT */,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .displaySmall
                                                                  .override(
                                                                    fontFamily:
                                                                        'Thunder',
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .chevron_right,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 24.0,
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 13.0)),
                                                        ),
                                                      ),
                                                    Divider(
                                                      thickness: 2.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 12.0)),
                                                ),
                                              ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 20.0, 0.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'm6ropito' /* LOCATION */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .displayLarge
                                                        .override(
                                                          fontFamily: 'Thunder',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 10.0),
                                                    child: Text(
                                                      propertyBackupPropertiesRecord
                                                          .addressFormatted,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .figtree(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 300.0,
                                                  child: Visibility(
                                                    visible:
                                                        propertyBackupPropertiesRecord
                                                                .latLng !=
                                                            null,
                                                    child: Builder(
                                                        builder: (context) {
                                                      final _googleMapMarker =
                                                          propertyBackupPropertiesRecord
                                                              .latLng;
                                                      return FlutterFlowGoogleMap(
                                                        controller: _model
                                                            .googleMapsController,
                                                        onCameraIdle: (latLng) =>
                                                            _model.googleMapsCenter =
                                                                latLng,
                                                        initialLocation: _model
                                                                .googleMapsCenter ??=
                                                            propertyBackupPropertiesRecord
                                                                .latLng!,
                                                        markers: [
                                                          if (_googleMapMarker !=
                                                              null)
                                                            FlutterFlowMarker(
                                                              _googleMapMarker
                                                                  .serialize(),
                                                              _googleMapMarker,
                                                            ),
                                                        ],
                                                        markerColor:
                                                            GoogleMarkerColor
                                                                .violet,
                                                        mapType: MapType.normal,
                                                        style: GoogleMapStyle
                                                            .standard,
                                                        initialZoom: 14.0,
                                                        allowInteraction: true,
                                                        allowZoom: true,
                                                        showZoomControls: true,
                                                        showLocation: true,
                                                        showCompass: false,
                                                        showMapToolbar: false,
                                                        showTraffic: false,
                                                        centerMapOnMarkerTap:
                                                            true,
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                          ].divide(SizedBox(height: 10.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ].addToEnd(SizedBox(height: 56.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
