import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HousePriceYearsRecord extends FirestoreRecord {
  HousePriceYearsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "year" field.
  int? _year;
  int get year => _year ?? 0;
  bool hasYear() => _year != null;

  // "pct" field.
  double? _pct;
  double get pct => _pct ?? 0.0;
  bool hasPct() => _pct != null;

  void _initializeFields() {
    _year = castToType<int>(snapshotData['year']);
    _pct = castToType<double>(snapshotData['pct']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('housePriceYears');

  static Stream<HousePriceYearsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HousePriceYearsRecord.fromSnapshot(s));

  static Future<HousePriceYearsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HousePriceYearsRecord.fromSnapshot(s));

  static HousePriceYearsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      HousePriceYearsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HousePriceYearsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HousePriceYearsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HousePriceYearsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HousePriceYearsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHousePriceYearsRecordData({
  int? year,
  double? pct,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'year': year,
      'pct': pct,
    }.withoutNulls,
  );

  return firestoreData;
}

class HousePriceYearsRecordDocumentEquality
    implements Equality<HousePriceYearsRecord> {
  const HousePriceYearsRecordDocumentEquality();

  @override
  bool equals(HousePriceYearsRecord? e1, HousePriceYearsRecord? e2) {
    return e1?.year == e2?.year && e1?.pct == e2?.pct;
  }

  @override
  int hash(HousePriceYearsRecord? e) =>
      const ListEquality().hash([e?.year, e?.pct]);

  @override
  bool isValidKey(Object? o) => o is HousePriceYearsRecord;
}
