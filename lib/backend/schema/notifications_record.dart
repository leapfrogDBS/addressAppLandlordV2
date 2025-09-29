import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsRecord extends FirestoreRecord {
  NotificationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "body" field.
  String? _body;
  String get body => _body ?? '';
  bool hasBody() => _body != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "icon" field.
  String? _icon;
  String get icon => _icon ?? '';
  bool hasIcon() => _icon != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "readAt" field.
  DateTime? _readAt;
  DateTime? get readAt => _readAt;
  bool hasReadAt() => _readAt != null;

  // "linkType" field.
  String? _linkType;
  String get linkType => _linkType ?? '';
  bool hasLinkType() => _linkType != null;

  // "linkRef" field.
  String? _linkRef;
  String get linkRef => _linkRef ?? '';
  bool hasLinkRef() => _linkRef != null;

  // "priority" field.
  String? _priority;
  String get priority => _priority ?? '';
  bool hasPriority() => _priority != null;

  // "collapseKey" field.
  String? _collapseKey;
  String get collapseKey => _collapseKey ?? '';
  bool hasCollapseKey() => _collapseKey != null;

  // "viewed" field.
  bool? _viewed;
  bool get viewed => _viewed ?? false;
  bool hasViewed() => _viewed != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _body = snapshotData['body'] as String?;
    _type = snapshotData['type'] as String?;
    _icon = snapshotData['icon'] as String?;
    _imageUrl = snapshotData['imageUrl'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _readAt = snapshotData['readAt'] as DateTime?;
    _linkType = snapshotData['linkType'] as String?;
    _linkRef = snapshotData['linkRef'] as String?;
    _priority = snapshotData['priority'] as String?;
    _collapseKey = snapshotData['collapseKey'] as String?;
    _viewed = snapshotData['viewed'] as bool?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('notifications')
          : FirebaseFirestore.instance.collectionGroup('notifications');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('notifications').doc(id);

  static Stream<NotificationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationsRecord.fromSnapshot(s));

  static Future<NotificationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationsRecord.fromSnapshot(s));

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotificationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotificationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  String? title,
  String? body,
  String? type,
  String? icon,
  String? imageUrl,
  DateTime? createdAt,
  DateTime? readAt,
  String? linkType,
  String? linkRef,
  String? priority,
  String? collapseKey,
  bool? viewed,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'body': body,
      'type': type,
      'icon': icon,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'readAt': readAt,
      'linkType': linkType,
      'linkRef': linkRef,
      'priority': priority,
      'collapseKey': collapseKey,
      'viewed': viewed,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.body == e2?.body &&
        e1?.type == e2?.type &&
        e1?.icon == e2?.icon &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.createdAt == e2?.createdAt &&
        e1?.readAt == e2?.readAt &&
        e1?.linkType == e2?.linkType &&
        e1?.linkRef == e2?.linkRef &&
        e1?.priority == e2?.priority &&
        e1?.collapseKey == e2?.collapseKey &&
        e1?.viewed == e2?.viewed;
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality().hash([
        e?.title,
        e?.body,
        e?.type,
        e?.icon,
        e?.imageUrl,
        e?.createdAt,
        e?.readAt,
        e?.linkType,
        e?.linkRef,
        e?.priority,
        e?.collapseKey,
        e?.viewed
      ]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
