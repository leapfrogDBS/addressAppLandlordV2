// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CardStatsStruct extends FFFirebaseStruct {
  CardStatsStruct({
    double? gain,
    double? roi,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _gain = gain,
        _roi = roi,
        super(firestoreUtilData);

  // "gain" field.
  double? _gain;
  double get gain => _gain ?? 0.0;
  set gain(double? val) => _gain = val;

  void incrementGain(double amount) => gain = gain + amount;

  bool hasGain() => _gain != null;

  // "roi" field.
  double? _roi;
  double get roi => _roi ?? 0.0;
  set roi(double? val) => _roi = val;

  void incrementRoi(double amount) => roi = roi + amount;

  bool hasRoi() => _roi != null;

  static CardStatsStruct fromMap(Map<String, dynamic> data) => CardStatsStruct(
        gain: castToType<double>(data['gain']),
        roi: castToType<double>(data['roi']),
      );

  static CardStatsStruct? maybeFromMap(dynamic data) => data is Map
      ? CardStatsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'gain': _gain,
        'roi': _roi,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'gain': serializeParam(
          _gain,
          ParamType.double,
        ),
        'roi': serializeParam(
          _roi,
          ParamType.double,
        ),
      }.withoutNulls;

  static CardStatsStruct fromSerializableMap(Map<String, dynamic> data) =>
      CardStatsStruct(
        gain: deserializeParam(
          data['gain'],
          ParamType.double,
          false,
        ),
        roi: deserializeParam(
          data['roi'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'CardStatsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CardStatsStruct && gain == other.gain && roi == other.roi;
  }

  @override
  int get hashCode => const ListEquality().hash([gain, roi]);
}

CardStatsStruct createCardStatsStruct({
  double? gain,
  double? roi,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CardStatsStruct(
      gain: gain,
      roi: roi,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CardStatsStruct? updateCardStatsStruct(
  CardStatsStruct? cardStats, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    cardStats
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCardStatsStructData(
  Map<String, dynamic> firestoreData,
  CardStatsStruct? cardStats,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (cardStats == null) {
    return;
  }
  if (cardStats.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && cardStats.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final cardStatsData = getCardStatsFirestoreData(cardStats, forFieldValue);
  final nestedData = cardStatsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = cardStats.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCardStatsFirestoreData(
  CardStatsStruct? cardStats, [
  bool forFieldValue = false,
]) {
  if (cardStats == null) {
    return {};
  }
  final firestoreData = mapToFirestore(cardStats.toMap());

  // Add any Firestore field values
  cardStats.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCardStatsListFirestoreData(
  List<CardStatsStruct>? cardStatss,
) =>
    cardStatss?.map((e) => getCardStatsFirestoreData(e, true)).toList() ?? [];
