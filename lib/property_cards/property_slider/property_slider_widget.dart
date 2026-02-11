import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/property_cards/single_property/single_property_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'property_slider_model.dart';
export 'property_slider_model.dart';

class PropertySliderWidget extends StatefulWidget {
  const PropertySliderWidget({super.key});

  @override
  State<PropertySliderWidget> createState() => _PropertySliderWidgetState();
}

class _PropertySliderWidgetState extends State<PropertySliderWidget> {
  late PropertySliderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PropertySliderModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
      child: Container(
        width: double.infinity,
        height: 370.0,
        decoration: BoxDecoration(),
        child: StreamBuilder<List<PropertiesRecord>>(
          stream: queryPropertiesRecord(
            queryBuilder: (propertiesRecord) => propertiesRecord.where(
              'ownerID',
              isEqualTo: currentUserReference?.id,
            ),
          ),
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
            List<PropertiesRecord> listViewPropertiesRecordList =
                snapshot.data!;

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: listViewPropertiesRecordList.length,
              separatorBuilder: (_, __) => SizedBox(width: 16.0),
              itemBuilder: (context, listViewIndex) {
                final listViewPropertiesRecord =
                    listViewPropertiesRecordList[listViewIndex];
                return Container(
                  width: 260.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: wrapWithModel(
                    model: _model.singlePropertyModels.getModel(
                      listViewPropertiesRecord.reference.id,
                      listViewIndex,
                    ),
                    updateCallback: () => safeSetState(() {}),
                    child: SinglePropertyWidget(
                      key: Key(
                        'Key9sa_${listViewPropertiesRecord.reference.id}',
                      ),
                      propImg: listViewPropertiesRecord.mainPhoto,
                      propTitle: listViewPropertiesRecord.title,
                      propValue: listViewPropertiesRecord.estimatedValue,
                      propID: listViewPropertiesRecord.reference,
                      propFormattedAddress:
                          listViewPropertiesRecord.addressFormatted,
                      propLetType: listViewPropertiesRecord.letType,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
