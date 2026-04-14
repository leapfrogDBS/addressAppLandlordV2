// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SalesOfferAtRetirementStruct extends FFFirebaseStruct {
  SalesOfferAtRetirementStruct({
    double? newCapitalValue,
    double? capitalValueIncrease,
    double? newAnnualRent,
    double? annualRentIncrease,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _newCapitalValue = newCapitalValue,
        _capitalValueIncrease = capitalValueIncrease,
        _newAnnualRent = newAnnualRent,
        _annualRentIncrease = annualRentIncrease,
        super(firestoreUtilData);

  // "newCapitalValue" field.
  double? _newCapitalValue;
  double get newCapitalValue => _newCapitalValue ?? 0.0;
  set newCapitalValue(double? val) => _newCapitalValue = val;

  void incrementNewCapitalValue(double amount) =>
      newCapitalValue = newCapitalValue + amount;

  bool hasNewCapitalValue() => _newCapitalValue != null;

  // "capitalValueIncrease" field.
  double? _capitalValueIncrease;
  double get capitalValueIncrease => _capitalValueIncrease ?? 0.0;
  set capitalValueIncrease(double? val) => _capitalValueIncrease = val;

  void incrementCapitalValueIncrease(double amount) =>
      capitalValueIncrease = capitalValueIncrease + amount;

  bool hasCapitalValueIncrease() => _capitalValueIncrease != null;

  // "newAnnualRent" field.
  double? _newAnnualRent;
  double get newAnnualRent => _newAnnualRent ?? 0.0;
  set newAnnualRent(double? val) => _newAnnualRent = val;

  void incrementNewAnnualRent(double amount) =>
      newAnnualRent = newAnnualRent + amount;

  bool hasNewAnnualRent() => _newAnnualRent != null;

  // "annualRentIncrease" field.
  double? _annualRentIncrease;
  double get annualRentIncrease => _annualRentIncrease ?? 0.0;
  set annualRentIncrease(double? val) => _annualRentIncrease = val;

  void incrementAnnualRentIncrease(double amount) =>
      annualRentIncrease = annualRentIncrease + amount;

  bool hasAnnualRentIncrease() => _annualRentIncrease != null;

  static SalesOfferAtRetirementStruct fromMap(Map<String, dynamic> data) =>
      SalesOfferAtRetirementStruct(
        newCapitalValue: castToType<double>(data['newCapitalValue']),
        capitalValueIncrease: castToType<double>(data['capitalValueIncrease']),
        newAnnualRent: castToType<double>(data['newAnnualRent']),
        annualRentIncrease: castToType<double>(data['annualRentIncrease']),
      );

  static SalesOfferAtRetirementStruct? maybeFromMap(dynamic data) => data is Map
      ? SalesOfferAtRetirementStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'newCapitalValue': _newCapitalValue,
        'capitalValueIncrease': _capitalValueIncrease,
        'newAnnualRent': _newAnnualRent,
        'annualRentIncrease': _annualRentIncrease,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'newCapitalValue': serializeParam(
          _newCapitalValue,
          ParamType.double,
        ),
        'capitalValueIncrease': serializeParam(
          _capitalValueIncrease,
          ParamType.double,
        ),
        'newAnnualRent': serializeParam(
          _newAnnualRent,
          ParamType.double,
        ),
        'annualRentIncrease': serializeParam(
          _annualRentIncrease,
          ParamType.double,
        ),
      }.withoutNulls;

  static SalesOfferAtRetirementStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      SalesOfferAtRetirementStruct(
        newCapitalValue: deserializeParam(
          data['newCapitalValue'],
          ParamType.double,
          false,
        ),
        capitalValueIncrease: deserializeParam(
          data['capitalValueIncrease'],
          ParamType.double,
          false,
        ),
        newAnnualRent: deserializeParam(
          data['newAnnualRent'],
          ParamType.double,
          false,
        ),
        annualRentIncrease: deserializeParam(
          data['annualRentIncrease'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'SalesOfferAtRetirementStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SalesOfferAtRetirementStruct &&
        newCapitalValue == other.newCapitalValue &&
        capitalValueIncrease == other.capitalValueIncrease &&
        newAnnualRent == other.newAnnualRent &&
        annualRentIncrease == other.annualRentIncrease;
  }

  @override
  int get hashCode => const ListEquality().hash([
        newCapitalValue,
        capitalValueIncrease,
        newAnnualRent,
        annualRentIncrease
      ]);
}

SalesOfferAtRetirementStruct createSalesOfferAtRetirementStruct({
  double? newCapitalValue,
  double? capitalValueIncrease,
  double? newAnnualRent,
  double? annualRentIncrease,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SalesOfferAtRetirementStruct(
      newCapitalValue: newCapitalValue,
      capitalValueIncrease: capitalValueIncrease,
      newAnnualRent: newAnnualRent,
      annualRentIncrease: annualRentIncrease,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SalesOfferAtRetirementStruct? updateSalesOfferAtRetirementStruct(
  SalesOfferAtRetirementStruct? salesOfferAtRetirement, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    salesOfferAtRetirement
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSalesOfferAtRetirementStructData(
  Map<String, dynamic> firestoreData,
  SalesOfferAtRetirementStruct? salesOfferAtRetirement,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (salesOfferAtRetirement == null) {
    return;
  }
  if (salesOfferAtRetirement.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      salesOfferAtRetirement.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final salesOfferAtRetirementData = getSalesOfferAtRetirementFirestoreData(
      salesOfferAtRetirement, forFieldValue);
  final nestedData =
      salesOfferAtRetirementData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      salesOfferAtRetirement.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSalesOfferAtRetirementFirestoreData(
  SalesOfferAtRetirementStruct? salesOfferAtRetirement, [
  bool forFieldValue = false,
]) {
  if (salesOfferAtRetirement == null) {
    return {};
  }
  final firestoreData = mapToFirestore(salesOfferAtRetirement.toMap());

  // Add any Firestore field values
  mapToFirestore(salesOfferAtRetirement.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSalesOfferAtRetirementListFirestoreData(
  List<SalesOfferAtRetirementStruct>? salesOfferAtRetirements,
) =>
    salesOfferAtRetirements
        ?.map((e) => getSalesOfferAtRetirementFirestoreData(e, true))
        .toList() ??
    [];
