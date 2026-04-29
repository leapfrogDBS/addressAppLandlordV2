import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AppConfigRecord extends FirestoreRecord {
  AppConfigRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "expenseInflationPct" field.
  double? _expenseInflationPct;
  double get expenseInflationPct => _expenseInflationPct ?? 0.0;
  bool hasExpenseInflationPct() => _expenseInflationPct != null;

  void _initializeFields() {
    _expenseInflationPct =
        castToType<double>(snapshotData['expenseInflationPct']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('appConfig');

  static Stream<AppConfigRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AppConfigRecord.fromSnapshot(s));

  static Future<AppConfigRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AppConfigRecord.fromSnapshot(s));

  static AppConfigRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AppConfigRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AppConfigRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AppConfigRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AppConfigRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AppConfigRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAppConfigRecordData({
  double? expenseInflationPct,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'expenseInflationPct': expenseInflationPct,
    }.withoutNulls,
  );

  return firestoreData;
}

class AppConfigRecordDocumentEquality implements Equality<AppConfigRecord> {
  const AppConfigRecordDocumentEquality();

  @override
  bool equals(AppConfigRecord? e1, AppConfigRecord? e2) {
    return e1?.expenseInflationPct == e2?.expenseInflationPct;
  }

  @override
  int hash(AppConfigRecord? e) =>
      const ListEquality().hash([e?.expenseInflationPct]);

  @override
  bool isValidKey(Object? o) => o is AppConfigRecord;
}
