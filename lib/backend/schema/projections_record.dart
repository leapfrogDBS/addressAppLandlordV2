import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProjectionsRecord extends FirestoreRecord {
  ProjectionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "years" field.
  List<int>? _years;
  List<int> get years => _years ?? const [];
  bool hasYears() => _years != null;

  // "projectedHousePrice" field.
  List<double>? _projectedHousePrice;
  List<double> get projectedHousePrice => _projectedHousePrice ?? const [];
  bool hasProjectedHousePrice() => _projectedHousePrice != null;

  // "rentalIncome" field.
  List<double>? _rentalIncome;
  List<double> get rentalIncome => _rentalIncome ?? const [];
  bool hasRentalIncome() => _rentalIncome != null;

  // "rentalProfit" field.
  List<double>? _rentalProfit;
  List<double> get rentalProfit => _rentalProfit ?? const [];
  bool hasRentalProfit() => _rentalProfit != null;

  // "cumulativeRentalProfit" field.
  List<double>? _cumulativeRentalProfit;
  List<double> get cumulativeRentalProfit =>
      _cumulativeRentalProfit ?? const [];
  bool hasCumulativeRentalProfit() => _cumulativeRentalProfit != null;

  // "combinedDailyGain" field.
  List<double>? _combinedDailyGain;
  List<double> get combinedDailyGain => _combinedDailyGain ?? const [];
  bool hasCombinedDailyGain() => _combinedDailyGain != null;

  // "expenses" field.
  List<double>? _expenses;
  List<double> get expenses => _expenses ?? const [];
  bool hasExpenses() => _expenses != null;

  // "startYear" field.
  int? _startYear;
  int get startYear => _startYear ?? 0;
  bool hasStartYear() => _startYear != null;

  // "endYear" field.
  int? _endYear;
  int get endYear => _endYear ?? 0;
  bool hasEndYear() => _endYear != null;

  // "lastComputedAt" field.
  DateTime? _lastComputedAt;
  DateTime? get lastComputedAt => _lastComputedAt;
  bool hasLastComputedAt() => _lastComputedAt != null;

  // "salesOfferRef" field.
  DocumentReference? _salesOfferRef;
  DocumentReference? get salesOfferRef => _salesOfferRef;
  bool hasSalesOfferRef() => _salesOfferRef != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _years = getDataList(snapshotData['years']);
    _projectedHousePrice = getDataList(snapshotData['projectedHousePrice']);
    _rentalIncome = getDataList(snapshotData['rentalIncome']);
    _rentalProfit = getDataList(snapshotData['rentalProfit']);
    _cumulativeRentalProfit =
        getDataList(snapshotData['cumulativeRentalProfit']);
    _combinedDailyGain = getDataList(snapshotData['combinedDailyGain']);
    _expenses = getDataList(snapshotData['expenses']);
    _startYear = castToType<int>(snapshotData['startYear']);
    _endYear = castToType<int>(snapshotData['endYear']);
    _lastComputedAt = snapshotData['lastComputedAt'] as DateTime?;
    _salesOfferRef = snapshotData['salesOfferRef'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('projections')
          : FirebaseFirestore.instance.collectionGroup('projections');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('projections').doc(id);

  static Stream<ProjectionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProjectionsRecord.fromSnapshot(s));

  static Future<ProjectionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProjectionsRecord.fromSnapshot(s));

  static ProjectionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProjectionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProjectionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProjectionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProjectionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProjectionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProjectionsRecordData({
  int? startYear,
  int? endYear,
  DateTime? lastComputedAt,
  DocumentReference? salesOfferRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'startYear': startYear,
      'endYear': endYear,
      'lastComputedAt': lastComputedAt,
      'salesOfferRef': salesOfferRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProjectionsRecordDocumentEquality implements Equality<ProjectionsRecord> {
  const ProjectionsRecordDocumentEquality();

  @override
  bool equals(ProjectionsRecord? e1, ProjectionsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.years, e2?.years) &&
        listEquality.equals(e1?.projectedHousePrice, e2?.projectedHousePrice) &&
        listEquality.equals(e1?.rentalIncome, e2?.rentalIncome) &&
        listEquality.equals(e1?.rentalProfit, e2?.rentalProfit) &&
        listEquality.equals(
            e1?.cumulativeRentalProfit, e2?.cumulativeRentalProfit) &&
        listEquality.equals(e1?.combinedDailyGain, e2?.combinedDailyGain) &&
        listEquality.equals(e1?.expenses, e2?.expenses) &&
        e1?.startYear == e2?.startYear &&
        e1?.endYear == e2?.endYear &&
        e1?.lastComputedAt == e2?.lastComputedAt &&
        e1?.salesOfferRef == e2?.salesOfferRef;
  }

  @override
  int hash(ProjectionsRecord? e) => const ListEquality().hash([
        e?.years,
        e?.projectedHousePrice,
        e?.rentalIncome,
        e?.rentalProfit,
        e?.cumulativeRentalProfit,
        e?.combinedDailyGain,
        e?.expenses,
        e?.startYear,
        e?.endYear,
        e?.lastComputedAt,
        e?.salesOfferRef
      ]);

  @override
  bool isValidKey(Object? o) => o is ProjectionsRecord;
}
