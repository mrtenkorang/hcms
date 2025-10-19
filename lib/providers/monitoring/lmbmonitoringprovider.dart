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

  Future<void> updateLMBMonitoring(LMBMonitoring updatedRecord) async {
    try {
      debugPrint('=== STARTING UPDATE ===');
      debugPrint('Record ID: ${updatedRecord.lmbId}');
      debugPrint('Record to update: ${updatedRecord.toJson()}'); // Add this method if you don't have it

      // Find the index of the record to update
      final index = _lmbLists.indexWhere((record) => record.lmbId == updatedRecord.lmbId);
      debugPrint('Found index: $index');

      if (index >= 0) {
        // Update the local list
        _lmbLists[index] = updatedRecord;

        // Update the database
        final db = await DBHelper.database();

        // Use parameterized query with proper column names
        final result = await db.rawUpdate(
          '''
        UPDATE lmb_monitoring SET
          lmbTimeDisplay = ?,
          lmbEnumeratorValue = ?,
          lmbName = ?,
          lmbSector = ?,
          lmbPrivateName = ?,
          lmbFirstEngagement = ?,
          lmbPartnershipType = ?,
          lmbPartnershipDuration = ?,
          lmbMou = ?,
          lmbFinancialName = ?,
          lmbTypeLoanService = ?,
          lmbLoanDuration = ?,
          lmbLoanInterest = ?,
          lmbFemaleBenefit = ?,
          lmbMaleBenefit = ?,
          lmbYouthBenefit = ?,
          lmbConStat = ?
        WHERE lmbId = ? 
        ''',
          [
            updatedRecord.lmbTimeDisplay,
            updatedRecord.lmbEnumeratorValue,
            updatedRecord.lmbName,
            updatedRecord.lmbSector,
            updatedRecord.lmbPrivateName,
            updatedRecord.lmbFirstEngagement,
            updatedRecord.lmbPartnershipType,
            updatedRecord.lmbPartnershipDuration,
            updatedRecord.lmbMou,
            updatedRecord.lmbFinancialName,
            updatedRecord.lmbTypeLoanService,
            updatedRecord.lmbLoanDuration,
            updatedRecord.lmbLoanInterest,
            updatedRecord.lmbFemaleBenefit,
            updatedRecord.lmbMaleBenefit,
            updatedRecord.lmbYouthBenefit,
            updatedRecord.lmbConStat,
            updatedRecord.lmbId,
          ],
        );

        debugPrint('Update result (rows affected): $result');

        if (result == 0) {
          debugPrint('WARNING: No rows were updated. Check if record exists in database.');
        } else {
          debugPrint('SUCCESS: Record updated successfully');
        }

        notifyListeners();
      } else {
        debugPrint('ERROR: Record not found in local list');
        throw Exception('LMBMonitoring record not found for update in local list');
      }
    } catch (e) {
      debugPrint('ERROR in updateLMBMonitoring: $e');
      debugPrint('Stack trace: ${e.toString()}');
      throw Exception('Failed to update LMB monitoring: $e');
    }
  }}
