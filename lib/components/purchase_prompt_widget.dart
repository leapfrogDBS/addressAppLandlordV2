import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'purchase_prompt_model.dart';
export 'purchase_prompt_model.dart';

class PurchasePromptWidget extends StatefulWidget {
  const PurchasePromptWidget({
    super.key,
    this.title,
    this.formattedAddress,
    this.documentId,
  });

  final String? title;
  final String? formattedAddress;
  final DocumentReference? documentId;

  @override
  State<PurchasePromptWidget> createState() => _PurchasePromptWidgetState();
}

class _PurchasePromptWidgetState extends State<PurchasePromptWidget> {
  late PurchasePromptModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PurchasePromptModel());

    _model.propertyTitleTextController ??= TextEditingController();
    _model.propertyTitleFocusNode ??= FocusNode();

    _model.purchasePriceTextController ??= TextEditingController();
    _model.purchasePriceFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              FaIcon(
                FontAwesomeIcons.fileContract,
                color: FlutterFlowTheme.of(context).tertiary,
                size: 32.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 300.0,
                    decoration: BoxDecoration(),
                    child: Text(
                      valueOrDefault<String>(
                        widget!.formattedAddress,
                        'Formatted Address',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.figtree(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ],
              ),
            ].divide(SizedBox(width: 10.0)),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 10.0),
            child: TextFormField(
              controller: _model.propertyTitleTextController,
              focusNode: _model.propertyTitleFocusNode,
              onChanged: (_) => EasyDebounce.debounce(
                '_model.propertyTitleTextController',
                Duration(milliseconds: 2000),
                () async {
                  await widget!.documentId!.update(createPropertiesRecordData(
                    title: _model.propertyTitleTextController.text,
                  ));
                },
              ),
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.figtree(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: FFLocalizations.of(context).getText(
                  'k68ct9cw' /* Enter Optional Title for Prope... */,
                ),
                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.figtree(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.figtree(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
              cursorColor: FlutterFlowTheme.of(context).primaryText,
              validator: _model.propertyTitleTextControllerValidator
                  .asValidator(context),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 10.0),
            child: TextFormField(
              controller: _model.purchasePriceTextController,
              focusNode: _model.purchasePriceFocusNode,
              onChanged: (_) => EasyDebounce.debounce(
                '_model.purchasePriceTextController',
                Duration(milliseconds: 2000),
                () async {
                  await widget!.documentId!.update(createPropertiesRecordData(
                    purchasePrice: double.tryParse(
                        _model.purchasePriceTextController.text),
                  ));
                },
              ),
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.figtree(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                hintText: FFLocalizations.of(context).getText(
                  '7el1rv3m' /* Enter Purchase Price */,
                ),
                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.figtree(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.figtree(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
              keyboardType: TextInputType.number,
              cursorColor: FlutterFlowTheme.of(context).primaryText,
              validator: _model.purchasePriceTextControllerValidator
                  .asValidator(context),
            ),
          ),
          Divider(
            thickness: 2.0,
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ],
      ),
    );
  }
}
