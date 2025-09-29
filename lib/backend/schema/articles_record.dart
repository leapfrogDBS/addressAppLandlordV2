import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ArticlesRecord extends FirestoreRecord {
  ArticlesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  bool hasContent() => _content != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  void _initializeFields() {
    _content = snapshotData['content'] as String?;
    _title = snapshotData['title'] as String?;
    _image = snapshotData['image'] as String?;
    _date = snapshotData['date'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('articles');

  static Stream<ArticlesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ArticlesRecord.fromSnapshot(s));

  static Future<ArticlesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ArticlesRecord.fromSnapshot(s));

  static ArticlesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ArticlesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ArticlesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ArticlesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ArticlesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ArticlesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createArticlesRecordData({
  String? content,
  String? title,
  String? image,
  DateTime? date,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'content': content,
      'title': title,
      'image': image,
      'date': date,
    }.withoutNulls,
  );

  return firestoreData;
}

class ArticlesRecordDocumentEquality implements Equality<ArticlesRecord> {
  const ArticlesRecordDocumentEquality();

  @override
  bool equals(ArticlesRecord? e1, ArticlesRecord? e2) {
    return e1?.content == e2?.content &&
        e1?.title == e2?.title &&
        e1?.image == e2?.image &&
        e1?.date == e2?.date;
  }

  @override
  int hash(ArticlesRecord? e) =>
      const ListEquality().hash([e?.content, e?.title, e?.image, e?.date]);

  @override
  bool isValidKey(Object? o) => o is ArticlesRecord;
}
