// import 'package:flutter/foundation.dart';
// import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
// import '../../helpers/dbhelper.dart';
//
// import 'package:intl/intl.dart';
//
// class RegisteredFarmerListApiSeedlingApiProvider extends ChangeNotifier {
//   static var newdate = DateTime.now();
//   static var formatDate = DateFormat('MMM d, y');
//   String formattedDat = formatDate.format(newdate);
//
//   List<RegisteredFarmerListApiSeedling> _falSLists = [];
//
//   List<RegisteredFarmerListApiSeedling> get falSLists {
//     return [..._falSLists];
//   }
//
//   RegisteredFarmerListApiSeedling findById(String id) {
//     return _falSLists.firstWhere((monitoring) => monitoring.falSId == id);
//   }
//
//   void addRegisteredFarmerListApiSeedling(
//     String pickedid,
//     String pickedfalSFarmerName,
//     String pickedfalSCommunityName,
//     String pickedfalSCommunityId,
//     String pickedfalSContact,
//     String pickedfalSBaseline,
//   ) {
//     final newRegisteredFarmerListApiSeedling = RegisteredFarmerListApiSeedling(
//       falSId: pickedid,
//       falSFarmerName: pickedfalSFarmerName,
//       falSCommunityName: pickedfalSCommunityName,
//       falSCommunityId: pickedfalSCommunityId,
//       falSContact: pickedfalSContact,
//       falSBaseline: pickedfalSBaseline,
//       dateCreated: DateTime.now().toString(),
//     );
//     _falSLists.add(newRegisteredFarmerListApiSeedling);
//     // _falSLists.insert(0, newRegisteredFarmerListApiSeedling);
//     notifyListeners();
//
//     DBHelper.insert('farmer_api_list_seedling', {
//       'id': newRegisteredFarmerListApiSeedling.falSId!,
//       'falSFarmerName': newRegisteredFarmerListApiSeedling.falSFarmerName!,
//       'falSCommunityName':
//           newRegisteredFarmerListApiSeedling.falSCommunityName!,
//       'falSCommunityId': newRegisteredFarmerListApiSeedling.falSCommunityId!,
//       'falSContact': newRegisteredFarmerListApiSeedling.falSContact!,
//       'falSBaseline': newRegisteredFarmerListApiSeedling.falSBaseline!,
//       'dateCreated': newRegisteredFarmerListApiSeedling.dateCreated!,
//     });
//   }
//
//   Future<void> fetchAndSetRegisteredFarmerListApiSeedling() async {
//     final dataList = await DBHelper.fetchData('farmer_api_list_seedling');
//     _falSLists = dataList
//         .map(
//           (falSLists) => RegisteredFarmerListApiSeedling(
//             falSId: falSLists['id'],
//             falSFarmerName: falSLists['falSFarmerName'],
//             falSCommunityName: falSLists['falSCommunityName'],
//             falSCommunityId: falSLists['falSCommunityId'],
//             falSContact: falSLists['falSContact'],
//             falSBaseline: falSLists['falSBaseline'],
//             dateCreated: falSLists['dateCreated'],
//           ),
//         )
//         .toList();
//     notifyListeners();
//   }
// }
