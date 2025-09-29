import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EventsRecord extends FirestoreRecord {
  EventsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "startDate" field.
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  bool hasStartDate() => _startDate != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "propertyRef" field.
  DocumentReference? _propertyRef;
  DocumentReference? get propertyRef => _propertyRef;
  bool hasPropertyRef() => _propertyRef != null;

  // "tenancyRef" field.
  DocumentReference? _tenancyRef;
  DocumentReference? get tenancyRef => _tenancyRef;
  bool hasTenancyRef() => _tenancyRef != null;

  // "amount" field.
  int? _amount;
  int get amount => _amount ?? 0;
  bool hasAmount() => _amount != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "createdByUid" field.
  String? _createdByUid;
  String get createdByUid => _createdByUid ?? '';
  bool hasCreatedByUid() => _createdByUid != null;

  // "createdByRef" field.
  DocumentReference? _createdByRef;
  DocumentReference? get createdByRef => _createdByRef;
  bool hasCreatedByRef() => _createdByRef != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _type = snapshotData['type'] as String?;
    _startDate = snapshotData['startDate'] as DateTime?;
    _status = snapshotData['status'] as String?;
    _propertyRef = snapshotData['propertyRef'] as DocumentReference?;
    _tenancyRef = snapshotData['tenancyRef'] as DocumentReference?;
    _amount = castToType<int>(snapshotData['amount']);
    _notes = snapshotData['notes'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _createdByUid = snapshotData['createdByUid'] as String?;
    _createdByRef = snapshotData['createdByRef'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('events');

  static Stream<EventsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EventsRecord.fromSnapshot(s));

  static Future<EventsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EventsRecord.fromSnapshot(s));

  static EventsRecord fromSnapshot(DocumentSnapshot snapshot) => EventsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EventsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EventsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EventsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EventsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEventsRecordData({
  String? title,
  String? type,
  DateTime? startDate,
  String? status,
  DocumentReference? propertyRef,
  DocumentReference? tenancyRef,
  int? amount,
  String? notes,
  DateTime? createdAt,
  String? createdByUid,
  DocumentReference? createdByRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'type': type,
      'startDate': startDate,
      'status': status,
      'propertyRef': propertyRef,
      'tenancyRef': tenancyRef,
      'amount': amount,
      'notes': notes,
      'createdAt': createdAt,
      'createdByUid': createdByUid,
      'createdByRef': createdByRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class EventsRecordDocumentEquality implements Equality<EventsRecord> {
  const EventsRecordDocumentEquality();

  @override
  bool equals(EventsRecord? e1, EventsRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.type == e2?.type &&
        e1?.startDate == e2?.startDate &&
        e1?.status == e2?.status &&
        e1?.propertyRef == e2?.propertyRef &&
        e1?.tenancyRef == e2?.tenancyRef &&
        e1?.amount == e2?.amount &&
        e1?.notes == e2?.notes &&
        e1?.createdAt == e2?.createdAt &&
        e1?.createdByUid == e2?.createdByUid &&
        e1?.createdByRef == e2?.createdByRef;
  }

  @override
  int hash(EventsRecord? e) => const ListEquality().hash([
        e?.title,
        e?.type,
        e?.startDate,
        e?.status,
        e?.propertyRef,
        e?.tenancyRef,
        e?.amount,
        e?.notes,
        e?.createdAt,
        e?.createdByUid,
        e?.createdByRef
      ]);

  @override
  bool isValidKey(Object? o) => o is EventsRecord;
}
