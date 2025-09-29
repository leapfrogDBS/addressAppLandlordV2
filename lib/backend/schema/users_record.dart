import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "last_active" field.
  DateTime? _lastActive;
  DateTime? get lastActive => _lastActive;
  bool hasLastActive() => _lastActive != null;

  // "isAdmin" field.
  bool? _isAdmin;
  bool get isAdmin => _isAdmin ?? false;
  bool hasIsAdmin() => _isAdmin != null;

  // "has_signed_agreement" field.
  bool? _hasSignedAgreement;
  bool get hasSignedAgreement => _hasSignedAgreement ?? false;
  bool hasHasSignedAgreement() => _hasSignedAgreement != null;

  // "entered_retirment_targets" field.
  bool? _enteredRetirmentTargets;
  bool get enteredRetirmentTargets => _enteredRetirmentTargets ?? false;
  bool hasEnteredRetirmentTargets() => _enteredRetirmentTargets != null;

  // "dob" field.
  DateTime? _dob;
  DateTime? get dob => _dob;
  bool hasDob() => _dob != null;

  // "planned_retirement_age" field.
  int? _plannedRetirementAge;
  int get plannedRetirementAge => _plannedRetirementAge ?? 0;
  bool hasPlannedRetirementAge() => _plannedRetirementAge != null;

  // "target_equity" field.
  int? _targetEquity;
  int get targetEquity => _targetEquity ?? 0;
  bool hasTargetEquity() => _targetEquity != null;

  // "target_income" field.
  int? _targetIncome;
  int get targetIncome => _targetIncome ?? 0;
  bool hasTargetIncome() => _targetIncome != null;

  // "last_updated" field.
  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;
  bool hasLastUpdated() => _lastUpdated != null;

  // "updated_by" field.
  String? _updatedBy;
  String get updatedBy => _updatedBy ?? '';
  bool hasUpdatedBy() => _updatedBy != null;

  // "job_title" field.
  String? _jobTitle;
  String get jobTitle => _jobTitle ?? '';
  bool hasJobTitle() => _jobTitle != null;

  // "requestedDeletion" field.
  bool? _requestedDeletion;
  bool get requestedDeletion => _requestedDeletion ?? false;
  bool hasRequestedDeletion() => _requestedDeletion != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "portfolioRating" field.
  int? _portfolioRating;
  int get portfolioRating => _portfolioRating ?? 0;
  bool hasPortfolioRating() => _portfolioRating != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _lastActive = snapshotData['last_active'] as DateTime?;
    _isAdmin = snapshotData['isAdmin'] as bool?;
    _hasSignedAgreement = snapshotData['has_signed_agreement'] as bool?;
    _enteredRetirmentTargets =
        snapshotData['entered_retirment_targets'] as bool?;
    _dob = snapshotData['dob'] as DateTime?;
    _plannedRetirementAge =
        castToType<int>(snapshotData['planned_retirement_age']);
    _targetEquity = castToType<int>(snapshotData['target_equity']);
    _targetIncome = castToType<int>(snapshotData['target_income']);
    _lastUpdated = snapshotData['last_updated'] as DateTime?;
    _updatedBy = snapshotData['updated_by'] as String?;
    _jobTitle = snapshotData['job_title'] as String?;
    _requestedDeletion = snapshotData['requestedDeletion'] as bool?;
    _status = snapshotData['status'] as String?;
    _portfolioRating = castToType<int>(snapshotData['portfolioRating']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  DateTime? lastActive,
  bool? isAdmin,
  bool? hasSignedAgreement,
  bool? enteredRetirmentTargets,
  DateTime? dob,
  int? plannedRetirementAge,
  int? targetEquity,
  int? targetIncome,
  DateTime? lastUpdated,
  String? updatedBy,
  String? jobTitle,
  bool? requestedDeletion,
  String? status,
  int? portfolioRating,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'last_active': lastActive,
      'isAdmin': isAdmin,
      'has_signed_agreement': hasSignedAgreement,
      'entered_retirment_targets': enteredRetirmentTargets,
      'dob': dob,
      'planned_retirement_age': plannedRetirementAge,
      'target_equity': targetEquity,
      'target_income': targetIncome,
      'last_updated': lastUpdated,
      'updated_by': updatedBy,
      'job_title': jobTitle,
      'requestedDeletion': requestedDeletion,
      'status': status,
      'portfolioRating': portfolioRating,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.lastActive == e2?.lastActive &&
        e1?.isAdmin == e2?.isAdmin &&
        e1?.hasSignedAgreement == e2?.hasSignedAgreement &&
        e1?.enteredRetirmentTargets == e2?.enteredRetirmentTargets &&
        e1?.dob == e2?.dob &&
        e1?.plannedRetirementAge == e2?.plannedRetirementAge &&
        e1?.targetEquity == e2?.targetEquity &&
        e1?.targetIncome == e2?.targetIncome &&
        e1?.lastUpdated == e2?.lastUpdated &&
        e1?.updatedBy == e2?.updatedBy &&
        e1?.jobTitle == e2?.jobTitle &&
        e1?.requestedDeletion == e2?.requestedDeletion &&
        e1?.status == e2?.status &&
        e1?.portfolioRating == e2?.portfolioRating;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.lastActive,
        e?.isAdmin,
        e?.hasSignedAgreement,
        e?.enteredRetirmentTargets,
        e?.dob,
        e?.plannedRetirementAge,
        e?.targetEquity,
        e?.targetIncome,
        e?.lastUpdated,
        e?.updatedBy,
        e?.jobTitle,
        e?.requestedDeletion,
        e?.status,
        e?.portfolioRating
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
