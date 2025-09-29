import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RentalIncreaseOverridesRecord extends FirestoreRecord {
  RentalIncreaseOverridesRecord._(
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

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _year = castToType<int>(snapshotData['year']);
    _pct = castToType<double>(snapshotData['pct']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('rentalIncreaseOverrides')
          : FirebaseFirestore.instance
              .collectionGroup('rentalIncreaseOverrides');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('rentalIncreaseOverrides').doc(id);

  static Stream<RentalIncreaseOverridesRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => RentalIncreaseOverridesRecord.fromSnapshot(s));

  static Future<RentalIncreaseOverridesRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => RentalIncreaseOverridesRecord.fromSnapshot(s));

  static RentalIncreaseOverridesRecord fromSnapshot(
          DocumentSnapshot snapshot) =>
      RentalIncreaseOverridesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RentalIncreaseOverridesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RentalIncreaseOverridesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RentalIncreaseOverridesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RentalIncreaseOverridesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRentalIncreaseOverridesRecordData({
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

class RentalIncreaseOverridesRecordDocumentEquality
    implements Equality<RentalIncreaseOverridesRecord> {
  const RentalIncreaseOverridesRecordDocumentEquality();

  @override
  bool equals(
      RentalIncreaseOverridesRecord? e1, RentalIncreaseOverridesRecord? e2) {
    return e1?.year == e2?.year && e1?.pct == e2?.pct;
  }

  @override
  int hash(RentalIncreaseOverridesRecord? e) =>
      const ListEquality().hash([e?.year, e?.pct]);

  @override
  bool isValidKey(Object? o) => o is RentalIncreaseOverridesRecord;
}
