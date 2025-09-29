// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EstimatedGainResultsStruct extends FFFirebaseStruct {
  EstimatedGainResultsStruct({
    double? totalGain,
    double? gainPerDay,
    double? gainPerSecond,
    double? capitalGain,
    double? rentalProfit,
    double? totalExpenses,
    double? roi,
    double? earningsToDate,
    double? totalInvestment,
    double? totalAnnualRent,
    double? rentalYield,
    double? annualIncreasePercentage,
    double? dailyCapitalGain,
    double? allTimeCapitalAppreciation,
    double? allTimeRentalIncome,
    double? allTimeExpenses,
    double? allTimeNetProfit,
    double? allTimeROI,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _totalGain = totalGain,
        _gainPerDay = gainPerDay,
        _gainPerSecond = gainPerSecond,
        _capitalGain = capitalGain,
        _rentalProfit = rentalProfit,
        _totalExpenses = totalExpenses,
        _roi = roi,
        _earningsToDate = earningsToDate,
        _totalInvestment = totalInvestment,
        _totalAnnualRent = totalAnnualRent,
        _rentalYield = rentalYield,
        _annualIncreasePercentage = annualIncreasePercentage,
        _dailyCapitalGain = dailyCapitalGain,
        _allTimeCapitalAppreciation = allTimeCapitalAppreciation,
        _allTimeRentalIncome = allTimeRentalIncome,
        _allTimeExpenses = allTimeExpenses,
        _allTimeNetProfit = allTimeNetProfit,
        _allTimeROI = allTimeROI,
        super(firestoreUtilData);

  // "totalGain" field.
  double? _totalGain;
  double get totalGain => _totalGain ?? 0.0;
  set totalGain(double? val) => _totalGain = val;

  void incrementTotalGain(double amount) => totalGain = totalGain + amount;

  bool hasTotalGain() => _totalGain != null;

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

  // "capitalGain" field.
  double? _capitalGain;
  double get capitalGain => _capitalGain ?? 0.0;
  set capitalGain(double? val) => _capitalGain = val;

  void incrementCapitalGain(double amount) =>
      capitalGain = capitalGain + amount;

  bool hasCapitalGain() => _capitalGain != null;

  // "rentalProfit" field.
  double? _rentalProfit;
  double get rentalProfit => _rentalProfit ?? 0.0;
  set rentalProfit(double? val) => _rentalProfit = val;

  void incrementRentalProfit(double amount) =>
      rentalProfit = rentalProfit + amount;

  bool hasRentalProfit() => _rentalProfit != null;

  // "totalExpenses" field.
  double? _totalExpenses;
  double get totalExpenses => _totalExpenses ?? 0.0;
  set totalExpenses(double? val) => _totalExpenses = val;

  void incrementTotalExpenses(double amount) =>
      totalExpenses = totalExpenses + amount;

  bool hasTotalExpenses() => _totalExpenses != null;

  // "roi" field.
  double? _roi;
  double get roi => _roi ?? 0.0;
  set roi(double? val) => _roi = val;

  void incrementRoi(double amount) => roi = roi + amount;

  bool hasRoi() => _roi != null;

  // "earningsToDate" field.
  double? _earningsToDate;
  double get earningsToDate => _earningsToDate ?? 0.0;
  set earningsToDate(double? val) => _earningsToDate = val;

  void incrementEarningsToDate(double amount) =>
      earningsToDate = earningsToDate + amount;

  bool hasEarningsToDate() => _earningsToDate != null;

  // "totalInvestment" field.
  double? _totalInvestment;
  double get totalInvestment => _totalInvestment ?? 0.0;
  set totalInvestment(double? val) => _totalInvestment = val;

  void incrementTotalInvestment(double amount) =>
      totalInvestment = totalInvestment + amount;

  bool hasTotalInvestment() => _totalInvestment != null;

  // "totalAnnualRent" field.
  double? _totalAnnualRent;
  double get totalAnnualRent => _totalAnnualRent ?? 0.0;
  set totalAnnualRent(double? val) => _totalAnnualRent = val;

  void incrementTotalAnnualRent(double amount) =>
      totalAnnualRent = totalAnnualRent + amount;

  bool hasTotalAnnualRent() => _totalAnnualRent != null;

  // "rentalYield" field.
  double? _rentalYield;
  double get rentalYield => _rentalYield ?? 0.0;
  set rentalYield(double? val) => _rentalYield = val;

  void incrementRentalYield(double amount) =>
      rentalYield = rentalYield + amount;

  bool hasRentalYield() => _rentalYield != null;

  // "annualIncreasePercentage" field.
  double? _annualIncreasePercentage;
  double get annualIncreasePercentage => _annualIncreasePercentage ?? 0.0;
  set annualIncreasePercentage(double? val) => _annualIncreasePercentage = val;

  void incrementAnnualIncreasePercentage(double amount) =>
      annualIncreasePercentage = annualIncreasePercentage + amount;

  bool hasAnnualIncreasePercentage() => _annualIncreasePercentage != null;

  // "dailyCapitalGain" field.
  double? _dailyCapitalGain;
  double get dailyCapitalGain => _dailyCapitalGain ?? 0.0;
  set dailyCapitalGain(double? val) => _dailyCapitalGain = val;

  void incrementDailyCapitalGain(double amount) =>
      dailyCapitalGain = dailyCapitalGain + amount;

  bool hasDailyCapitalGain() => _dailyCapitalGain != null;

  // "allTimeCapitalAppreciation" field.
  double? _allTimeCapitalAppreciation;
  double get allTimeCapitalAppreciation => _allTimeCapitalAppreciation ?? 0.0;
  set allTimeCapitalAppreciation(double? val) =>
      _allTimeCapitalAppreciation = val;

  void incrementAllTimeCapitalAppreciation(double amount) =>
      allTimeCapitalAppreciation = allTimeCapitalAppreciation + amount;

  bool hasAllTimeCapitalAppreciation() => _allTimeCapitalAppreciation != null;

  // "allTimeRentalIncome" field.
  double? _allTimeRentalIncome;
  double get allTimeRentalIncome => _allTimeRentalIncome ?? 0.0;
  set allTimeRentalIncome(double? val) => _allTimeRentalIncome = val;

  void incrementAllTimeRentalIncome(double amount) =>
      allTimeRentalIncome = allTimeRentalIncome + amount;

  bool hasAllTimeRentalIncome() => _allTimeRentalIncome != null;

  // "allTimeExpenses" field.
  double? _allTimeExpenses;
  double get allTimeExpenses => _allTimeExpenses ?? 0.0;
  set allTimeExpenses(double? val) => _allTimeExpenses = val;

  void incrementAllTimeExpenses(double amount) =>
      allTimeExpenses = allTimeExpenses + amount;

  bool hasAllTimeExpenses() => _allTimeExpenses != null;

  // "allTimeNetProfit" field.
  double? _allTimeNetProfit;
  double get allTimeNetProfit => _allTimeNetProfit ?? 0.0;
  set allTimeNetProfit(double? val) => _allTimeNetProfit = val;

  void incrementAllTimeNetProfit(double amount) =>
      allTimeNetProfit = allTimeNetProfit + amount;

  bool hasAllTimeNetProfit() => _allTimeNetProfit != null;

  // "allTimeROI" field.
  double? _allTimeROI;
  double get allTimeROI => _allTimeROI ?? 0.0;
  set allTimeROI(double? val) => _allTimeROI = val;

  void incrementAllTimeROI(double amount) => allTimeROI = allTimeROI + amount;

  bool hasAllTimeROI() => _allTimeROI != null;

  static EstimatedGainResultsStruct fromMap(Map<String, dynamic> data) =>
      EstimatedGainResultsStruct(
        totalGain: castToType<double>(data['totalGain']),
        gainPerDay: castToType<double>(data['gainPerDay']),
        gainPerSecond: castToType<double>(data['gainPerSecond']),
        capitalGain: castToType<double>(data['capitalGain']),
        rentalProfit: castToType<double>(data['rentalProfit']),
        totalExpenses: castToType<double>(data['totalExpenses']),
        roi: castToType<double>(data['roi']),
        earningsToDate: castToType<double>(data['earningsToDate']),
        totalInvestment: castToType<double>(data['totalInvestment']),
        totalAnnualRent: castToType<double>(data['totalAnnualRent']),
        rentalYield: castToType<double>(data['rentalYield']),
        annualIncreasePercentage:
            castToType<double>(data['annualIncreasePercentage']),
        dailyCapitalGain: castToType<double>(data['dailyCapitalGain']),
        allTimeCapitalAppreciation:
            castToType<double>(data['allTimeCapitalAppreciation']),
        allTimeRentalIncome: castToType<double>(data['allTimeRentalIncome']),
        allTimeExpenses: castToType<double>(data['allTimeExpenses']),
        allTimeNetProfit: castToType<double>(data['allTimeNetProfit']),
        allTimeROI: castToType<double>(data['allTimeROI']),
      );

  static EstimatedGainResultsStruct? maybeFromMap(dynamic data) => data is Map
      ? EstimatedGainResultsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalGain': _totalGain,
        'gainPerDay': _gainPerDay,
        'gainPerSecond': _gainPerSecond,
        'capitalGain': _capitalGain,
        'rentalProfit': _rentalProfit,
        'totalExpenses': _totalExpenses,
        'roi': _roi,
        'earningsToDate': _earningsToDate,
        'totalInvestment': _totalInvestment,
        'totalAnnualRent': _totalAnnualRent,
        'rentalYield': _rentalYield,
        'annualIncreasePercentage': _annualIncreasePercentage,
        'dailyCapitalGain': _dailyCapitalGain,
        'allTimeCapitalAppreciation': _allTimeCapitalAppreciation,
        'allTimeRentalIncome': _allTimeRentalIncome,
        'allTimeExpenses': _allTimeExpenses,
        'allTimeNetProfit': _allTimeNetProfit,
        'allTimeROI': _allTimeROI,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'totalGain': serializeParam(
          _totalGain,
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
        'capitalGain': serializeParam(
          _capitalGain,
          ParamType.double,
        ),
        'rentalProfit': serializeParam(
          _rentalProfit,
          ParamType.double,
        ),
        'totalExpenses': serializeParam(
          _totalExpenses,
          ParamType.double,
        ),
        'roi': serializeParam(
          _roi,
          ParamType.double,
        ),
        'earningsToDate': serializeParam(
          _earningsToDate,
          ParamType.double,
        ),
        'totalInvestment': serializeParam(
          _totalInvestment,
          ParamType.double,
        ),
        'totalAnnualRent': serializeParam(
          _totalAnnualRent,
          ParamType.double,
        ),
        'rentalYield': serializeParam(
          _rentalYield,
          ParamType.double,
        ),
        'annualIncreasePercentage': serializeParam(
          _annualIncreasePercentage,
          ParamType.double,
        ),
        'dailyCapitalGain': serializeParam(
          _dailyCapitalGain,
          ParamType.double,
        ),
        'allTimeCapitalAppreciation': serializeParam(
          _allTimeCapitalAppreciation,
          ParamType.double,
        ),
        'allTimeRentalIncome': serializeParam(
          _allTimeRentalIncome,
          ParamType.double,
        ),
        'allTimeExpenses': serializeParam(
          _allTimeExpenses,
          ParamType.double,
        ),
        'allTimeNetProfit': serializeParam(
          _allTimeNetProfit,
          ParamType.double,
        ),
        'allTimeROI': serializeParam(
          _allTimeROI,
          ParamType.double,
        ),
      }.withoutNulls;

  static EstimatedGainResultsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      EstimatedGainResultsStruct(
        totalGain: deserializeParam(
          data['totalGain'],
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
        capitalGain: deserializeParam(
          data['capitalGain'],
          ParamType.double,
          false,
        ),
        rentalProfit: deserializeParam(
          data['rentalProfit'],
          ParamType.double,
          false,
        ),
        totalExpenses: deserializeParam(
          data['totalExpenses'],
          ParamType.double,
          false,
        ),
        roi: deserializeParam(
          data['roi'],
          ParamType.double,
          false,
        ),
        earningsToDate: deserializeParam(
          data['earningsToDate'],
          ParamType.double,
          false,
        ),
        totalInvestment: deserializeParam(
          data['totalInvestment'],
          ParamType.double,
          false,
        ),
        totalAnnualRent: deserializeParam(
          data['totalAnnualRent'],
          ParamType.double,
          false,
        ),
        rentalYield: deserializeParam(
          data['rentalYield'],
          ParamType.double,
          false,
        ),
        annualIncreasePercentage: deserializeParam(
          data['annualIncreasePercentage'],
          ParamType.double,
          false,
        ),
        dailyCapitalGain: deserializeParam(
          data['dailyCapitalGain'],
          ParamType.double,
          false,
        ),
        allTimeCapitalAppreciation: deserializeParam(
          data['allTimeCapitalAppreciation'],
          ParamType.double,
          false,
        ),
        allTimeRentalIncome: deserializeParam(
          data['allTimeRentalIncome'],
          ParamType.double,
          false,
        ),
        allTimeExpenses: deserializeParam(
          data['allTimeExpenses'],
          ParamType.double,
          false,
        ),
        allTimeNetProfit: deserializeParam(
          data['allTimeNetProfit'],
          ParamType.double,
          false,
        ),
        allTimeROI: deserializeParam(
          data['allTimeROI'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'EstimatedGainResultsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EstimatedGainResultsStruct &&
        totalGain == other.totalGain &&
        gainPerDay == other.gainPerDay &&
        gainPerSecond == other.gainPerSecond &&
        capitalGain == other.capitalGain &&
        rentalProfit == other.rentalProfit &&
        totalExpenses == other.totalExpenses &&
        roi == other.roi &&
        earningsToDate == other.earningsToDate &&
        totalInvestment == other.totalInvestment &&
        totalAnnualRent == other.totalAnnualRent &&
        rentalYield == other.rentalYield &&
        annualIncreasePercentage == other.annualIncreasePercentage &&
        dailyCapitalGain == other.dailyCapitalGain &&
        allTimeCapitalAppreciation == other.allTimeCapitalAppreciation &&
        allTimeRentalIncome == other.allTimeRentalIncome &&
        allTimeExpenses == other.allTimeExpenses &&
        allTimeNetProfit == other.allTimeNetProfit &&
        allTimeROI == other.allTimeROI;
  }

  @override
  int get hashCode => const ListEquality().hash([
        totalGain,
        gainPerDay,
        gainPerSecond,
        capitalGain,
        rentalProfit,
        totalExpenses,
        roi,
        earningsToDate,
        totalInvestment,
        totalAnnualRent,
        rentalYield,
        annualIncreasePercentage,
        dailyCapitalGain,
        allTimeCapitalAppreciation,
        allTimeRentalIncome,
        allTimeExpenses,
        allTimeNetProfit,
        allTimeROI
      ]);
}

EstimatedGainResultsStruct createEstimatedGainResultsStruct({
  double? totalGain,
  double? gainPerDay,
  double? gainPerSecond,
  double? capitalGain,
  double? rentalProfit,
  double? totalExpenses,
  double? roi,
  double? earningsToDate,
  double? totalInvestment,
  double? totalAnnualRent,
  double? rentalYield,
  double? annualIncreasePercentage,
  double? dailyCapitalGain,
  double? allTimeCapitalAppreciation,
  double? allTimeRentalIncome,
  double? allTimeExpenses,
  double? allTimeNetProfit,
  double? allTimeROI,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EstimatedGainResultsStruct(
      totalGain: totalGain,
      gainPerDay: gainPerDay,
      gainPerSecond: gainPerSecond,
      capitalGain: capitalGain,
      rentalProfit: rentalProfit,
      totalExpenses: totalExpenses,
      roi: roi,
      earningsToDate: earningsToDate,
      totalInvestment: totalInvestment,
      totalAnnualRent: totalAnnualRent,
      rentalYield: rentalYield,
      annualIncreasePercentage: annualIncreasePercentage,
      dailyCapitalGain: dailyCapitalGain,
      allTimeCapitalAppreciation: allTimeCapitalAppreciation,
      allTimeRentalIncome: allTimeRentalIncome,
      allTimeExpenses: allTimeExpenses,
      allTimeNetProfit: allTimeNetProfit,
      allTimeROI: allTimeROI,
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
