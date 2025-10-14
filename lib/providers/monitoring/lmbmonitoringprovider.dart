import 'package:flutter/foundation.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import '../../helpers/dbhelper.dart';

import 'package:intl/intl.dart';

class LMBMonitoringProvider extends ChangeNotifier {
  static var newdate = DateTime.now();
  static var formatDate = DateFormat('MMM d, y');
  String formattedDat = formatDate.format(newdate);

  List<LMBMonitoring> _lmbLists = [];

  List<LMBMonitoring> get lmbLists {
    return [..._lmbLists];
  }

  LMBMonitoring findById(String id) {
    return _lmbLists.firstWhere((monitoring) => monitoring.lmbId == id);
  }

  void addLMBMonitoring(
    String pickedlmbEnumeratorValue,
    String pickedlmbName,
    String pickedlmbSector,
    String pickedlmbPrivateName,
    String pickedlmbFirstEngagement,
    String pickedlmbPartnershipType,
    String pickedlmbPartnershipDuration,
    String pickedlmbMou,
    String pickedlmbFinancialName,
    String pickedlmbTypeLoanService,
    String pickedlmbLoanDuration,
    String pickedlmbLoanInterest,
    String pickedlmbFemaleBenefit,
    String pickedlmbMaleBenefit,
    String pickedlmbYouthBenefit,
    String pickedlmbConStat,
  ) {
    final newLMBMonitoring = LMBMonitoring(
      lmbId: DateTime.now().toString(),
      lmbTimeDisplay: formattedDat,
      lmbEnumeratorValue: pickedlmbEnumeratorValue,
      lmbName: pickedlmbName,
      lmbSector: pickedlmbSector,
      lmbPrivateName: pickedlmbPrivateName,
      lmbFirstEngagement: pickedlmbFirstEngagement,
      lmbPartnershipType: pickedlmbPartnershipType,
      lmbPartnershipDuration: pickedlmbPartnershipDuration,
      lmbMou: pickedlmbMou,
      lmbFinancialName: pickedlmbFinancialName,
      lmbTypeLoanService: pickedlmbTypeLoanService,
      lmbLoanDuration: pickedlmbLoanDuration,
      lmbLoanInterest: pickedlmbLoanInterest,
      lmbFemaleBenefit: pickedlmbFemaleBenefit,
      lmbMaleBenefit: pickedlmbMaleBenefit,
      lmbYouthBenefit: pickedlmbYouthBenefit,
      lmbConStat: pickedlmbConStat,
    );
    _lmbLists.add(newLMBMonitoring);
    // _lmbLists.insert(0, newLMBMonitoring);
    notifyListeners();

    DBHelper.insert('lmb_monitoring', {
      'id': newLMBMonitoring.lmbId,
      'lmbTimeDisplay': newLMBMonitoring.lmbTimeDisplay,
      'lmbEnumeratorValue': newLMBMonitoring.lmbEnumeratorValue,
      'lmbName': newLMBMonitoring.lmbName,
      'lmbSector': newLMBMonitoring.lmbSector,
      'lmbPrivateName': newLMBMonitoring.lmbPrivateName,
      'lmbFirstEngagement': newLMBMonitoring.lmbFirstEngagement,
      'lmbPartnershipType': newLMBMonitoring.lmbPartnershipType,
      'lmbPartnershipDuration': newLMBMonitoring.lmbPartnershipDuration,
      'lmbMou': newLMBMonitoring.lmbMou,
      'lmbFinancialName': newLMBMonitoring.lmbFinancialName,
      'lmbTypeLoanService': newLMBMonitoring.lmbTypeLoanService,
      'lmbLoanDuration': newLMBMonitoring.lmbLoanDuration,
      'lmbLoanInterest': newLMBMonitoring.lmbLoanInterest,
      'lmbFemaleBenefit': newLMBMonitoring.lmbFemaleBenefit,
      'lmbMaleBenefit': newLMBMonitoring.lmbMaleBenefit,
      'lmbYouthBenefit': newLMBMonitoring.lmbYouthBenefit,
      'lmbConStat': newLMBMonitoring.lmbConStat,
    });
  }

  Future<void> fetchAndSetLMBMonitoring() async {
    final dataList = await DBHelper.fetchData('lmb_monitoring');
    _lmbLists = dataList
        .map((lmbLists) => LMBMonitoring(
              lmbId: lmbLists['id'],
              lmbTimeDisplay: lmbLists['lmbTimeDisplay'],
              lmbEnumeratorValue: lmbLists['lmbEnumeratorValue'],
              lmbName: lmbLists['lmbName'],
              lmbSector: lmbLists['lmbSector'],
              lmbPrivateName: lmbLists['lmbPrivateName'],
              lmbFirstEngagement: lmbLists['lmbFirstEngagement'],
              lmbPartnershipType: lmbLists['lmbPartnershipType'],
              lmbPartnershipDuration: lmbLists['lmbPartnershipDuration'],
              lmbMou: lmbLists['lmbMou'],
              lmbFinancialName: lmbLists['lmbFinancialName'],
              lmbTypeLoanService: lmbLists['lmbTypeLoanService'],
              lmbLoanDuration: lmbLists['lmbLoanDuration'],
              lmbLoanInterest: lmbLists['lmbLoanInterest'],
              lmbFemaleBenefit: lmbLists['lmbFemaleBenefit'],
              lmbMaleBenefit: lmbLists['lmbMaleBenefit'],
              lmbYouthBenefit: lmbLists['lmbYouthBenefit'],
              lmbConStat: lmbLists['lmbConStat'],
            ))
        .toList();
    notifyListeners();
  }
}
