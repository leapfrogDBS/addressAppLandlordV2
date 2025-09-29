import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EmailRecord extends FirestoreRecord {
  EmailRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "message" field.
  MessageStruct? _message;
  MessageStruct get message => _message ?? MessageStruct();
  bool hasMessage() => _message != null;

  // "to" field.
  String? _to;
  String get to => _to ?? '';
  bool hasTo() => _to != null;

  // "toUids" field.
  List<String>? _toUids;
  List<String> get toUids => _toUids ?? const [];
  bool hasToUids() => _toUids != null;

  void _initializeFields() {
    _message = snapshotData['message'] is MessageStruct
        ? snapshotData['message']
        : MessageStruct.maybeFromMap(snapshotData['message']);
    _to = snapshotData['to'] as String?;
    _toUids = getDataList(snapshotData['toUids']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('email');

  static Stream<EmailRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EmailRecord.fromSnapshot(s));

  static Future<EmailRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EmailRecord.fromSnapshot(s));

  static EmailRecord fromSnapshot(DocumentSnapshot snapshot) => EmailRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EmailRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EmailRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EmailRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EmailRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEmailRecordData({
  MessageStruct? message,
  String? to,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'message': MessageStruct().toMap(),
      'to': to,
    }.withoutNulls,
  );

  // Handle nested data for "message" field.
  addMessageStructData(firestoreData, message, 'message');

  return firestoreData;
}

class EmailRecordDocumentEquality implements Equality<EmailRecord> {
  const EmailRecordDocumentEquality();

  @override
  bool equals(EmailRecord? e1, EmailRecord? e2) {
    const listEquality = ListEquality();
    return e1?.message == e2?.message &&
        e1?.to == e2?.to &&
        listEquality.equals(e1?.toUids, e2?.toUids);
  }

  @override
  int hash(EmailRecord? e) =>
      const ListEquality().hash([e?.message, e?.to, e?.toUids]);

  @override
  bool isValidKey(Object? o) => o is EmailRecord;
}
