import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TenanciesRecord extends FirestoreRecord {
  TenanciesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "tenantName" field.
  String? _tenantName;
  String get tenantName => _tenantName ?? '';
  bool hasTenantName() => _tenantName != null;

  // "tenancyStartDate" field.
  DateTime? _tenancyStartDate;
  DateTime? get tenancyStartDate => _tenancyStartDate;
  bool hasTenancyStartDate() => _tenancyStartDate != null;

  // "rentAmount" field.
  double? _rentAmount;
  double get rentAmount => _rentAmount ?? 0.0;
  bool hasRentAmount() => _rentAmount != null;

  // "rentDueDay" field.
  int? _rentDueDay;
  int get rentDueDay => _rentDueDay ?? 0;
  bool hasRentDueDay() => _rentDueDay != null;

  // "isActive" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  // "last_updated" field.
  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;
  bool hasLastUpdated() => _lastUpdated != null;

  // "updated_by" field.
  String? _updatedBy;
  String get updatedBy => _updatedBy ?? '';
  bool hasUpdatedBy() => _updatedBy != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _tenantName = snapshotData['tenantName'] as String?;
    _tenancyStartDate = snapshotData['tenancyStartDate'] as DateTime?;
    _rentAmount = castToType<double>(snapshotData['rentAmount']);
    _rentDueDay = castToType<int>(snapshotData['rentDueDay']);
    _isActive = snapshotData['isActive'] as bool?;
    _lastUpdated = snapshotData['last_updated'] as DateTime?;
    _updatedBy = snapshotData['updated_by'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('tenancies')
          : FirebaseFirestore.instance.collectionGroup('tenancies');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('tenancies').doc(id);

  static Stream<TenanciesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TenanciesRecord.fromSnapshot(s));

  static Future<TenanciesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TenanciesRecord.fromSnapshot(s));

  static TenanciesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TenanciesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TenanciesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TenanciesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TenanciesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TenanciesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTenanciesRecordData({
  String? tenantName,
  DateTime? tenancyStartDate,
  double? rentAmount,
  int? rentDueDay,
  bool? isActive,
  DateTime? lastUpdated,
  String? updatedBy,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'tenantName': tenantName,
      'tenancyStartDate': tenancyStartDate,
      'rentAmount': rentAmount,
      'rentDueDay': rentDueDay,
      'isActive': isActive,
      'last_updated': lastUpdated,
      'updated_by': updatedBy,
    }.withoutNulls,
  );

  return firestoreData;
}

class TenanciesRecordDocumentEquality implements Equality<TenanciesRecord> {
  const TenanciesRecordDocumentEquality();

  @override
  bool equals(TenanciesRecord? e1, TenanciesRecord? e2) {
    return e1?.tenantName == e2?.tenantName &&
        e1?.tenancyStartDate == e2?.tenancyStartDate &&
        e1?.rentAmount == e2?.rentAmount &&
        e1?.rentDueDay == e2?.rentDueDay &&
        e1?.isActive == e2?.isActive &&
        e1?.lastUpdated == e2?.lastUpdated &&
        e1?.updatedBy == e2?.updatedBy;
  }

  @override
  int hash(TenanciesRecord? e) => const ListEquality().hash([
        e?.tenantName,
        e?.tenancyStartDate,
        e?.rentAmount,
        e?.rentDueDay,
        e?.isActive,
        e?.lastUpdated,
        e?.updatedBy
      ]);

  @override
  bool isValidKey(Object? o) => o is TenanciesRecord;
}
