import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PropertiesRecord extends FirestoreRecord {
  PropertiesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "ownerID" field.
  String? _ownerID;
  String get ownerID => _ownerID ?? '';
  bool hasOwnerID() => _ownerID != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "mainPhoto" field.
  String? _mainPhoto;
  String get mainPhoto => _mainPhoto ?? '';
  bool hasMainPhoto() => _mainPhoto != null;

  // "purchasePrice" field.
  double? _purchasePrice;
  double get purchasePrice => _purchasePrice ?? 0.0;
  bool hasPurchasePrice() => _purchasePrice != null;

  // "estimatedValue" field.
  double? _estimatedValue;
  double get estimatedValue => _estimatedValue ?? 0.0;
  bool hasEstimatedValue() => _estimatedValue != null;

  // "rentPCM" field.
  double? _rentPCM;
  double get rentPCM => _rentPCM ?? 0.0;
  bool hasRentPCM() => _rentPCM != null;

  // "purchaseDate" field.
  DateTime? _purchaseDate;
  DateTime? get purchaseDate => _purchaseDate;
  bool hasPurchaseDate() => _purchaseDate != null;

  // "earningsToDate" field.
  double? _earningsToDate;
  double get earningsToDate => _earningsToDate ?? 0.0;
  bool hasEarningsToDate() => _earningsToDate != null;

  // "nextRentReviewDate" field.
  DateTime? _nextRentReviewDate;
  DateTime? get nextRentReviewDate => _nextRentReviewDate;
  bool hasNextRentReviewDate() => _nextRentReviewDate != null;

  // "lastValuationDate" field.
  DateTime? _lastValuationDate;
  DateTime? get lastValuationDate => _lastValuationDate;
  bool hasLastValuationDate() => _lastValuationDate != null;

  // "energyCert" field.
  String? _energyCert;
  String get energyCert => _energyCert ?? '';
  bool hasEnergyCert() => _energyCert != null;

  // "gasCert" field.
  String? _gasCert;
  String get gasCert => _gasCert ?? '';
  bool hasGasCert() => _gasCert != null;

  // "ElecCert" field.
  String? _elecCert;
  String get elecCert => _elecCert ?? '';
  bool hasElecCert() => _elecCert != null;

  // "latLng" field.
  LatLng? _latLng;
  LatLng? get latLng => _latLng;
  bool hasLatLng() => _latLng != null;

  // "gallery" field.
  List<String>? _gallery;
  List<String> get gallery => _gallery ?? const [];
  bool hasGallery() => _gallery != null;

  // "last_updated" field.
  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;
  bool hasLastUpdated() => _lastUpdated != null;

  // "updated_by" field.
  String? _updatedBy;
  String get updatedBy => _updatedBy ?? '';
  bool hasUpdatedBy() => _updatedBy != null;

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

  // "address_county" field.
  String? _addressCounty;
  String get addressCounty => _addressCounty ?? '';
  bool hasAddressCounty() => _addressCounty != null;

  // "address_postcode" field.
  String? _addressPostcode;
  String get addressPostcode => _addressPostcode ?? '';
  bool hasAddressPostcode() => _addressPostcode != null;

  // "address_country" field.
  String? _addressCountry;
  String get addressCountry => _addressCountry ?? '';
  bool hasAddressCountry() => _addressCountry != null;

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

  // "mortgageRemaining" field.
  double? _mortgageRemaining;
  double get mortgageRemaining => _mortgageRemaining ?? 0.0;
  bool hasMortgageRemaining() => _mortgageRemaining != null;

  // "mortgageEntered" field.
  bool? _mortgageEntered;
  bool get mortgageEntered => _mortgageEntered ?? false;
  bool hasMortgageEntered() => _mortgageEntered != null;

  // "previousRentalIncome" field.
  double? _previousRentalIncome;
  double get previousRentalIncome => _previousRentalIncome ?? 0.0;
  bool hasPreviousRentalIncome() => _previousRentalIncome != null;

  // "previousExpenses" field.
  double? _previousExpenses;
  double get previousExpenses => _previousExpenses ?? 0.0;
  bool hasPreviousExpenses() => _previousExpenses != null;

  // "averageYearlyExpenses" field.
  double? _averageYearlyExpenses;
  double get averageYearlyExpenses => _averageYearlyExpenses ?? 0.0;
  bool hasAverageYearlyExpenses() => _averageYearlyExpenses != null;

  // "expenseInflationPct" field.
  double? _expenseInflationPct;
  double get expenseInflationPct => _expenseInflationPct ?? 0.0;
  bool hasExpenseInflationPct() => _expenseInflationPct != null;

  // "mortgageMonthlyPayment" field.
  double? _mortgageMonthlyPayment;
  double get mortgageMonthlyPayment => _mortgageMonthlyPayment ?? 0.0;
  bool hasMortgageMonthlyPayment() => _mortgageMonthlyPayment != null;

  // "mortgageTermRemaining" field.
  int? _mortgageTermRemaining;
  int get mortgageTermRemaining => _mortgageTermRemaining ?? 0;
  bool hasMortgageTermRemaining() => _mortgageTermRemaining != null;

  // "letType" field.
  String? _letType;
  String get letType => _letType ?? '';
  bool hasLetType() => _letType != null;

  // "dateAddedToSystem" field.
  DateTime? _dateAddedToSystem;
  DateTime? get dateAddedToSystem => _dateAddedToSystem;
  bool hasDateAddedToSystem() => _dateAddedToSystem != null;

  // "dateJoinedAddressed" field.
  DateTime? _dateJoinedAddressed;
  DateTime? get dateJoinedAddressed => _dateJoinedAddressed;
  bool hasDateJoinedAddressed() => _dateJoinedAddressed != null;

  void _initializeFields() {
    _ownerID = snapshotData['ownerID'] as String?;
    _title = snapshotData['title'] as String?;
    _mainPhoto = snapshotData['mainPhoto'] as String?;
    _purchasePrice = castToType<double>(snapshotData['purchasePrice']);
    _estimatedValue = castToType<double>(snapshotData['estimatedValue']);
    _rentPCM = castToType<double>(snapshotData['rentPCM']);
    _purchaseDate = snapshotData['purchaseDate'] as DateTime?;
    _earningsToDate = castToType<double>(snapshotData['earningsToDate']);
    _nextRentReviewDate = snapshotData['nextRentReviewDate'] as DateTime?;
    _lastValuationDate = snapshotData['lastValuationDate'] as DateTime?;
    _energyCert = snapshotData['energyCert'] as String?;
    _gasCert = snapshotData['gasCert'] as String?;
    _elecCert = snapshotData['ElecCert'] as String?;
    _latLng = snapshotData['latLng'] as LatLng?;
    _gallery = getDataList(snapshotData['gallery']);
    _lastUpdated = snapshotData['last_updated'] as DateTime?;
    _updatedBy = snapshotData['updated_by'] as String?;
    _addressLine1 = snapshotData['address_line1'] as String?;
    _addressLine2 = snapshotData['address_line2'] as String?;
    _addressLine3 = snapshotData['address_line3'] as String?;
    _addressTown = snapshotData['address_town'] as String?;
    _addressCounty = snapshotData['address_county'] as String?;
    _addressPostcode = snapshotData['address_postcode'] as String?;
    _addressCountry = snapshotData['address_country'] as String?;
    _addressFormatted = snapshotData['address_formatted'] as String?;
    _addressUdprn = snapshotData['address_udprn'] as String?;
    _addressUprn = snapshotData['address_uprn'] as String?;
    _addressSource = snapshotData['address_source'] as String?;
    _addressVerifiedAt = snapshotData['address_verified_at'] as DateTime?;
    _mortgageRemaining = castToType<double>(snapshotData['mortgageRemaining']);
    _mortgageEntered = snapshotData['mortgageEntered'] as bool?;
    _previousRentalIncome =
        castToType<double>(snapshotData['previousRentalIncome']);
    _previousExpenses = castToType<double>(snapshotData['previousExpenses']);
    _averageYearlyExpenses =
        castToType<double>(snapshotData['averageYearlyExpenses']);
    _expenseInflationPct =
        castToType<double>(snapshotData['expenseInflationPct']);
    _mortgageMonthlyPayment =
        castToType<double>(snapshotData['mortgageMonthlyPayment']);
    _mortgageTermRemaining =
        castToType<int>(snapshotData['mortgageTermRemaining']);
    _letType = snapshotData['letType'] as String?;
    _dateAddedToSystem = snapshotData['dateAddedToSystem'] as DateTime?;
    _dateJoinedAddressed = snapshotData['dateJoinedAddressed'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('properties');

  static Stream<PropertiesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PropertiesRecord.fromSnapshot(s));

  static Future<PropertiesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PropertiesRecord.fromSnapshot(s));

  static PropertiesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PropertiesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PropertiesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PropertiesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PropertiesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PropertiesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPropertiesRecordData({
  String? ownerID,
  String? title,
  String? mainPhoto,
  double? purchasePrice,
  double? estimatedValue,
  double? rentPCM,
  DateTime? purchaseDate,
  double? earningsToDate,
  DateTime? nextRentReviewDate,
  DateTime? lastValuationDate,
  String? energyCert,
  String? gasCert,
  String? elecCert,
  LatLng? latLng,
  DateTime? lastUpdated,
  String? updatedBy,
  String? addressLine1,
  String? addressLine2,
  String? addressLine3,
  String? addressTown,
  String? addressCounty,
  String? addressPostcode,
  String? addressCountry,
  String? addressFormatted,
  String? addressUdprn,
  String? addressUprn,
  String? addressSource,
  DateTime? addressVerifiedAt,
  double? mortgageRemaining,
  bool? mortgageEntered,
  double? previousRentalIncome,
  double? previousExpenses,
  double? averageYearlyExpenses,
  double? expenseInflationPct,
  double? mortgageMonthlyPayment,
  int? mortgageTermRemaining,
  String? letType,
  DateTime? dateAddedToSystem,
  DateTime? dateJoinedAddressed,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'ownerID': ownerID,
      'title': title,
      'mainPhoto': mainPhoto,
      'purchasePrice': purchasePrice,
      'estimatedValue': estimatedValue,
      'rentPCM': rentPCM,
      'purchaseDate': purchaseDate,
      'earningsToDate': earningsToDate,
      'nextRentReviewDate': nextRentReviewDate,
      'lastValuationDate': lastValuationDate,
      'energyCert': energyCert,
      'gasCert': gasCert,
      'ElecCert': elecCert,
      'latLng': latLng,
      'last_updated': lastUpdated,
      'updated_by': updatedBy,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'address_line3': addressLine3,
      'address_town': addressTown,
      'address_county': addressCounty,
      'address_postcode': addressPostcode,
      'address_country': addressCountry,
      'address_formatted': addressFormatted,
      'address_udprn': addressUdprn,
      'address_uprn': addressUprn,
      'address_source': addressSource,
      'address_verified_at': addressVerifiedAt,
      'mortgageRemaining': mortgageRemaining,
      'mortgageEntered': mortgageEntered,
      'previousRentalIncome': previousRentalIncome,
      'previousExpenses': previousExpenses,
      'averageYearlyExpenses': averageYearlyExpenses,
      'expenseInflationPct': expenseInflationPct,
      'mortgageMonthlyPayment': mortgageMonthlyPayment,
      'mortgageTermRemaining': mortgageTermRemaining,
      'letType': letType,
      'dateAddedToSystem': dateAddedToSystem,
      'dateJoinedAddressed': dateJoinedAddressed,
    }.withoutNulls,
  );

  return firestoreData;
}

class PropertiesRecordDocumentEquality implements Equality<PropertiesRecord> {
  const PropertiesRecordDocumentEquality();

  @override
  bool equals(PropertiesRecord? e1, PropertiesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.ownerID == e2?.ownerID &&
        e1?.title == e2?.title &&
        e1?.mainPhoto == e2?.mainPhoto &&
        e1?.purchasePrice == e2?.purchasePrice &&
        e1?.estimatedValue == e2?.estimatedValue &&
        e1?.rentPCM == e2?.rentPCM &&
        e1?.purchaseDate == e2?.purchaseDate &&
        e1?.earningsToDate == e2?.earningsToDate &&
        e1?.nextRentReviewDate == e2?.nextRentReviewDate &&
        e1?.lastValuationDate == e2?.lastValuationDate &&
        e1?.energyCert == e2?.energyCert &&
        e1?.gasCert == e2?.gasCert &&
        e1?.elecCert == e2?.elecCert &&
        e1?.latLng == e2?.latLng &&
        listEquality.equals(e1?.gallery, e2?.gallery) &&
        e1?.lastUpdated == e2?.lastUpdated &&
        e1?.updatedBy == e2?.updatedBy &&
        e1?.addressLine1 == e2?.addressLine1 &&
        e1?.addressLine2 == e2?.addressLine2 &&
        e1?.addressLine3 == e2?.addressLine3 &&
        e1?.addressTown == e2?.addressTown &&
        e1?.addressCounty == e2?.addressCounty &&
        e1?.addressPostcode == e2?.addressPostcode &&
        e1?.addressCountry == e2?.addressCountry &&
        e1?.addressFormatted == e2?.addressFormatted &&
        e1?.addressUdprn == e2?.addressUdprn &&
        e1?.addressUprn == e2?.addressUprn &&
        e1?.addressSource == e2?.addressSource &&
        e1?.addressVerifiedAt == e2?.addressVerifiedAt &&
        e1?.mortgageRemaining == e2?.mortgageRemaining &&
        e1?.mortgageEntered == e2?.mortgageEntered &&
        e1?.previousRentalIncome == e2?.previousRentalIncome &&
        e1?.previousExpenses == e2?.previousExpenses &&
        e1?.averageYearlyExpenses == e2?.averageYearlyExpenses &&
        e1?.expenseInflationPct == e2?.expenseInflationPct &&
        e1?.mortgageMonthlyPayment == e2?.mortgageMonthlyPayment &&
        e1?.mortgageTermRemaining == e2?.mortgageTermRemaining &&
        e1?.letType == e2?.letType &&
        e1?.dateAddedToSystem == e2?.dateAddedToSystem &&
        e1?.dateJoinedAddressed == e2?.dateJoinedAddressed;
  }

  @override
  int hash(PropertiesRecord? e) => const ListEquality().hash([
        e?.ownerID,
        e?.title,
        e?.mainPhoto,
        e?.purchasePrice,
        e?.estimatedValue,
        e?.rentPCM,
        e?.purchaseDate,
        e?.earningsToDate,
        e?.nextRentReviewDate,
        e?.lastValuationDate,
        e?.energyCert,
        e?.gasCert,
        e?.elecCert,
        e?.latLng,
        e?.gallery,
        e?.lastUpdated,
        e?.updatedBy,
        e?.addressLine1,
        e?.addressLine2,
        e?.addressLine3,
        e?.addressTown,
        e?.addressCounty,
        e?.addressPostcode,
        e?.addressCountry,
        e?.addressFormatted,
        e?.addressUdprn,
        e?.addressUprn,
        e?.addressSource,
        e?.addressVerifiedAt,
        e?.mortgageRemaining,
        e?.mortgageEntered,
        e?.previousRentalIncome,
        e?.previousExpenses,
        e?.averageYearlyExpenses,
        e?.expenseInflationPct,
        e?.mortgageMonthlyPayment,
        e?.mortgageTermRemaining,
        e?.letType,
        e?.dateAddedToSystem,
        e?.dateJoinedAddressed
      ]);

  @override
  bool isValidKey(Object? o) => o is PropertiesRecord;
}
