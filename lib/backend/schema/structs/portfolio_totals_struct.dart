// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PortfolioTotalsStruct extends FFFirebaseStruct {
  PortfolioTotalsStruct({
    double? annualRent,
    double? capitalValue,
    double? combinedDailyGain,
    double? cumulativeRentalProfit,
    int? retirementYear,
    double? liveGainPerDay,
    double? liveGainPerSecond,
    double? liveGainThisYear,
    double? liveEarningsAsOfNow,
    int? currentYearIndex,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _annualRent = annualRent,
        _capitalValue = capitalValue,
        _combinedDailyGain = combinedDailyGain,
        _cumulativeRentalProfit = cumulativeRentalProfit,
        _retirementYear = retirementYear,
        _liveGainPerDay = liveGainPerDay,
        _liveGainPerSecond = liveGainPerSecond,
        _liveGainThisYear = liveGainThisYear,
        _liveEarningsAsOfNow = liveEarningsAsOfNow,
        _currentYearIndex = currentYearIndex,
        super(firestoreUtilData);

  // "annualRent" field.
  double? _annualRent;
  double get annualRent => _annualRent ?? 0.0;
  set annualRent(double? val) => _annualRent = val;

  void incrementAnnualRent(double amount) => annualRent = annualRent + amount;

  bool hasAnnualRent() => _annualRent != null;

  // "capitalValue" field.
  double? _capitalValue;
  double get capitalValue => _capitalValue ?? 0.0;
  set capitalValue(double? val) => _capitalValue = val;

  void incrementCapitalValue(double amount) =>
      capitalValue = capitalValue + amount;

  bool hasCapitalValue() => _capitalValue != null;

  // "combinedDailyGain" field.
  double? _combinedDailyGain;
  double get combinedDailyGain => _combinedDailyGain ?? 0.0;
  set combinedDailyGain(double? val) => _combinedDailyGain = val;

  void incrementCombinedDailyGain(double amount) =>
      combinedDailyGain = combinedDailyGain + amount;

  bool hasCombinedDailyGain() => _combinedDailyGain != null;

  // "cumulativeRentalProfit" field.
  double? _cumulativeRentalProfit;
  double get cumulativeRentalProfit => _cumulativeRentalProfit ?? 0.0;
  set cumulativeRentalProfit(double? val) => _cumulativeRentalProfit = val;

  void incrementCumulativeRentalProfit(double amount) =>
      cumulativeRentalProfit = cumulativeRentalProfit + amount;

  bool hasCumulativeRentalProfit() => _cumulativeRentalProfit != null;

  // "retirementYear" field.
  int? _retirementYear;
  int get retirementYear => _retirementYear ?? 0;
  set retirementYear(int? val) => _retirementYear = val;

  void incrementRetirementYear(int amount) =>
      retirementYear = retirementYear + amount;

  bool hasRetirementYear() => _retirementYear != null;

  // "liveGainPerDay" field.
  double? _liveGainPerDay;
  double get liveGainPerDay => _liveGainPerDay ?? 0.0;
  set liveGainPerDay(double? val) => _liveGainPerDay = val;

  void incrementLiveGainPerDay(double amount) =>
      liveGainPerDay = liveGainPerDay + amount;

  bool hasLiveGainPerDay() => _liveGainPerDay != null;

  // "liveGainPerSecond" field.
  double? _liveGainPerSecond;
  double get liveGainPerSecond => _liveGainPerSecond ?? 0.0;
  set liveGainPerSecond(double? val) => _liveGainPerSecond = val;

  void incrementLiveGainPerSecond(double amount) =>
      liveGainPerSecond = liveGainPerSecond + amount;

  bool hasLiveGainPerSecond() => _liveGainPerSecond != null;

  // "liveGainThisYear" field.
  double? _liveGainThisYear;
  double get liveGainThisYear => _liveGainThisYear ?? 0.0;
  set liveGainThisYear(double? val) => _liveGainThisYear = val;

  void incrementLiveGainThisYear(double amount) =>
      liveGainThisYear = liveGainThisYear + amount;

  bool hasLiveGainThisYear() => _liveGainThisYear != null;

  // "liveEarningsAsOfNow" field.
  double? _liveEarningsAsOfNow;
  double get liveEarningsAsOfNow => _liveEarningsAsOfNow ?? 0.0;
  set liveEarningsAsOfNow(double? val) => _liveEarningsAsOfNow = val;

  void incrementLiveEarningsAsOfNow(double amount) =>
      liveEarningsAsOfNow = liveEarningsAsOfNow + amount;

  bool hasLiveEarningsAsOfNow() => _liveEarningsAsOfNow != null;

  // "currentYearIndex" field.
  int? _currentYearIndex;
  int get currentYearIndex => _currentYearIndex ?? 0;
  set currentYearIndex(int? val) => _currentYearIndex = val;

  void incrementCurrentYearIndex(int amount) =>
      currentYearIndex = currentYearIndex + amount;

  bool hasCurrentYearIndex() => _currentYearIndex != null;

  static PortfolioTotalsStruct fromMap(Map<String, dynamic> data) =>
      PortfolioTotalsStruct(
        annualRent: castToType<double>(data['annualRent']),
        capitalValue: castToType<double>(data['capitalValue']),
        combinedDailyGain: castToType<double>(data['combinedDailyGain']),
        cumulativeRentalProfit:
            castToType<double>(data['cumulativeRentalProfit']),
        retirementYear: castToType<int>(data['retirementYear']),
        liveGainPerDay: castToType<double>(data['liveGainPerDay']),
        liveGainPerSecond: castToType<double>(data['liveGainPerSecond']),
        liveGainThisYear: castToType<double>(data['liveGainThisYear']),
        liveEarningsAsOfNow: castToType<double>(data['liveEarningsAsOfNow']),
        currentYearIndex: castToType<int>(data['currentYearIndex']),
      );

  static PortfolioTotalsStruct? maybeFromMap(dynamic data) => data is Map
      ? PortfolioTotalsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'annualRent': _annualRent,
        'capitalValue': _capitalValue,
        'combinedDailyGain': _combinedDailyGain,
        'cumulativeRentalProfit': _cumulativeRentalProfit,
        'retirementYear': _retirementYear,
        'liveGainPerDay': _liveGainPerDay,
        'liveGainPerSecond': _liveGainPerSecond,
        'liveGainThisYear': _liveGainThisYear,
        'liveEarningsAsOfNow': _liveEarningsAsOfNow,
        'currentYearIndex': _currentYearIndex,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'annualRent': serializeParam(
          _annualRent,
          ParamType.double,
        ),
        'capitalValue': serializeParam(
          _capitalValue,
          ParamType.double,
        ),
        'combinedDailyGain': serializeParam(
          _combinedDailyGain,
          ParamType.double,
        ),
        'cumulativeRentalProfit': serializeParam(
          _cumulativeRentalProfit,
          ParamType.double,
        ),
        'retirementYear': serializeParam(
          _retirementYear,
          ParamType.int,
        ),
        'liveGainPerDay': serializeParam(
          _liveGainPerDay,
          ParamType.double,
        ),
        'liveGainPerSecond': serializeParam(
          _liveGainPerSecond,
          ParamType.double,
        ),
        'liveGainThisYear': serializeParam(
          _liveGainThisYear,
          ParamType.double,
        ),
        'liveEarningsAsOfNow': serializeParam(
          _liveEarningsAsOfNow,
          ParamType.double,
        ),
        'currentYearIndex': serializeParam(
          _currentYearIndex,
          ParamType.int,
        ),
      }.withoutNulls;

  static PortfolioTotalsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PortfolioTotalsStruct(
        annualRent: deserializeParam(
          data['annualRent'],
          ParamType.double,
          false,
        ),
        capitalValue: deserializeParam(
          data['capitalValue'],
          ParamType.double,
          false,
        ),
        combinedDailyGain: deserializeParam(
          data['combinedDailyGain'],
          ParamType.double,
          false,
        ),
        cumulativeRentalProfit: deserializeParam(
          data['cumulativeRentalProfit'],
          ParamType.double,
          false,
        ),
        retirementYear: deserializeParam(
          data['retirementYear'],
          ParamType.int,
          false,
        ),
        liveGainPerDay: deserializeParam(
          data['liveGainPerDay'],
          ParamType.double,
          false,
        ),
        liveGainPerSecond: deserializeParam(
          data['liveGainPerSecond'],
          ParamType.double,
          false,
        ),
        liveGainThisYear: deserializeParam(
          data['liveGainThisYear'],
          ParamType.double,
          false,
        ),
        liveEarningsAsOfNow: deserializeParam(
          data['liveEarningsAsOfNow'],
          ParamType.double,
          false,
        ),
        currentYearIndex: deserializeParam(
          data['currentYearIndex'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PortfolioTotalsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PortfolioTotalsStruct &&
        annualRent == other.annualRent &&
        capitalValue == other.capitalValue &&
        combinedDailyGain == other.combinedDailyGain &&
        cumulativeRentalProfit == other.cumulativeRentalProfit &&
        retirementYear == other.retirementYear &&
        liveGainPerDay == other.liveGainPerDay &&
        liveGainPerSecond == other.liveGainPerSecond &&
        liveGainThisYear == other.liveGainThisYear &&
        liveEarningsAsOfNow == other.liveEarningsAsOfNow &&
        currentYearIndex == other.currentYearIndex;
  }

  @override
  int get hashCode => const ListEquality().hash([
        annualRent,
        capitalValue,
        combinedDailyGain,
        cumulativeRentalProfit,
        retirementYear,
        liveGainPerDay,
        liveGainPerSecond,
        liveGainThisYear,
        liveEarningsAsOfNow,
        currentYearIndex
      ]);
}

PortfolioTotalsStruct createPortfolioTotalsStruct({
  double? annualRent,
  double? capitalValue,
  double? combinedDailyGain,
  double? cumulativeRentalProfit,
  int? retirementYear,
  double? liveGainPerDay,
  double? liveGainPerSecond,
  double? liveGainThisYear,
  double? liveEarningsAsOfNow,
  int? currentYearIndex,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PortfolioTotalsStruct(
      annualRent: annualRent,
      capitalValue: capitalValue,
      combinedDailyGain: combinedDailyGain,
      cumulativeRentalProfit: cumulativeRentalProfit,
      retirementYear: retirementYear,
      liveGainPerDay: liveGainPerDay,
      liveGainPerSecond: liveGainPerSecond,
      liveGainThisYear: liveGainThisYear,
      liveEarningsAsOfNow: liveEarningsAsOfNow,
      currentYearIndex: currentYearIndex,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PortfolioTotalsStruct? updatePortfolioTotalsStruct(
  PortfolioTotalsStruct? portfolioTotals, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    portfolioTotals
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPortfolioTotalsStructData(
  Map<String, dynamic> firestoreData,
  PortfolioTotalsStruct? portfolioTotals,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (portfolioTotals == null) {
    return;
  }
  if (portfolioTotals.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && portfolioTotals.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final portfolioTotalsData =
      getPortfolioTotalsFirestoreData(portfolioTotals, forFieldValue);
  final nestedData =
      portfolioTotalsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = portfolioTotals.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPortfolioTotalsFirestoreData(
  PortfolioTotalsStruct? portfolioTotals, [
  bool forFieldValue = false,
]) {
  if (portfolioTotals == null) {
    return {};
  }
  final firestoreData = mapToFirestore(portfolioTotals.toMap());

  // Add any Firestore field values
  mapToFirestore(portfolioTotals.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPortfolioTotalsListFirestoreData(
  List<PortfolioTotalsStruct>? portfolioTotalss,
) =>
    portfolioTotalss
        ?.map((e) => getPortfolioTotalsFirestoreData(e, true))
        .toList() ??
    [];
