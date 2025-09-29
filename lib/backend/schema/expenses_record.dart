import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ExpensesRecord extends FirestoreRecord {
  ExpensesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "propertyId" field.
  String? _propertyId;
  String get propertyId => _propertyId ?? '';
  bool hasPropertyId() => _propertyId != null;

  // "landlordId" field.
  String? _landlordId;
  String get landlordId => _landlordId ?? '';
  bool hasLandlordId() => _landlordId != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  bool hasAmount() => _amount != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "occuredAt" field.
  DateTime? _occuredAt;
  DateTime? get occuredAt => _occuredAt;
  bool hasOccuredAt() => _occuredAt != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  void _initializeFields() {
    _propertyId = snapshotData['propertyId'] as String?;
    _landlordId = snapshotData['landlordId'] as String?;
    _amount = castToType<double>(snapshotData['amount']);
    _category = snapshotData['category'] as String?;
    _occuredAt = snapshotData['occuredAt'] as DateTime?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _notes = snapshotData['notes'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('expenses');

  static Stream<ExpensesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ExpensesRecord.fromSnapshot(s));

  static Future<ExpensesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ExpensesRecord.fromSnapshot(s));

  static ExpensesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ExpensesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ExpensesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ExpensesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ExpensesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ExpensesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createExpensesRecordData({
  String? propertyId,
  String? landlordId,
  double? amount,
  String? category,
  DateTime? occuredAt,
  DateTime? createdAt,
  String? notes,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'propertyId': propertyId,
      'landlordId': landlordId,
      'amount': amount,
      'category': category,
      'occuredAt': occuredAt,
      'createdAt': createdAt,
      'notes': notes,
    }.withoutNulls,
  );

  return firestoreData;
}

class ExpensesRecordDocumentEquality implements Equality<ExpensesRecord> {
  const ExpensesRecordDocumentEquality();

  @override
  bool equals(ExpensesRecord? e1, ExpensesRecord? e2) {
    return e1?.propertyId == e2?.propertyId &&
        e1?.landlordId == e2?.landlordId &&
        e1?.amount == e2?.amount &&
        e1?.category == e2?.category &&
        e1?.occuredAt == e2?.occuredAt &&
        e1?.createdAt == e2?.createdAt &&
        e1?.notes == e2?.notes;
  }

  @override
  int hash(ExpensesRecord? e) => const ListEquality().hash([
        e?.propertyId,
        e?.landlordId,
        e?.amount,
        e?.category,
        e?.occuredAt,
        e?.createdAt,
        e?.notes
      ]);

  @override
  bool isValidKey(Object? o) => o is ExpensesRecord;
}
