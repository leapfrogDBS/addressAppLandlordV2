import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PropertyProjectionsRecord extends FirestoreRecord {
  PropertyProjectionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "propertyRef" field.
  DocumentReference? _propertyRef;
  DocumentReference? get propertyRef => _propertyRef;
  bool hasPropertyRef() => _propertyRef != null;

  // "startYear" field.
  int? _startYear;
  int get startYear => _startYear ?? 0;
  bool hasStartYear() => _startYear != null;

  // "endYear" field.
  int? _endYear;
  int get endYear => _endYear ?? 0;
  bool hasEndYear() => _endYear != null;

  // "rental" field.
  List<double>? _rental;
  List<double> get rental => _rental ?? const [];
  bool hasRental() => _rental != null;

  // "combined" field.
  List<double>? _combined;
  List<double> get combined => _combined ?? const [];
  bool hasCombined() => _combined != null;

  // "atRetirementYear" field.
  int? _atRetirementYear;
  int get atRetirementYear => _atRetirementYear ?? 0;
  bool hasAtRetirementYear() => _atRetirementYear != null;

  // "atRetirementCapital" field.
  double? _atRetirementCapital;
  double get atRetirementCapital => _atRetirementCapital ?? 0.0;
  bool hasAtRetirementCapital() => _atRetirementCapital != null;

  // "lastComputedAt" field.
  DateTime? _lastComputedAt;
  DateTime? get lastComputedAt => _lastComputedAt;
  bool hasLastComputedAt() => _lastComputedAt != null;

  // "atRetirementAnnualRent" field.
  double? _atRetirementAnnualRent;
  double get atRetirementAnnualRent => _atRetirementAnnualRent ?? 0.0;
  bool hasAtRetirementAnnualRent() => _atRetirementAnnualRent != null;

  // "atRetirementCapitalValue" field.
  double? _atRetirementCapitalValue;
  double get atRetirementCapitalValue => _atRetirementCapitalValue ?? 0.0;
  bool hasAtRetirementCapitalValue() => _atRetirementCapitalValue != null;

  // "capitalGains" field.
  List<double>? _capitalGains;
  List<double> get capitalGains => _capitalGains ?? const [];
  bool hasCapitalGains() => _capitalGains != null;

  // "dailyCapitalGain" field.
  List<double>? _dailyCapitalGain;
  List<double> get dailyCapitalGain => _dailyCapitalGain ?? const [];
  bool hasDailyCapitalGain() => _dailyCapitalGain != null;

  // "housePctUsed" field.
  List<double>? _housePctUsed;
  List<double> get housePctUsed => _housePctUsed ?? const [];
  bool hasHousePctUsed() => _housePctUsed != null;

  // "projectedHousePrice" field.
  List<double>? _projectedHousePrice;
  List<double> get projectedHousePrice => _projectedHousePrice ?? const [];
  bool hasProjectedHousePrice() => _projectedHousePrice != null;

  // "years" field.
  List<int>? _years;
  List<int> get years => _years ?? const [];
  bool hasYears() => _years != null;

  // "rentalIncome" field.
  List<double>? _rentalIncome;
  List<double> get rentalIncome => _rentalIncome ?? const [];
  bool hasRentalIncome() => _rentalIncome != null;

  // "expenses" field.
  List<double>? _expenses;
  List<double> get expenses => _expenses ?? const [];
  bool hasExpenses() => _expenses != null;

  // "rentalProfit" field.
  List<double>? _rentalProfit;
  List<double> get rentalProfit => _rentalProfit ?? const [];
  bool hasRentalProfit() => _rentalProfit != null;

  // "yieldPct" field.
  List<double>? _yieldPct;
  List<double> get yieldPct => _yieldPct ?? const [];
  bool hasYieldPct() => _yieldPct != null;

  // "hasActiveTenancy" field.
  bool? _hasActiveTenancy;
  bool get hasActiveTenancy => _hasActiveTenancy ?? false;
  bool hasHasActiveTenancy() => _hasActiveTenancy != null;

  // "combinedDailyGain" field.
  List<double>? _combinedDailyGain;
  List<double> get combinedDailyGain => _combinedDailyGain ?? const [];
  bool hasCombinedDailyGain() => _combinedDailyGain != null;

  // "atRetirementCumulativeRentalProfit" field.
  double? _atRetirementCumulativeRentalProfit;
  double get atRetirementCumulativeRentalProfit =>
      _atRetirementCumulativeRentalProfit ?? 0.0;
  bool hasAtRetirementCumulativeRentalProfit() =>
      _atRetirementCumulativeRentalProfit != null;

  // "ownerId" field.
  String? _ownerId;
  String get ownerId => _ownerId ?? '';
  bool hasOwnerId() => _ownerId != null;

  // "ownerRef" field.
  DocumentReference? _ownerRef;
  DocumentReference? get ownerRef => _ownerRef;
  bool hasOwnerRef() => _ownerRef != null;

  // "atRetirementCombinedDailyGain" field.
  double? _atRetirementCombinedDailyGain;
  double get atRetirementCombinedDailyGain =>
      _atRetirementCombinedDailyGain ?? 0.0;
  bool hasAtRetirementCombinedDailyGain() =>
      _atRetirementCombinedDailyGain != null;

  // "cumulativeRentalProfit" field.
  List<double>? _cumulativeRentalProfit;
  List<double> get cumulativeRentalProfit =>
      _cumulativeRentalProfit ?? const [];
  bool hasCumulativeRentalProfit() => _cumulativeRentalProfit != null;

  // "historicalNetProfitBaseToJan1" field.
  double? _historicalNetProfitBaseToJan1;
  double get historicalNetProfitBaseToJan1 =>
      _historicalNetProfitBaseToJan1 ?? 0.0;
  bool hasHistoricalNetProfitBaseToJan1() =>
      _historicalNetProfitBaseToJan1 != null;

  void _initializeFields() {
    _propertyRef = snapshotData['propertyRef'] as DocumentReference?;
    _startYear = castToType<int>(snapshotData['startYear']);
    _endYear = castToType<int>(snapshotData['endYear']);
    _rental = getDataList(snapshotData['rental']);
    _combined = getDataList(snapshotData['combined']);
    _atRetirementYear = castToType<int>(snapshotData['atRetirementYear']);
    _atRetirementCapital =
        castToType<double>(snapshotData['atRetirementCapital']);
    _lastComputedAt = snapshotData['lastComputedAt'] as DateTime?;
    _atRetirementAnnualRent =
        castToType<double>(snapshotData['atRetirementAnnualRent']);
    _atRetirementCapitalValue =
        castToType<double>(snapshotData['atRetirementCapitalValue']);
    _capitalGains = getDataList(snapshotData['capitalGains']);
    _dailyCapitalGain = getDataList(snapshotData['dailyCapitalGain']);
    _housePctUsed = getDataList(snapshotData['housePctUsed']);
    _projectedHousePrice = getDataList(snapshotData['projectedHousePrice']);
    _years = getDataList(snapshotData['years']);
    _rentalIncome = getDataList(snapshotData['rentalIncome']);
    _expenses = getDataList(snapshotData['expenses']);
    _rentalProfit = getDataList(snapshotData['rentalProfit']);
    _yieldPct = getDataList(snapshotData['yieldPct']);
    _hasActiveTenancy = snapshotData['hasActiveTenancy'] as bool?;
    _combinedDailyGain = getDataList(snapshotData['combinedDailyGain']);
    _atRetirementCumulativeRentalProfit =
        castToType<double>(snapshotData['atRetirementCumulativeRentalProfit']);
    _ownerId = snapshotData['ownerId'] as String?;
    _ownerRef = snapshotData['ownerRef'] as DocumentReference?;
    _atRetirementCombinedDailyGain =
        castToType<double>(snapshotData['atRetirementCombinedDailyGain']);
    _cumulativeRentalProfit =
        getDataList(snapshotData['cumulativeRentalProfit']);
    _historicalNetProfitBaseToJan1 =
        castToType<double>(snapshotData['historicalNetProfitBaseToJan1']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('propertyProjections');

  static Stream<PropertyProjectionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PropertyProjectionsRecord.fromSnapshot(s));

  static Future<PropertyProjectionsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => PropertyProjectionsRecord.fromSnapshot(s));

  static PropertyProjectionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PropertyProjectionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PropertyProjectionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PropertyProjectionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PropertyProjectionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PropertyProjectionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPropertyProjectionsRecordData({
  DocumentReference? propertyRef,
  int? startYear,
  int? endYear,
  int? atRetirementYear,
  double? atRetirementCapital,
  DateTime? lastComputedAt,
  double? atRetirementAnnualRent,
  double? atRetirementCapitalValue,
  bool? hasActiveTenancy,
  double? atRetirementCumulativeRentalProfit,
  String? ownerId,
  DocumentReference? ownerRef,
  double? atRetirementCombinedDailyGain,
  double? historicalNetProfitBaseToJan1,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'propertyRef': propertyRef,
      'startYear': startYear,
      'endYear': endYear,
      'atRetirementYear': atRetirementYear,
      'atRetirementCapital': atRetirementCapital,
      'lastComputedAt': lastComputedAt,
      'atRetirementAnnualRent': atRetirementAnnualRent,
      'atRetirementCapitalValue': atRetirementCapitalValue,
      'hasActiveTenancy': hasActiveTenancy,
      'atRetirementCumulativeRentalProfit': atRetirementCumulativeRentalProfit,
      'ownerId': ownerId,
      'ownerRef': ownerRef,
      'atRetirementCombinedDailyGain': atRetirementCombinedDailyGain,
      'historicalNetProfitBaseToJan1': historicalNetProfitBaseToJan1,
    }.withoutNulls,
  );

  return firestoreData;
}

class PropertyProjectionsRecordDocumentEquality
    implements Equality<PropertyProjectionsRecord> {
  const PropertyProjectionsRecordDocumentEquality();

  @override
  bool equals(PropertyProjectionsRecord? e1, PropertyProjectionsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.propertyRef == e2?.propertyRef &&
        e1?.startYear == e2?.startYear &&
        e1?.endYear == e2?.endYear &&
        listEquality.equals(e1?.rental, e2?.rental) &&
        listEquality.equals(e1?.combined, e2?.combined) &&
        e1?.atRetirementYear == e2?.atRetirementYear &&
        e1?.atRetirementCapital == e2?.atRetirementCapital &&
        e1?.lastComputedAt == e2?.lastComputedAt &&
        e1?.atRetirementAnnualRent == e2?.atRetirementAnnualRent &&
        e1?.atRetirementCapitalValue == e2?.atRetirementCapitalValue &&
        listEquality.equals(e1?.capitalGains, e2?.capitalGains) &&
        listEquality.equals(e1?.dailyCapitalGain, e2?.dailyCapitalGain) &&
        listEquality.equals(e1?.housePctUsed, e2?.housePctUsed) &&
        listEquality.equals(e1?.projectedHousePrice, e2?.projectedHousePrice) &&
        listEquality.equals(e1?.years, e2?.years) &&
        listEquality.equals(e1?.rentalIncome, e2?.rentalIncome) &&
        listEquality.equals(e1?.expenses, e2?.expenses) &&
        listEquality.equals(e1?.rentalProfit, e2?.rentalProfit) &&
        listEquality.equals(e1?.yieldPct, e2?.yieldPct) &&
        e1?.hasActiveTenancy == e2?.hasActiveTenancy &&
        listEquality.equals(e1?.combinedDailyGain, e2?.combinedDailyGain) &&
        e1?.atRetirementCumulativeRentalProfit ==
            e2?.atRetirementCumulativeRentalProfit &&
        e1?.ownerId == e2?.ownerId &&
        e1?.ownerRef == e2?.ownerRef &&
        e1?.atRetirementCombinedDailyGain ==
            e2?.atRetirementCombinedDailyGain &&
        listEquality.equals(
            e1?.cumulativeRentalProfit, e2?.cumulativeRentalProfit) &&
        e1?.historicalNetProfitBaseToJan1 == e2?.historicalNetProfitBaseToJan1;
  }

  @override
  int hash(PropertyProjectionsRecord? e) => const ListEquality().hash([
        e?.propertyRef,
        e?.startYear,
        e?.endYear,
        e?.rental,
        e?.combined,
        e?.atRetirementYear,
        e?.atRetirementCapital,
        e?.lastComputedAt,
        e?.atRetirementAnnualRent,
        e?.atRetirementCapitalValue,
        e?.capitalGains,
        e?.dailyCapitalGain,
        e?.housePctUsed,
        e?.projectedHousePrice,
        e?.years,
        e?.rentalIncome,
        e?.expenses,
        e?.rentalProfit,
        e?.yieldPct,
        e?.hasActiveTenancy,
        e?.combinedDailyGain,
        e?.atRetirementCumulativeRentalProfit,
        e?.ownerId,
        e?.ownerRef,
        e?.atRetirementCombinedDailyGain,
        e?.cumulativeRentalProfit,
        e?.historicalNetProfitBaseToJan1
      ]);

  @override
  bool isValidKey(Object? o) => o is PropertyProjectionsRecord;
}
