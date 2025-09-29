import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RentalPaymentsRecord extends FirestoreRecord {
  RentalPaymentsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "propertyId" field.
  String? _propertyId;
  String get propertyId => _propertyId ?? '';
  bool hasPropertyId() => _propertyId != null;

  // "tenancyId" field.
  String? _tenancyId;
  String get tenancyId => _tenancyId ?? '';
  bool hasTenancyId() => _tenancyId != null;

  // "ownerId" field.
  String? _ownerId;
  String get ownerId => _ownerId ?? '';
  bool hasOwnerId() => _ownerId != null;

  // "amountPaid" field.
  double? _amountPaid;
  double get amountPaid => _amountPaid ?? 0.0;
  bool hasAmountPaid() => _amountPaid != null;

  // "paymentDate" field.
  DateTime? _paymentDate;
  DateTime? get paymentDate => _paymentDate;
  bool hasPaymentDate() => _paymentDate != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "notifiedUser" field.
  bool? _notifiedUser;
  bool get notifiedUser => _notifiedUser ?? false;
  bool hasNotifiedUser() => _notifiedUser != null;

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
    _tenancyId = snapshotData['tenancyId'] as String?;
    _ownerId = snapshotData['ownerId'] as String?;
    _amountPaid = castToType<double>(snapshotData['amountPaid']);
    _paymentDate = snapshotData['paymentDate'] as DateTime?;
    _status = snapshotData['status'] as String?;
    _notifiedUser = snapshotData['notifiedUser'] as bool?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _notes = snapshotData['notes'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('rentalPayments');

  static Stream<RentalPaymentsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RentalPaymentsRecord.fromSnapshot(s));

  static Future<RentalPaymentsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RentalPaymentsRecord.fromSnapshot(s));

  static RentalPaymentsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RentalPaymentsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RentalPaymentsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RentalPaymentsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RentalPaymentsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RentalPaymentsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRentalPaymentsRecordData({
  String? propertyId,
  String? tenancyId,
  String? ownerId,
  double? amountPaid,
  DateTime? paymentDate,
  String? status,
  bool? notifiedUser,
  DateTime? createdAt,
  String? notes,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'propertyId': propertyId,
      'tenancyId': tenancyId,
      'ownerId': ownerId,
      'amountPaid': amountPaid,
      'paymentDate': paymentDate,
      'status': status,
      'notifiedUser': notifiedUser,
      'createdAt': createdAt,
      'notes': notes,
    }.withoutNulls,
  );

  return firestoreData;
}

class RentalPaymentsRecordDocumentEquality
    implements Equality<RentalPaymentsRecord> {
  const RentalPaymentsRecordDocumentEquality();

  @override
  bool equals(RentalPaymentsRecord? e1, RentalPaymentsRecord? e2) {
    return e1?.propertyId == e2?.propertyId &&
        e1?.tenancyId == e2?.tenancyId &&
        e1?.ownerId == e2?.ownerId &&
        e1?.amountPaid == e2?.amountPaid &&
        e1?.paymentDate == e2?.paymentDate &&
        e1?.status == e2?.status &&
        e1?.notifiedUser == e2?.notifiedUser &&
        e1?.createdAt == e2?.createdAt &&
        e1?.notes == e2?.notes;
  }

  @override
  int hash(RentalPaymentsRecord? e) => const ListEquality().hash([
        e?.propertyId,
        e?.tenancyId,
        e?.ownerId,
        e?.amountPaid,
        e?.paymentDate,
        e?.status,
        e?.notifiedUser,
        e?.createdAt,
        e?.notes
      ]);

  @override
  bool isValidKey(Object? o) => o is RentalPaymentsRecord;
}
