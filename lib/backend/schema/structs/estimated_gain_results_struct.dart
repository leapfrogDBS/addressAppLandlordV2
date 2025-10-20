// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EstimatedGainResultsStruct extends FFFirebaseStruct {
  EstimatedGainResultsStruct({
    double? earningsAsOfNow,
    double? gainPerDay,
    double? gainPerSecond,
    double? gainThisYear,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _earningsAsOfNow = earningsAsOfNow,
        _gainPerDay = gainPerDay,
        _gainPerSecond = gainPerSecond,
        _gainThisYear = gainThisYear,
        super(firestoreUtilData);

  // "earningsAsOfNow" field.
  double? _earningsAsOfNow;
  double get earningsAsOfNow => _earningsAsOfNow ?? 0.0;
  set earningsAsOfNow(double? val) => _earningsAsOfNow = val;

  void incrementEarningsAsOfNow(double amount) =>
      earningsAsOfNow = earningsAsOfNow + amount;

  bool hasEarningsAsOfNow() => _earningsAsOfNow != null;

  // "gainPerDay" field.
  double? _gainPerDay;
  double get gainPerDay => _gainPerDay ?? 0.0;
  set gainPerDay(double? val) => _gainPerDay = val;

  void incrementGainPerDay(double amount) => gainPerDay = gainPerDay + amount;

  bool hasGainPerDay() => _gainPerDay != null;

  // "gainPerSecond" field.
  double? _gainPerSecond;
  double get gainPerSecond => _gainPerSecond ?? 0.0;
  set gainPerSecond(double? val) => _gainPerSecond = val;

  void incrementGainPerSecond(double amount) =>
      gainPerSecond = gainPerSecond + amount;

  bool hasGainPerSecond() => _gainPerSecond != null;

  // "gainThisYear" field.
  double? _gainThisYear;
  double get gainThisYear => _gainThisYear ?? 0.0;
  set gainThisYear(double? val) => _gainThisYear = val;

  void incrementGainThisYear(double amount) =>
      gainThisYear = gainThisYear + amount;

  bool hasGainThisYear() => _gainThisYear != null;

  static EstimatedGainResultsStruct fromMap(Map<String, dynamic> data) =>
      EstimatedGainResultsStruct(
        earningsAsOfNow: castToType<double>(data['earningsAsOfNow']),
        gainPerDay: castToType<double>(data['gainPerDay']),
        gainPerSecond: castToType<double>(data['gainPerSecond']),
        gainThisYear: castToType<double>(data['gainThisYear']),
      );

  static EstimatedGainResultsStruct? maybeFromMap(dynamic data) => data is Map
      ? EstimatedGainResultsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'earningsAsOfNow': _earningsAsOfNow,
        'gainPerDay': _gainPerDay,
        'gainPerSecond': _gainPerSecond,
        'gainThisYear': _gainThisYear,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'earningsAsOfNow': serializeParam(
          _earningsAsOfNow,
          ParamType.double,
        ),
        'gainPerDay': serializeParam(
          _gainPerDay,
          ParamType.double,
        ),
        'gainPerSecond': serializeParam(
          _gainPerSecond,
          ParamType.double,
        ),
        'gainThisYear': serializeParam(
          _gainThisYear,
          ParamType.double,
        ),
      }.withoutNulls;

  static EstimatedGainResultsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      EstimatedGainResultsStruct(
        earningsAsOfNow: deserializeParam(
          data['earningsAsOfNow'],
          ParamType.double,
          false,
        ),
        gainPerDay: deserializeParam(
          data['gainPerDay'],
          ParamType.double,
          false,
        ),
        gainPerSecond: deserializeParam(
          data['gainPerSecond'],
          ParamType.double,
          false,
        ),
        gainThisYear: deserializeParam(
          data['gainThisYear'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'EstimatedGainResultsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EstimatedGainResultsStruct &&
        earningsAsOfNow == other.earningsAsOfNow &&
        gainPerDay == other.gainPerDay &&
        gainPerSecond == other.gainPerSecond &&
        gainThisYear == other.gainThisYear;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([earningsAsOfNow, gainPerDay, gainPerSecond, gainThisYear]);
}

EstimatedGainResultsStruct createEstimatedGainResultsStruct({
  double? earningsAsOfNow,
  double? gainPerDay,
  double? gainPerSecond,
  double? gainThisYear,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EstimatedGainResultsStruct(
      earningsAsOfNow: earningsAsOfNow,
      gainPerDay: gainPerDay,
      gainPerSecond: gainPerSecond,
      gainThisYear: gainThisYear,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EstimatedGainResultsStruct? updateEstimatedGainResultsStruct(
  EstimatedGainResultsStruct? estimatedGainResults, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    estimatedGainResults
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEstimatedGainResultsStructData(
  Map<String, dynamic> firestoreData,
  EstimatedGainResultsStruct? estimatedGainResults,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (estimatedGainResults == null) {
    return;
  }
  if (estimatedGainResults.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && estimatedGainResults.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final estimatedGainResultsData =
      getEstimatedGainResultsFirestoreData(estimatedGainResults, forFieldValue);
  final nestedData =
      estimatedGainResultsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      estimatedGainResults.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEstimatedGainResultsFirestoreData(
  EstimatedGainResultsStruct? estimatedGainResults, [
  bool forFieldValue = false,
]) {
  if (estimatedGainResults == null) {
    return {};
  }
  final firestoreData = mapToFirestore(estimatedGainResults.toMap());

  // Add any Firestore field values
  estimatedGainResults.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEstimatedGainResultsListFirestoreData(
  List<EstimatedGainResultsStruct>? estimatedGainResultss,
) =>
    estimatedGainResultss
        ?.map((e) => getEstimatedGainResultsFirestoreData(e, true))
        .toList() ??
    [];
