import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/controller/db.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class AlternativeLivelihoodProvider extends GetxController {
  static var newdate = DateTime.now();
  static var formatDate = DateFormat('MMM d, y');
  String formattedDat = formatDate.format(newdate);

  final AppDatabaseHelper _dbHelper = AppDatabaseHelper();
  // await AppDatabaseHelper().database;
  // Database? db;

  final _alLists = <AlternativeLivelihood>[].obs;

  List<AlternativeLivelihood> get alLists => _alLists;

  AlternativeLivelihood findById(String id) {
    return _alLists.firstWhere((monitoring) => monitoring.alId == id);
  }
  //
  // initDb()async{
  //   db = await _dbHelper.database;
  // }

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   initDb();
  // }

  void addAlternativeLivelihood(
      String pickedalCommunity,
      String pickedalEnumeratorValue,
      String pickedalVisitDate,
      String pickedFarmerId,
      String pickedalFarmerName,
      String pickedalBasline,
      String pickedalFarmerContact,
      String pickedalAdditionalActivity,
      String pickedalTrainerOrg,
      String pickedalOperationsStartDate,
      String pickedalInitialAmount,
      String pickedalAmountType,
      String pickedalAmount,
      String pickedalAmountToLMB,
      String pickedalActivitySupported,
      String pickedalConStat,
      ) async {
    Database? db;
    db = await AppDatabaseHelper().database;
    final newAlternativeLivelihood = AlternativeLivelihood(
      alId: DateTime.now().millisecondsSinceEpoch.toString(),
      alTimeDisplay: formattedDat,
      alCommunity: pickedalCommunity,
      alEnumeratorValue: pickedalEnumeratorValue,
      alVisitDate: pickedalVisitDate,
      alFarmerId: pickedFarmerId,
      alFarmerName: pickedalFarmerName,
      alBasline: pickedalBasline,
      alFarmerContact: pickedalFarmerContact,
      alAdditionalActivity: pickedalAdditionalActivity,
      alTrainerOrg: pickedalTrainerOrg,
      alOperationsStartDate: pickedalOperationsStartDate,
      alInitialAmount: pickedalInitialAmount,
      alAmountType: pickedalAmountType,
      alAmount: pickedalAmount,
      alAmountToLMB: pickedalAmountToLMB,
      alActivitySupported: pickedalActivitySupported,
      alConStat: pickedalConStat,
    );

    _alLists.insert(0, newAlternativeLivelihood);

    db.insert('alternative_livelihood', {
      'id': newAlternativeLivelihood.alId,
      'alTimeDisplay': newAlternativeLivelihood.alTimeDisplay,
      'alCommunity': newAlternativeLivelihood.alCommunity,
      'alEnumeratorValue': newAlternativeLivelihood.alEnumeratorValue,
      'alVisitDate': newAlternativeLivelihood.alVisitDate,
      'alFarmerId': newAlternativeLivelihood.alFarmerId,
      'alFarmerName': newAlternativeLivelihood.alFarmerName,
      'alBasline': newAlternativeLivelihood.alBasline,
      'alFarmerContact': newAlternativeLivelihood.alFarmerContact,
      'alAdditionalActivity': newAlternativeLivelihood.alAdditionalActivity,
      'alTrainerOrg': newAlternativeLivelihood.alTrainerOrg,
      'alOperationsStartDate': newAlternativeLivelihood.alOperationsStartDate,
      'alInitialAmount': newAlternativeLivelihood.alInitialAmount,
      'alAmountType': newAlternativeLivelihood.alAmountType,
      'alAmount': newAlternativeLivelihood.alAmount,
      'alAmountToLMB': newAlternativeLivelihood.alAmountToLMB,
      'alActivitySupported': newAlternativeLivelihood.alActivitySupported,
      'alConStat': newAlternativeLivelihood.alConStat,
    });
  }

  Future<void> fetchAndSetAlternativeLivelihood() async {
    AppDatabaseHelper? db;
    db = AppDatabaseHelper();
    final dataList = await db.fetchData('alternative_livelihood');
    _alLists.assignAll(dataList
        .map((alLists) => AlternativeLivelihood(
      alId: alLists['id'],
      alTimeDisplay: alLists['alTimeDisplay'],
      alCommunity: alLists['alCommunity'],
      alEnumeratorValue: alLists['alEnumeratorValue'],
      alVisitDate: alLists['alVisitDate'],
      alFarmerId: alLists['alFarmerId'],
      alFarmerName: alLists['alFarmerName'],
      alBasline: alLists['alBasline'],
      alFarmerContact: alLists['alFarmerContact'],
      alAdditionalActivity: alLists['alAdditionalActivity'],
      alTrainerOrg: alLists['alTrainerOrg'],
      alOperationsStartDate: alLists['alOperationsStartDate'],
      alInitialAmount: alLists['alInitialAmount'],
      alAmountType: alLists['alAmountType'],
      alAmount: alLists['alAmount'],
      alAmountToLMB: alLists['alAmountToLMB'],
      alActivitySupported: alLists['alActivitySupported'],
      alConStat: alLists['alConStat'],
    ))
        .toList());

    debugPrint("THE DATA ::::::::::: $_alLists");
  }

  Future<void> fetchAndSetAlternativeLivelihood2(String? fieldname) async {
    AppDatabaseHelper? db;
    db = AppDatabaseHelper();
    final dataList = await db.fetchData2(
      'alternative_livelihood',
      fieldname,
    );
    _alLists.assignAll(dataList
        .map((alLists) => AlternativeLivelihood(
      alId: alLists['id'],
      alTimeDisplay: alLists['alTimeDisplay'],
      alCommunity: alLists['alCommunity'],
      alEnumeratorValue: alLists['alEnumeratorValue'],
      alVisitDate: alLists['alVisitDate'],
      alFarmerId: alLists['alFarmerId'],
      alFarmerName: alLists['alFarmerName'],
      alBasline: alLists['alBasline'],
      alFarmerContact: alLists['alFarmerContact'],
      alAdditionalActivity: alLists['alAdditionalActivity'],
      alTrainerOrg: alLists['alTrainerOrg'],
      alOperationsStartDate: alLists['alOperationsStartDate'],
      alInitialAmount: alLists['alInitialAmount'],
      alAmountType: alLists['alAmountType'],
      alAmount: alLists['alAmount'],
      alAmountToLMB: alLists['alAmountToLMB'],
      alActivitySupported: alLists['alActivitySupported'],
      alConStat: alLists['alConStat'],
    ))
        .toList());
  }

  Future<void> fetchAndSetAlternativeLivelihoodWhere(

      String? fieldname, String? date) async {
    AppDatabaseHelper? db;
    db = AppDatabaseHelper();
    final dataList = await db.fetchDataWhere(
        'alternative_livelihood', fieldname, date);
    _alLists.assignAll(dataList
        .map((alLists) => AlternativeLivelihood(
      alId: alLists['id'],
      alTimeDisplay: alLists['alTimeDisplay'],
      alCommunity: alLists['alCommunity'],
      alEnumeratorValue: alLists['alEnumeratorValue'],
      alVisitDate: alLists['alVisitDate'],
      alFarmerId: alLists['alFarmerId'],
      alFarmerName: alLists['alFarmerName'],
      alBasline: alLists['alBasline'],
      alFarmerContact: alLists['alFarmerContact'],
      alAdditionalActivity: alLists['alAdditionalActivity'],
      alTrainerOrg: alLists['alTrainerOrg'],
      alOperationsStartDate: alLists['alOperationsStartDate'],
      alInitialAmount: alLists['alInitialAmount'],
      alAmountType: alLists['alAmountType'],
      alAmount: alLists['alAmount'],
      alAmountToLMB: alLists['alAmountToLMB'],
      alActivitySupported: alLists['alActivitySupported'],
      alConStat: alLists['alConStat'],
    ))
        .toList());
  }

  // Delete a record
  Future<void> deleteAlternativeLivelihoodd(String id) async {
    AppDatabaseHelper? db;
    db = AppDatabaseHelper();
    _alLists.removeWhere((item) => item.alId == id);
    await db.deleteAlternativeLivelihood(id);
  }

  // Clear all data
  void clearData() {
    _alLists.clear();
  }


  void updateAlternativeLivelihood(
      String recordId,
      String pickedalCommunity,
      String pickedalEnumeratorValue,
      String pickedalVisitDate,
      String pickedFarmerId,
      String pickedalFarmerName,
      String pickedalBasline,
      String pickedalFarmerContact,
      String pickedalAdditionalActivity,
      String pickedalTrainerOrg,
      String pickedalOperationsStartDate,
      String pickedalInitialAmount,
      String pickedalAmountType,
      String pickedalAmount,
      String pickedalAmountToLMB,
      String pickedalActivitySupported,
      String pickedalConStat,
      ) {
    final updatedAlternativeLivelihood = AlternativeLivelihood(
      alId: recordId,
      alTimeDisplay: formattedDat,
      alCommunity: pickedalCommunity,
      alEnumeratorValue: pickedalEnumeratorValue,
      alVisitDate: pickedalVisitDate,
      alFarmerId: pickedFarmerId,
      alFarmerName: pickedalFarmerName,
      alBasline: pickedalBasline,
      alFarmerContact: pickedalFarmerContact,
      alAdditionalActivity: pickedalAdditionalActivity,
      alTrainerOrg: pickedalTrainerOrg,
      alOperationsStartDate: pickedalOperationsStartDate,
      alInitialAmount: pickedalInitialAmount,
      alAmountType: pickedalAmountType,
      alAmount: pickedalAmount,
      alAmountToLMB: pickedalAmountToLMB,
      alActivitySupported: pickedalActivitySupported,
      alConStat: pickedalConStat,
    );

    // Update in the list
    final index = _alLists.indexWhere((record) => record.alId == recordId);
    if (index != -1) {
      _alLists[index] = updatedAlternativeLivelihood;
    }

    // Update in database using direct database call
    _updateInDatabaseDirectly(recordId, {
      'alTimeDisplay': updatedAlternativeLivelihood.alTimeDisplay,
      'alCommunity': updatedAlternativeLivelihood.alCommunity,
      'alEnumeratorValue': updatedAlternativeLivelihood.alEnumeratorValue,
      'alVisitDate': updatedAlternativeLivelihood.alVisitDate,
      'alFarmerId': updatedAlternativeLivelihood.alFarmerId,
      'alFarmerName': updatedAlternativeLivelihood.alFarmerName,
      'alBasline': updatedAlternativeLivelihood.alBasline,
      'alFarmerContact': updatedAlternativeLivelihood.alFarmerContact,
      'alAdditionalActivity': updatedAlternativeLivelihood.alAdditionalActivity,
      'alTrainerOrg': updatedAlternativeLivelihood.alTrainerOrg,
      'alOperationsStartDate': updatedAlternativeLivelihood.alOperationsStartDate,
      'alInitialAmount': updatedAlternativeLivelihood.alInitialAmount,
      'alAmountType': updatedAlternativeLivelihood.alAmountType,
      'alAmount': updatedAlternativeLivelihood.alAmount,
      'alAmountToLMB': updatedAlternativeLivelihood.alAmountToLMB,
      'alActivitySupported': updatedAlternativeLivelihood.alActivitySupported,
      'alConStat': updatedAlternativeLivelihood.alConStat,
    });

  }

  Future<void> _updateInDatabaseDirectly(String recordId, Map<String, dynamic> data) async {
    Database? db;
    db = await AppDatabaseHelper().database;
    await db.update(
      'alternative_livelihood',
      data,
      where: 'id = ?',
      whereArgs: [recordId],
    );
  }
}