import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InviteTokensRecord extends FirestoreRecord {
  InviteTokensRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "expiresAt" field.
  DateTime? _expiresAt;
  DateTime? get expiresAt => _expiresAt;
  bool hasExpiresAt() => _expiresAt != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _uid = snapshotData['uid'] as String?;
    _email = snapshotData['email'] as String?;
    _expiresAt = snapshotData['expiresAt'] as DateTime?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('inviteTokens');

  static Stream<InviteTokensRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => InviteTokensRecord.fromSnapshot(s));

  static Future<InviteTokensRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => InviteTokensRecord.fromSnapshot(s));

  static InviteTokensRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InviteTokensRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static InviteTokensRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      InviteTokensRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'InviteTokensRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is InviteTokensRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createInviteTokensRecordData({
  String? uid,
  String? email,
  DateTime? expiresAt,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'email': email,
      'expiresAt': expiresAt,
      'createdAt': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class InviteTokensRecordDocumentEquality
    implements Equality<InviteTokensRecord> {
  const InviteTokensRecordDocumentEquality();

  @override
  bool equals(InviteTokensRecord? e1, InviteTokensRecord? e2) {
    return e1?.uid == e2?.uid &&
        e1?.email == e2?.email &&
        e1?.expiresAt == e2?.expiresAt &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(InviteTokensRecord? e) =>
      const ListEquality().hash([e?.uid, e?.email, e?.expiresAt, e?.createdAt]);

  @override
  bool isValidKey(Object? o) => o is InviteTokensRecord;
}
