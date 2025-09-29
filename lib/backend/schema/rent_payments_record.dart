import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RentPaymentsRecord extends FirestoreRecord {
  RentPaymentsRecord._(
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

  // "tenancyId" field.
  String? _tenancyId;
  String get tenancyId => _tenancyId ?? '';
  bool hasTenancyId() => _tenancyId != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  bool hasAmount() => _amount != null;

  // "occurredAt" field.
  DateTime? _occurredAt;
  DateTime? get occurredAt => _occurredAt;
  bool hasOccurredAt() => _occurredAt != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  // "source" field.
  String? _source;
  String get source => _source ?? '';
  bool hasSource() => _source != null;

  void _initializeFields() {
    _propertyId = snapshotData['propertyId'] as String?;
    _landlordId = snapshotData['landlordId'] as String?;
    _tenancyId = snapshotData['tenancyId'] as String?;
    _amount = castToType<double>(snapshotData['amount']);
    _occurredAt = snapshotData['occurredAt'] as DateTime?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _notes = snapshotData['notes'] as String?;
    _source = snapshotData['source'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('rentPayments');

  static Stream<RentPaymentsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RentPaymentsRecord.fromSnapshot(s));

  static Future<RentPaymentsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RentPaymentsRecord.fromSnapshot(s));

  static RentPaymentsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RentPaymentsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RentPaymentsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RentPaymentsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RentPaymentsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RentPaymentsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRentPaymentsRecordData({
  String? propertyId,
  String? landlordId,
  String? tenancyId,
  double? amount,
  DateTime? occurredAt,
  DateTime? createdAt,
  String? notes,
  String? source,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'propertyId': propertyId,
      'landlordId': landlordId,
      'tenancyId': tenancyId,
      'amount': amount,
      'occurredAt': occurredAt,
      'createdAt': createdAt,
      'notes': notes,
      'source': source,
    }.withoutNulls,
  );

  return firestoreData;
}

class RentPaymentsRecordDocumentEquality
    implements Equality<RentPaymentsRecord> {
  const RentPaymentsRecordDocumentEquality();

  @override
  bool equals(RentPaymentsRecord? e1, RentPaymentsRecord? e2) {
    return e1?.propertyId == e2?.propertyId &&
        e1?.landlordId == e2?.landlordId &&
        e1?.tenancyId == e2?.tenancyId &&
        e1?.amount == e2?.amount &&
        e1?.occurredAt == e2?.occurredAt &&
        e1?.createdAt == e2?.createdAt &&
        e1?.notes == e2?.notes &&
        e1?.source == e2?.source;
  }

  @override
  int hash(RentPaymentsRecord? e) => const ListEquality().hash([
        e?.propertyId,
        e?.landlordId,
        e?.tenancyId,
        e?.amount,
        e?.occurredAt,
        e?.createdAt,
        e?.notes,
        e?.source
      ]);

  @override
  bool isValidKey(Object? o) => o is RentPaymentsRecord;
}
