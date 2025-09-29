import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RentIncreaseYearsRecord extends FirestoreRecord {
  RentIncreaseYearsRecord._(
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
      FirebaseFirestore.instance.collection('rentIncreaseYears');

  static Stream<RentIncreaseYearsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RentIncreaseYearsRecord.fromSnapshot(s));

  static Future<RentIncreaseYearsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => RentIncreaseYearsRecord.fromSnapshot(s));

  static RentIncreaseYearsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RentIncreaseYearsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RentIncreaseYearsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RentIncreaseYearsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RentIncreaseYearsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RentIncreaseYearsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRentIncreaseYearsRecordData({
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

class RentIncreaseYearsRecordDocumentEquality
    implements Equality<RentIncreaseYearsRecord> {
  const RentIncreaseYearsRecordDocumentEquality();

  @override
  bool equals(RentIncreaseYearsRecord? e1, RentIncreaseYearsRecord? e2) {
    return e1?.year == e2?.year && e1?.pct == e2?.pct;
  }

  @override
  int hash(RentIncreaseYearsRecord? e) =>
      const ListEquality().hash([e?.year, e?.pct]);

  @override
  bool isValidKey(Object? o) => o is RentIncreaseYearsRecord;
}
