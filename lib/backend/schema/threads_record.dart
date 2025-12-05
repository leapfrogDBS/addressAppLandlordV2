import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ThreadsRecord extends FirestoreRecord {
  ThreadsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "landlordId" field.
  String? _landlordId;
  String get landlordId => _landlordId ?? '';
  bool hasLandlordId() => _landlordId != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "lastMessageText" field.
  String? _lastMessageText;
  String get lastMessageText => _lastMessageText ?? '';
  bool hasLastMessageText() => _lastMessageText != null;

  // "lastMessageAt" field.
  DateTime? _lastMessageAt;
  DateTime? get lastMessageAt => _lastMessageAt;
  bool hasLastMessageAt() => _lastMessageAt != null;

  // "lastMessageSenderId" field.
  String? _lastMessageSenderId;
  String get lastMessageSenderId => _lastMessageSenderId ?? '';
  bool hasLastMessageSenderId() => _lastMessageSenderId != null;

  // "landlordLastReadAt" field.
  DateTime? _landlordLastReadAt;
  DateTime? get landlordLastReadAt => _landlordLastReadAt;
  bool hasLandlordLastReadAt() => _landlordLastReadAt != null;

  // "adminLastReadAt" field.
  DateTime? _adminLastReadAt;
  DateTime? get adminLastReadAt => _adminLastReadAt;
  bool hasAdminLastReadAt() => _adminLastReadAt != null;

  // "landlordName" field.
  String? _landlordName;
  String get landlordName => _landlordName ?? '';
  bool hasLandlordName() => _landlordName != null;

  // "landlordPhotoUrl" field.
  String? _landlordPhotoUrl;
  String get landlordPhotoUrl => _landlordPhotoUrl ?? '';
  bool hasLandlordPhotoUrl() => _landlordPhotoUrl != null;

  // "lastMessageRef" field.
  DocumentReference? _lastMessageRef;
  DocumentReference? get lastMessageRef => _lastMessageRef;
  bool hasLastMessageRef() => _lastMessageRef != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "messagesSent" field.
  bool? _messagesSent;
  bool get messagesSent => _messagesSent ?? false;
  bool hasMessagesSent() => _messagesSent != null;

  // "adminHasUnread" field.
  bool? _adminHasUnread;
  bool get adminHasUnread => _adminHasUnread ?? false;
  bool hasAdminHasUnread() => _adminHasUnread != null;

  void _initializeFields() {
    _landlordId = snapshotData['landlordId'] as String?;
    _status = snapshotData['status'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _lastMessageText = snapshotData['lastMessageText'] as String?;
    _lastMessageAt = snapshotData['lastMessageAt'] as DateTime?;
    _lastMessageSenderId = snapshotData['lastMessageSenderId'] as String?;
    _landlordLastReadAt = snapshotData['landlordLastReadAt'] as DateTime?;
    _adminLastReadAt = snapshotData['adminLastReadAt'] as DateTime?;
    _landlordName = snapshotData['landlordName'] as String?;
    _landlordPhotoUrl = snapshotData['landlordPhotoUrl'] as String?;
    _lastMessageRef = snapshotData['lastMessageRef'] as DocumentReference?;
    _title = snapshotData['title'] as String?;
    _messagesSent = snapshotData['messagesSent'] as bool?;
    _adminHasUnread = snapshotData['adminHasUnread'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('threads');

  static Stream<ThreadsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ThreadsRecord.fromSnapshot(s));

  static Future<ThreadsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ThreadsRecord.fromSnapshot(s));

  static ThreadsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ThreadsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ThreadsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ThreadsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ThreadsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ThreadsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createThreadsRecordData({
  String? landlordId,
  String? status,
  DateTime? createdAt,
  String? lastMessageText,
  DateTime? lastMessageAt,
  String? lastMessageSenderId,
  DateTime? landlordLastReadAt,
  DateTime? adminLastReadAt,
  String? landlordName,
  String? landlordPhotoUrl,
  DocumentReference? lastMessageRef,
  String? title,
  bool? messagesSent,
  bool? adminHasUnread,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'landlordId': landlordId,
      'status': status,
      'createdAt': createdAt,
      'lastMessageText': lastMessageText,
      'lastMessageAt': lastMessageAt,
      'lastMessageSenderId': lastMessageSenderId,
      'landlordLastReadAt': landlordLastReadAt,
      'adminLastReadAt': adminLastReadAt,
      'landlordName': landlordName,
      'landlordPhotoUrl': landlordPhotoUrl,
      'lastMessageRef': lastMessageRef,
      'title': title,
      'messagesSent': messagesSent,
      'adminHasUnread': adminHasUnread,
    }.withoutNulls,
  );

  return firestoreData;
}

class ThreadsRecordDocumentEquality implements Equality<ThreadsRecord> {
  const ThreadsRecordDocumentEquality();

  @override
  bool equals(ThreadsRecord? e1, ThreadsRecord? e2) {
    return e1?.landlordId == e2?.landlordId &&
        e1?.status == e2?.status &&
        e1?.createdAt == e2?.createdAt &&
        e1?.lastMessageText == e2?.lastMessageText &&
        e1?.lastMessageAt == e2?.lastMessageAt &&
        e1?.lastMessageSenderId == e2?.lastMessageSenderId &&
        e1?.landlordLastReadAt == e2?.landlordLastReadAt &&
        e1?.adminLastReadAt == e2?.adminLastReadAt &&
        e1?.landlordName == e2?.landlordName &&
        e1?.landlordPhotoUrl == e2?.landlordPhotoUrl &&
        e1?.lastMessageRef == e2?.lastMessageRef &&
        e1?.title == e2?.title &&
        e1?.messagesSent == e2?.messagesSent &&
        e1?.adminHasUnread == e2?.adminHasUnread;
  }

  @override
  int hash(ThreadsRecord? e) => const ListEquality().hash([
        e?.landlordId,
        e?.status,
        e?.createdAt,
        e?.lastMessageText,
        e?.lastMessageAt,
        e?.lastMessageSenderId,
        e?.landlordLastReadAt,
        e?.adminLastReadAt,
        e?.landlordName,
        e?.landlordPhotoUrl,
        e?.lastMessageRef,
        e?.title,
        e?.messagesSent,
        e?.adminHasUnread
      ]);

  @override
  bool isValidKey(Object? o) => o is ThreadsRecord;
}
