import 'package:flutter/foundation.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import '../../helpers/dbhelper.dart';

import 'package:intl/intl.dart';

class AlternativeLivelihoodProvider extends ChangeNotifier {
  static var newdate = DateTime.now();
  static var formatDate = DateFormat('MMM d, y');
  String formattedDat = formatDate.format(newdate);

  List<AlternativeLivelihood> _alLists = [];

  List<AlternativeLivelihood> get alLists {
    return [..._alLists];
  }

  AlternativeLivelihood findById(String id) {
    return _alLists.firstWhere((monitoring) => monitoring.alId == id);
  }

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
  ) {
    final newAlternativeLivelihood = AlternativeLivelihood(
      alId: DateTime.now().toString(),
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
    _alLists.add(newAlternativeLivelihood);
    // _alLists.insert(0, newAlternativeLivelihood);
    notifyListeners();

    DBHelper.insert('alternative_livelihood', {
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
    final dataList = await DBHelper.fetchData('alternative_livelihood');
    _alLists = dataList
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
        .toList();
    notifyListeners();
  }

  Future<void> fetchAndSetAlternativeLivelihood2(String? fieldname) async {
    final dataList = await DBHelper.fetchData2(
      'alternative_livelihood',
      fieldname,
    );
    _alLists = dataList
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
        .toList();
    notifyListeners();
  }

  Future<void> fetchAndSetAlternativeLivelihoodWhere(
      String? fieldname, String? date) async {
    final dataList = await DBHelper.fetchDataWhere(
        'alternative_livelihood', fieldname, date);
    _alLists = dataList
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
        .toList();
    notifyListeners();
  }
}
