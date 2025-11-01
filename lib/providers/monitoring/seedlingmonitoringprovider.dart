// import 'package:flutter/foundation.dart';
// import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
// import '../../helpers/dbhelper.dart';
//
// import 'package:intl/intl.dart';
//
// class SeedlingMonitoringProvider extends ChangeNotifier {
//   static var newdate = DateTime.now();
//   static var formatDate = DateFormat('MMM d, y');
//   String formattedDat = formatDate.format(newdate);
//
//   List<SeedlingMonitoring> _smLists = [];
//
//   List<SeedlingMonitoring> get smLists {
//     return [..._smLists];
//   }
//
//   SeedlingMonitoring findById(String id) {
//     return _smLists.firstWhere((monitoring) => monitoring.smId == id);
//   }
//
//   void addSeedlingMonitoring(
//     String pickedsmCommunity,
//     String pickedsmVisitDate,
//     String pickedsmEnumeratorValue,
//     String pickedsmFarmerId,
//     String pickedsmFarmerName,
//     String pickedsmBaseline,
//     String pickedsmFarmerContact,
//     String pickedsmSpecies,
//     String pickedsmReceivedDate,
//     String pickedsmPlantedDate,
//     String pickedsmQuantityReceived,
//     String pickedsmQuantityPlanted,
//     String pickedsmQuantitySurvived,
//     String pickedsmPlantingArea,
//     String pickedsmAreaSize,
//     String pickedsmRegisteredTrees,
//     String pickedsmFarmLocation,
//     String pickedconStat,
//   ) {
//     final newSeedlingMonitoring = SeedlingMonitoring(
//       smId: DateTime.now().toString(),
//       smTimeDisplay: formattedDat,
//       smCommunity: pickedsmCommunity,
//       smVisitDate: pickedsmVisitDate,
//       smEnumeratorValue: pickedsmEnumeratorValue,
//       smFarmerId: pickedsmFarmerId,
//       smFarmerName: pickedsmFarmerName,
//       smBaseline: pickedsmBaseline,
//       smFarmerContact: pickedsmFarmerContact,
//       smSpecies: pickedsmSpecies,
//       smReceivedDate: pickedsmReceivedDate,
//       smPlantedDate: pickedsmPlantedDate,
//       smQuantityReceived: pickedsmQuantityReceived,
//       smQuantityPlanted: pickedsmQuantityPlanted,
//       smQuantitySurvived: pickedsmQuantitySurvived,
//       smPlantingArea: pickedsmPlantingArea,
//       smAreaSize: pickedsmAreaSize,
//       smRegisteredTrees: pickedsmRegisteredTrees,
//       smFarmLocation: pickedsmFarmLocation,
//       smConStat: pickedconStat,
//     );
//     _smLists.add(newSeedlingMonitoring);
//     // _smLists.insert(0, newSeedlingMonitoring);
//     notifyListeners();
//
//     DBHelper.insert('seedling_monitoring', {
//       'id': newSeedlingMonitoring.smId,
//       'smTimeDisplay': newSeedlingMonitoring.smTimeDisplay,
//       'smCommunity': newSeedlingMonitoring.smCommunity,
//       'smVisitDate': newSeedlingMonitoring.smVisitDate,
//       'smEnumeratorValue': newSeedlingMonitoring.smEnumeratorValue,
//       'smFarmerId': newSeedlingMonitoring.smFarmerId,
//       'smFarmerName': newSeedlingMonitoring.smFarmerName,
//       'smBasline': newSeedlingMonitoring.smBaseline,
//       'smFarmerContact': newSeedlingMonitoring.smFarmerContact,
//       'smSpecies': newSeedlingMonitoring.smSpecies,
//       'smReceivedDate': newSeedlingMonitoring.smReceivedDate,
//       'smPlantedDate': newSeedlingMonitoring.smPlantedDate,
//       'smQuantityReceived': newSeedlingMonitoring.smQuantityReceived,
//       'smQuantityPlanted': newSeedlingMonitoring.smQuantityPlanted,
//       'smQuantitySurvived': newSeedlingMonitoring.smQuantitySurvived,
//       'smPlantingArea': newSeedlingMonitoring.smPlantingArea,
//       'smAreaSize': newSeedlingMonitoring.smAreaSize,
//       'smRegisteredTrees': newSeedlingMonitoring.smRegisteredTrees,
//       'smFarmLocation': newSeedlingMonitoring.smFarmLocation,
//       'smConStat': newSeedlingMonitoring.smConStat,
//     });
//   }
//
//   Future<void> fetchAndSetSeedlingMonitoring() async {
//     final dataList = await DBHelper.fetchData('seedling_monitoring');
//     _smLists = dataList
//         .map((smLists) => SeedlingMonitoring(
//               smId: smLists['id'],
//               smTimeDisplay: smLists['smTimeDisplay'],
//               smCommunity: smLists['smCommunity'],
//               smVisitDate: smLists['smVisitDate'],
//               smEnumeratorValue: smLists['smEnumeratorValue'],
//               smFarmerId: smLists['smFarmerId'],
//               smFarmerName: smLists['smFarmerName'],
//               smBaseline: smLists['smBasline'],
//               smFarmerContact: smLists['smFarmerContact'],
//               smSpecies: smLists['smSpecies'],
//               smReceivedDate: smLists['smReceivedDate'],
//               smPlantedDate: smLists['smPlantedDate'],
//               smQuantityReceived: smLists['smQuantityReceived'],
//               smQuantityPlanted: smLists['smQuantityPlanted'],
//               smQuantitySurvived: smLists['smQuantitySurvived'],
//               smPlantingArea: smLists['smPlantingArea'],
//               smAreaSize: smLists['smAreaSize'],
//               smRegisteredTrees: smLists['smRegisteredTrees'],
//               smFarmLocation: smLists['smFarmLocation'],
//               smConStat: smLists['smConStat'],
//             ))
//         .toList();
//     notifyListeners();
//   }
//
//   Future<void> fetchAndSetSeedlingMonitoring2(String? fieldname) async {
//     final dataList =
//         await DBHelper.fetchData2('seedling_monitoring', fieldname);
//     _smLists = dataList
//         .map((smLists) => SeedlingMonitoring(
//               smId: smLists['id'],
//               smTimeDisplay: smLists['smTimeDisplay'],
//               smCommunity: smLists['smCommunity'],
//               smVisitDate: smLists['smVisitDate'],
//               smEnumeratorValue: smLists['smEnumeratorValue'],
//               smFarmerId: smLists['smFarmerId'],
//               smFarmerName: smLists['smFarmerName'],
//               smBaseline: smLists['smBasline'],
//               smFarmerContact: smLists['smFarmerContact'],
//               smSpecies: smLists['smSpecies'],
//               smReceivedDate: smLists['smReceivedDate'],
//               smPlantedDate: smLists['smPlantedDate'],
//               smQuantityReceived: smLists['smQuantityReceived'],
//               smQuantityPlanted: smLists['smQuantityPlanted'],
//               smQuantitySurvived: smLists['smQuantitySurvived'],
//               smPlantingArea: smLists['smPlantingArea'],
//               smAreaSize: smLists['smAreaSize'],
//               smRegisteredTrees: smLists['smRegisteredTrees'],
//               smFarmLocation: smLists['smFarmLocation'],
//               smConStat: smLists['smConStat'],
//             ))
//         .toList();
//     notifyListeners();
//   }
//
//   Future<void> fetchAndSetSeedlingMonitoringWhere(
//       String? fieldname, String? dateFactor) async {
//     final dataList = await DBHelper.fetchDataWhere(
//         'seedling_monitoring', fieldname, dateFactor);
//     _smLists = dataList
//         .map((smLists) => SeedlingMonitoring(
//               smId: smLists['id'],
//               smTimeDisplay: smLists['smTimeDisplay'],
//               smCommunity: smLists['smCommunity'],
//               smVisitDate: smLists['smVisitDate'],
//               smEnumeratorValue: smLists['smEnumeratorValue'],
//               smFarmerId: smLists['smFarmerId'],
//               smFarmerName: smLists['smFarmerName'],
//               smBaseline: smLists['smBasline'],
//               smFarmerContact: smLists['smFarmerContact'],
//               smSpecies: smLists['smSpecies'],
//               smReceivedDate: smLists['smReceivedDate'],
//               smPlantedDate: smLists['smPlantedDate'],
//               smQuantityReceived: smLists['smQuantityReceived'],
//               smQuantityPlanted: smLists['smQuantityPlanted'],
//               smQuantitySurvived: smLists['smQuantitySurvived'],
//               smPlantingArea: smLists['smPlantingArea'],
//               smAreaSize: smLists['smAreaSize'],
//               smRegisteredTrees: smLists['smRegisteredTrees'],
//               smFarmLocation: smLists['smFarmLocation'],
//               smConStat: smLists['smConStat'],
//             ))
//         .toList();
//     notifyListeners();
//   }
// }
