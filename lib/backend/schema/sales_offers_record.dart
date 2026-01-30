import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SalesOffersRecord extends FirestoreRecord {
  SalesOffersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "mainPhoto" field.
  String? _mainPhoto;
  String get mainPhoto => _mainPhoto ?? '';
  bool hasMainPhoto() => _mainPhoto != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  // "last_updated" field.
  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;
  bool hasLastUpdated() => _lastUpdated != null;

  // "address_line1" field.
  String? _addressLine1;
  String get addressLine1 => _addressLine1 ?? '';
  bool hasAddressLine1() => _addressLine1 != null;

  // "address_line2" field.
  String? _addressLine2;
  String get addressLine2 => _addressLine2 ?? '';
  bool hasAddressLine2() => _addressLine2 != null;

  // "address_line3" field.
  String? _addressLine3;
  String get addressLine3 => _addressLine3 ?? '';
  bool hasAddressLine3() => _addressLine3 != null;

  // "address_town" field.
  String? _addressTown;
  String get addressTown => _addressTown ?? '';
  bool hasAddressTown() => _addressTown != null;

  // "address_postcode" field.
  String? _addressPostcode;
  String get addressPostcode => _addressPostcode ?? '';
  bool hasAddressPostcode() => _addressPostcode != null;

  // "address_country" field.
  String? _addressCountry;
  String get addressCountry => _addressCountry ?? '';
  bool hasAddressCountry() => _addressCountry != null;

  // "address_county" field.
  String? _addressCounty;
  String get addressCounty => _addressCounty ?? '';
  bool hasAddressCounty() => _addressCounty != null;

  // "address_formatted" field.
  String? _addressFormatted;
  String get addressFormatted => _addressFormatted ?? '';
  bool hasAddressFormatted() => _addressFormatted != null;

  // "address_udprn" field.
  String? _addressUdprn;
  String get addressUdprn => _addressUdprn ?? '';
  bool hasAddressUdprn() => _addressUdprn != null;

  // "address_uprn" field.
  String? _addressUprn;
  String get addressUprn => _addressUprn ?? '';
  bool hasAddressUprn() => _addressUprn != null;

  // "address_source" field.
  String? _addressSource;
  String get addressSource => _addressSource ?? '';
  bool hasAddressSource() => _addressSource != null;

  // "address_verified_at" field.
  DateTime? _addressVerifiedAt;
  DateTime? get addressVerifiedAt => _addressVerifiedAt;
  bool hasAddressVerifiedAt() => _addressVerifiedAt != null;

  // "updated_by" field.
  String? _updatedBy;
  String get updatedBy => _updatedBy ?? '';
  bool hasUpdatedBy() => _updatedBy != null;

  // "latLng" field.
  LatLng? _latLng;
  LatLng? get latLng => _latLng;
  bool hasLatLng() => _latLng != null;

  // "gallery" field.
  List<String>? _gallery;
  List<String> get gallery => _gallery ?? const [];
  bool hasGallery() => _gallery != null;

  // "monthlyRental" field.
  double? _monthlyRental;
  double get monthlyRental => _monthlyRental ?? 0.0;
  bool hasMonthlyRental() => _monthlyRental != null;

  // "noOfBedrooms" field.
  int? _noOfBedrooms;
  int get noOfBedrooms => _noOfBedrooms ?? 0;
  bool hasNoOfBedrooms() => _noOfBedrooms != null;

  // "estimatedYearlyExpenses" field.
  double? _estimatedYearlyExpenses;
  double get estimatedYearlyExpenses => _estimatedYearlyExpenses ?? 0.0;
  bool hasEstimatedYearlyExpenses() => _estimatedYearlyExpenses != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _mainPhoto = snapshotData['mainPhoto'] as String?;
    _price = castToType<double>(snapshotData['price']);
    _status = snapshotData['status'] as String?;
    _notes = snapshotData['notes'] as String?;
    _lastUpdated = snapshotData['last_updated'] as DateTime?;
    _addressLine1 = snapshotData['address_line1'] as String?;
    _addressLine2 = snapshotData['address_line2'] as String?;
    _addressLine3 = snapshotData['address_line3'] as String?;
    _addressTown = snapshotData['address_town'] as String?;
    _addressPostcode = snapshotData['address_postcode'] as String?;
    _addressCountry = snapshotData['address_country'] as String?;
    _addressCounty = snapshotData['address_county'] as String?;
    _addressFormatted = snapshotData['address_formatted'] as String?;
    _addressUdprn = snapshotData['address_udprn'] as String?;
    _addressUprn = snapshotData['address_uprn'] as String?;
    _addressSource = snapshotData['address_source'] as String?;
    _addressVerifiedAt = snapshotData['address_verified_at'] as DateTime?;
    _updatedBy = snapshotData['updated_by'] as String?;
    _latLng = snapshotData['latLng'] as LatLng?;
    _gallery = getDataList(snapshotData['gallery']);
    _monthlyRental = castToType<double>(snapshotData['monthlyRental']);
    _noOfBedrooms = castToType<int>(snapshotData['noOfBedrooms']);
    _estimatedYearlyExpenses =
        castToType<double>(snapshotData['estimatedYearlyExpenses']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('salesOffers');

  static Stream<SalesOffersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SalesOffersRecord.fromSnapshot(s));

  static Future<SalesOffersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SalesOffersRecord.fromSnapshot(s));

  static SalesOffersRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SalesOffersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SalesOffersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SalesOffersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SalesOffersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SalesOffersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSalesOffersRecordData({
  String? title,
  String? mainPhoto,
  double? price,
  String? status,
  String? notes,
  DateTime? lastUpdated,
  String? addressLine1,
  String? addressLine2,
  String? addressLine3,
  String? addressTown,
  String? addressPostcode,
  String? addressCountry,
  String? addressCounty,
  String? addressFormatted,
  String? addressUdprn,
  String? addressUprn,
  String? addressSource,
  DateTime? addressVerifiedAt,
  String? updatedBy,
  LatLng? latLng,
  double? monthlyRental,
  int? noOfBedrooms,
  double? estimatedYearlyExpenses,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'mainPhoto': mainPhoto,
      'price': price,
      'status': status,
      'notes': notes,
      'last_updated': lastUpdated,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'address_line3': addressLine3,
      'address_town': addressTown,
      'address_postcode': addressPostcode,
      'address_country': addressCountry,
      'address_county': addressCounty,
      'address_formatted': addressFormatted,
      'address_udprn': addressUdprn,
      'address_uprn': addressUprn,
      'address_source': addressSource,
      'address_verified_at': addressVerifiedAt,
      'updated_by': updatedBy,
      'latLng': latLng,
      'monthlyRental': monthlyRental,
      'noOfBedrooms': noOfBedrooms,
      'estimatedYearlyExpenses': estimatedYearlyExpenses,
    }.withoutNulls,
  );

  return firestoreData;
}

class SalesOffersRecordDocumentEquality implements Equality<SalesOffersRecord> {
  const SalesOffersRecordDocumentEquality();

  @override
  bool equals(SalesOffersRecord? e1, SalesOffersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.title == e2?.title &&
        e1?.mainPhoto == e2?.mainPhoto &&
        e1?.price == e2?.price &&
        e1?.status == e2?.status &&
        e1?.notes == e2?.notes &&
        e1?.lastUpdated == e2?.lastUpdated &&
        e1?.addressLine1 == e2?.addressLine1 &&
        e1?.addressLine2 == e2?.addressLine2 &&
        e1?.addressLine3 == e2?.addressLine3 &&
        e1?.addressTown == e2?.addressTown &&
        e1?.addressPostcode == e2?.addressPostcode &&
        e1?.addressCountry == e2?.addressCountry &&
        e1?.addressCounty == e2?.addressCounty &&
        e1?.addressFormatted == e2?.addressFormatted &&
        e1?.addressUdprn == e2?.addressUdprn &&
        e1?.addressUprn == e2?.addressUprn &&
        e1?.addressSource == e2?.addressSource &&
        e1?.addressVerifiedAt == e2?.addressVerifiedAt &&
        e1?.updatedBy == e2?.updatedBy &&
        e1?.latLng == e2?.latLng &&
        listEquality.equals(e1?.gallery, e2?.gallery) &&
        e1?.monthlyRental == e2?.monthlyRental &&
        e1?.noOfBedrooms == e2?.noOfBedrooms &&
        e1?.estimatedYearlyExpenses == e2?.estimatedYearlyExpenses;
  }

  @override
  int hash(SalesOffersRecord? e) => const ListEquality().hash([
        e?.title,
        e?.mainPhoto,
        e?.price,
        e?.status,
        e?.notes,
        e?.lastUpdated,
        e?.addressLine1,
        e?.addressLine2,
        e?.addressLine3,
        e?.addressTown,
        e?.addressPostcode,
        e?.addressCountry,
        e?.addressCounty,
        e?.addressFormatted,
        e?.addressUdprn,
        e?.addressUprn,
        e?.addressSource,
        e?.addressVerifiedAt,
        e?.updatedBy,
        e?.latLng,
        e?.gallery,
        e?.monthlyRental,
        e?.noOfBedrooms,
        e?.estimatedYearlyExpenses
      ]);

  @override
  bool isValidKey(Object? o) => o is SalesOffersRecord;
}
