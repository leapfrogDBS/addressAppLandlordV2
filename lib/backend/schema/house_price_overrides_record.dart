import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HousePriceOverridesRecord extends FirestoreRecord {
  HousePriceOverridesRecord._(
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
          ? parent.collection('housePriceOverrides')
          : FirebaseFirestore.instance.collectionGroup('housePriceOverrides');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('housePriceOverrides').doc(id);

  static Stream<HousePriceOverridesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HousePriceOverridesRecord.fromSnapshot(s));

  static Future<HousePriceOverridesRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => HousePriceOverridesRecord.fromSnapshot(s));

  static HousePriceOverridesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      HousePriceOverridesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HousePriceOverridesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HousePriceOverridesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HousePriceOverridesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HousePriceOverridesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHousePriceOverridesRecordData({
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

class HousePriceOverridesRecordDocumentEquality
    implements Equality<HousePriceOverridesRecord> {
  const HousePriceOverridesRecordDocumentEquality();

  @override
  bool equals(HousePriceOverridesRecord? e1, HousePriceOverridesRecord? e2) {
    return e1?.year == e2?.year && e1?.pct == e2?.pct;
  }

  @override
  int hash(HousePriceOverridesRecord? e) =>
      const ListEquality().hash([e?.year, e?.pct]);

  @override
  bool isValidKey(Object? o) => o is HousePriceOverridesRecord;
}
