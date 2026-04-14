// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CapitalAvailableToInvestStruct extends FFFirebaseStruct {
  CapitalAvailableToInvestStruct({
    double? ownCapital,
    double? releasableEquity,
    double? totalCapitalAvailable,
    DateTime? upgradeDate,
    bool? hasUpgradeDate,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _ownCapital = ownCapital,
        _releasableEquity = releasableEquity,
        _totalCapitalAvailable = totalCapitalAvailable,
        _upgradeDate = upgradeDate,
        _hasUpgradeDate = hasUpgradeDate,
        super(firestoreUtilData);

  // "ownCapital" field.
  double? _ownCapital;
  double get ownCapital => _ownCapital ?? 0.0;
  set ownCapital(double? val) => _ownCapital = val;

  void incrementOwnCapital(double amount) => ownCapital = ownCapital + amount;

  bool hasOwnCapital() => _ownCapital != null;

  // "releasableEquity" field.
  double? _releasableEquity;
  double get releasableEquity => _releasableEquity ?? 0.0;
  set releasableEquity(double? val) => _releasableEquity = val;

  void incrementReleasableEquity(double amount) =>
      releasableEquity = releasableEquity + amount;

  bool hasReleasableEquity() => _releasableEquity != null;

  // "totalCapitalAvailable" field.
  double? _totalCapitalAvailable;
  double get totalCapitalAvailable => _totalCapitalAvailable ?? 0.0;
  set totalCapitalAvailable(double? val) => _totalCapitalAvailable = val;

  void incrementTotalCapitalAvailable(double amount) =>
      totalCapitalAvailable = totalCapitalAvailable + amount;

  bool hasTotalCapitalAvailable() => _totalCapitalAvailable != null;

  // "upgradeDate" field.
  DateTime? _upgradeDate;
  DateTime? get upgradeDate => _upgradeDate;
  set upgradeDate(DateTime? val) => _upgradeDate = val;

  bool hasUpgradeDateField() => _upgradeDate != null;

  // "hasUpgradeDate" field.
  bool? _hasUpgradeDate;
  bool get hasUpgradeDate => _hasUpgradeDate ?? false;
  set hasUpgradeDate(bool? val) => _hasUpgradeDate = val;

  bool hasHasUpgradeDate() => _hasUpgradeDate != null;

  static CapitalAvailableToInvestStruct fromMap(Map<String, dynamic> data) =>
      CapitalAvailableToInvestStruct(
        ownCapital: castToType<double>(data['ownCapital']),
        releasableEquity: castToType<double>(data['releasableEquity']),
        totalCapitalAvailable:
            castToType<double>(data['totalCapitalAvailable']),
        upgradeDate: data['upgradeDate'] as DateTime?,
        hasUpgradeDate: data['hasUpgradeDate'] as bool?,
      );

  static CapitalAvailableToInvestStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? CapitalAvailableToInvestStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'ownCapital': _ownCapital,
        'releasableEquity': _releasableEquity,
        'totalCapitalAvailable': _totalCapitalAvailable,
        'upgradeDate': _upgradeDate,
        'hasUpgradeDate': _hasUpgradeDate,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ownCapital': serializeParam(
          _ownCapital,
          ParamType.double,
        ),
        'releasableEquity': serializeParam(
          _releasableEquity,
          ParamType.double,
        ),
        'totalCapitalAvailable': serializeParam(
          _totalCapitalAvailable,
          ParamType.double,
        ),
        'upgradeDate': serializeParam(
          _upgradeDate,
          ParamType.DateTime,
        ),
        'hasUpgradeDate': serializeParam(
          _hasUpgradeDate,
          ParamType.bool,
        ),
      }.withoutNulls;

  static CapitalAvailableToInvestStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CapitalAvailableToInvestStruct(
        ownCapital: deserializeParam(
          data['ownCapital'],
          ParamType.double,
          false,
        ),
        releasableEquity: deserializeParam(
          data['releasableEquity'],
          ParamType.double,
          false,
        ),
        totalCapitalAvailable: deserializeParam(
          data['totalCapitalAvailable'],
          ParamType.double,
          false,
        ),
        upgradeDate: deserializeParam(
          data['upgradeDate'],
          ParamType.DateTime,
          false,
        ),
        hasUpgradeDate: deserializeParam(
          data['hasUpgradeDate'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'CapitalAvailableToInvestStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CapitalAvailableToInvestStruct &&
        ownCapital == other.ownCapital &&
        releasableEquity == other.releasableEquity &&
        totalCapitalAvailable == other.totalCapitalAvailable &&
        upgradeDate == other.upgradeDate &&
        hasUpgradeDate == other.hasUpgradeDate;
  }

  @override
  int get hashCode => const ListEquality().hash([
        ownCapital,
        releasableEquity,
        totalCapitalAvailable,
        upgradeDate,
        hasUpgradeDate
      ]);
}

CapitalAvailableToInvestStruct createCapitalAvailableToInvestStruct({
  double? ownCapital,
  double? releasableEquity,
  double? totalCapitalAvailable,
  DateTime? upgradeDate,
  bool? hasUpgradeDate,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CapitalAvailableToInvestStruct(
      ownCapital: ownCapital,
      releasableEquity: releasableEquity,
      totalCapitalAvailable: totalCapitalAvailable,
      upgradeDate: upgradeDate,
      hasUpgradeDate: hasUpgradeDate,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CapitalAvailableToInvestStruct? updateCapitalAvailableToInvestStruct(
  CapitalAvailableToInvestStruct? capitalAvailableToInvest, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    capitalAvailableToInvest
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCapitalAvailableToInvestStructData(
  Map<String, dynamic> firestoreData,
  CapitalAvailableToInvestStruct? capitalAvailableToInvest,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (capitalAvailableToInvest == null) {
    return;
  }
  if (capitalAvailableToInvest.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      capitalAvailableToInvest.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final capitalAvailableToInvestData = getCapitalAvailableToInvestFirestoreData(
      capitalAvailableToInvest, forFieldValue);
  final nestedData =
      capitalAvailableToInvestData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      capitalAvailableToInvest.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCapitalAvailableToInvestFirestoreData(
  CapitalAvailableToInvestStruct? capitalAvailableToInvest, [
  bool forFieldValue = false,
]) {
  if (capitalAvailableToInvest == null) {
    return {};
  }
  final firestoreData = mapToFirestore(capitalAvailableToInvest.toMap());

  // Add any Firestore field values
  mapToFirestore(capitalAvailableToInvest.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCapitalAvailableToInvestListFirestoreData(
  List<CapitalAvailableToInvestStruct>? capitalAvailableToInvests,
) =>
    capitalAvailableToInvests
        ?.map((e) => getCapitalAvailableToInvestFirestoreData(e, true))
        .toList() ??
    [];
