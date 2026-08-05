// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PortfolioSnapshotStruct extends FFFirebaseStruct {
  PortfolioSnapshotStruct({
    int? propertyCount,
    double? totalValue,
    double? totalEquity,
    double? annualRent,
    double? avgYield,
    double? capitalGainSinceJoining,
    double? avgMonthlyRent,
    int? mortgageEnteredCount,
    int? purchasePriceEnteredCount,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _propertyCount = propertyCount,
        _totalValue = totalValue,
        _totalEquity = totalEquity,
        _annualRent = annualRent,
        _avgYield = avgYield,
        _capitalGainSinceJoining = capitalGainSinceJoining,
        _avgMonthlyRent = avgMonthlyRent,
        _mortgageEnteredCount = mortgageEnteredCount,
        _purchasePriceEnteredCount = purchasePriceEnteredCount,
        super(firestoreUtilData);

  // "propertyCount" field.
  int? _propertyCount;
  int get propertyCount => _propertyCount ?? 0;
  set propertyCount(int? val) => _propertyCount = val;

  void incrementPropertyCount(int amount) =>
      propertyCount = propertyCount + amount;

  bool hasPropertyCount() => _propertyCount != null;

  // "totalValue" field.
  double? _totalValue;
  double get totalValue => _totalValue ?? 0.0;
  set totalValue(double? val) => _totalValue = val;

  void incrementTotalValue(double amount) => totalValue = totalValue + amount;

  bool hasTotalValue() => _totalValue != null;

  // "totalEquity" field.
  double? _totalEquity;
  double get totalEquity => _totalEquity ?? 0.0;
  set totalEquity(double? val) => _totalEquity = val;

  void incrementTotalEquity(double amount) =>
      totalEquity = totalEquity + amount;

  bool hasTotalEquity() => _totalEquity != null;

  // "annualRent" field.
  double? _annualRent;
  double get annualRent => _annualRent ?? 0.0;
  set annualRent(double? val) => _annualRent = val;

  void incrementAnnualRent(double amount) => annualRent = annualRent + amount;

  bool hasAnnualRent() => _annualRent != null;

  // "avgYield" field.
  double? _avgYield;
  double get avgYield => _avgYield ?? 0.0;
  set avgYield(double? val) => _avgYield = val;

  void incrementAvgYield(double amount) => avgYield = avgYield + amount;

  bool hasAvgYield() => _avgYield != null;

  // "capitalGainSinceJoining" field.
  double? _capitalGainSinceJoining;
  double get capitalGainSinceJoining => _capitalGainSinceJoining ?? 0.0;
  set capitalGainSinceJoining(double? val) => _capitalGainSinceJoining = val;

  void incrementCapitalGainSinceJoining(double amount) =>
      capitalGainSinceJoining = capitalGainSinceJoining + amount;

  bool hasCapitalGainSinceJoining() => _capitalGainSinceJoining != null;

  // "avgMonthlyRent" field.
  double? _avgMonthlyRent;
  double get avgMonthlyRent => _avgMonthlyRent ?? 0.0;
  set avgMonthlyRent(double? val) => _avgMonthlyRent = val;

  void incrementAvgMonthlyRent(double amount) =>
      avgMonthlyRent = avgMonthlyRent + amount;

  bool hasAvgMonthlyRent() => _avgMonthlyRent != null;

  // "mortgageEnteredCount" field.
  int? _mortgageEnteredCount;
  int get mortgageEnteredCount => _mortgageEnteredCount ?? 0;
  set mortgageEnteredCount(int? val) => _mortgageEnteredCount = val;

  void incrementMortgageEnteredCount(int amount) =>
      mortgageEnteredCount = mortgageEnteredCount + amount;

  bool hasMortgageEnteredCount() => _mortgageEnteredCount != null;

  // "purchasePriceEnteredCount" field.
  int? _purchasePriceEnteredCount;
  int get purchasePriceEnteredCount => _purchasePriceEnteredCount ?? 0;
  set purchasePriceEnteredCount(int? val) => _purchasePriceEnteredCount = val;

  void incrementPurchasePriceEnteredCount(int amount) =>
      purchasePriceEnteredCount = purchasePriceEnteredCount + amount;

  bool hasPurchasePriceEnteredCount() => _purchasePriceEnteredCount != null;

  static PortfolioSnapshotStruct fromMap(Map<String, dynamic> data) =>
      PortfolioSnapshotStruct(
        propertyCount: castToType<int>(data['propertyCount']),
        totalValue: castToType<double>(data['totalValue']),
        totalEquity: castToType<double>(data['totalEquity']),
        annualRent: castToType<double>(data['annualRent']),
        avgYield: castToType<double>(data['avgYield']),
        capitalGainSinceJoining:
            castToType<double>(data['capitalGainSinceJoining']),
        avgMonthlyRent: castToType<double>(data['avgMonthlyRent']),
        mortgageEnteredCount: castToType<int>(data['mortgageEnteredCount']),
        purchasePriceEnteredCount:
            castToType<int>(data['purchasePriceEnteredCount']),
      );

  static PortfolioSnapshotStruct? maybeFromMap(dynamic data) => data is Map
      ? PortfolioSnapshotStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'propertyCount': _propertyCount,
        'totalValue': _totalValue,
        'totalEquity': _totalEquity,
        'annualRent': _annualRent,
        'avgYield': _avgYield,
        'capitalGainSinceJoining': _capitalGainSinceJoining,
        'avgMonthlyRent': _avgMonthlyRent,
        'mortgageEnteredCount': _mortgageEnteredCount,
        'purchasePriceEnteredCount': _purchasePriceEnteredCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'propertyCount': serializeParam(
          _propertyCount,
          ParamType.int,
        ),
        'totalValue': serializeParam(
          _totalValue,
          ParamType.double,
        ),
        'totalEquity': serializeParam(
          _totalEquity,
          ParamType.double,
        ),
        'annualRent': serializeParam(
          _annualRent,
          ParamType.double,
        ),
        'avgYield': serializeParam(
          _avgYield,
          ParamType.double,
        ),
        'capitalGainSinceJoining': serializeParam(
          _capitalGainSinceJoining,
          ParamType.double,
        ),
        'avgMonthlyRent': serializeParam(
          _avgMonthlyRent,
          ParamType.double,
        ),
        'mortgageEnteredCount': serializeParam(
          _mortgageEnteredCount,
          ParamType.int,
        ),
        'purchasePriceEnteredCount': serializeParam(
          _purchasePriceEnteredCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static PortfolioSnapshotStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PortfolioSnapshotStruct(
        propertyCount: deserializeParam(
          data['propertyCount'],
          ParamType.int,
          false,
        ),
        totalValue: deserializeParam(
          data['totalValue'],
          ParamType.double,
          false,
        ),
        totalEquity: deserializeParam(
          data['totalEquity'],
          ParamType.double,
          false,
        ),
        annualRent: deserializeParam(
          data['annualRent'],
          ParamType.double,
          false,
        ),
        avgYield: deserializeParam(
          data['avgYield'],
          ParamType.double,
          false,
        ),
        capitalGainSinceJoining: deserializeParam(
          data['capitalGainSinceJoining'],
          ParamType.double,
          false,
        ),
        avgMonthlyRent: deserializeParam(
          data['avgMonthlyRent'],
          ParamType.double,
          false,
        ),
        mortgageEnteredCount: deserializeParam(
          data['mortgageEnteredCount'],
          ParamType.int,
          false,
        ),
        purchasePriceEnteredCount: deserializeParam(
          data['purchasePriceEnteredCount'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PortfolioSnapshotStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PortfolioSnapshotStruct &&
        propertyCount == other.propertyCount &&
        totalValue == other.totalValue &&
        totalEquity == other.totalEquity &&
        annualRent == other.annualRent &&
        avgYield == other.avgYield &&
        capitalGainSinceJoining == other.capitalGainSinceJoining &&
        avgMonthlyRent == other.avgMonthlyRent &&
        mortgageEnteredCount == other.mortgageEnteredCount &&
        purchasePriceEnteredCount == other.purchasePriceEnteredCount;
  }

  @override
  int get hashCode => const ListEquality().hash([
        propertyCount,
        totalValue,
        totalEquity,
        annualRent,
        avgYield,
        capitalGainSinceJoining,
        avgMonthlyRent,
        mortgageEnteredCount,
        purchasePriceEnteredCount
      ]);
}

PortfolioSnapshotStruct createPortfolioSnapshotStruct({
  int? propertyCount,
  double? totalValue,
  double? totalEquity,
  double? annualRent,
  double? avgYield,
  double? capitalGainSinceJoining,
  double? avgMonthlyRent,
  int? mortgageEnteredCount,
  int? purchasePriceEnteredCount,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PortfolioSnapshotStruct(
      propertyCount: propertyCount,
      totalValue: totalValue,
      totalEquity: totalEquity,
      annualRent: annualRent,
      avgYield: avgYield,
      capitalGainSinceJoining: capitalGainSinceJoining,
      avgMonthlyRent: avgMonthlyRent,
      mortgageEnteredCount: mortgageEnteredCount,
      purchasePriceEnteredCount: purchasePriceEnteredCount,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PortfolioSnapshotStruct? updatePortfolioSnapshotStruct(
  PortfolioSnapshotStruct? portfolioSnapshot, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    portfolioSnapshot
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPortfolioSnapshotStructData(
  Map<String, dynamic> firestoreData,
  PortfolioSnapshotStruct? portfolioSnapshot,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (portfolioSnapshot == null) {
    return;
  }
  if (portfolioSnapshot.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && portfolioSnapshot.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final portfolioSnapshotData =
      getPortfolioSnapshotFirestoreData(portfolioSnapshot, forFieldValue);
  final nestedData =
      portfolioSnapshotData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = portfolioSnapshot.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPortfolioSnapshotFirestoreData(
  PortfolioSnapshotStruct? portfolioSnapshot, [
  bool forFieldValue = false,
]) {
  if (portfolioSnapshot == null) {
    return {};
  }
  final firestoreData = mapToFirestore(portfolioSnapshot.toMap());

  // Add any Firestore field values
  mapToFirestore(portfolioSnapshot.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPortfolioSnapshotListFirestoreData(
  List<PortfolioSnapshotStruct>? portfolioSnapshots,
) =>
    portfolioSnapshots
        ?.map((e) => getPortfolioSnapshotFirestoreData(e, true))
        .toList() ??
    [];
