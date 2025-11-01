// import 'package:flutter/foundation.dart';
// import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
// import '../helpers/dbhelper.dart';
//
// import 'package:intl/intl.dart';
//
// class DeforestationProvider extends ChangeNotifier {
//   static var newdate = DateTime.now();
//   static var formatDate = DateFormat('MMM d, y');
//   String formattedDat = formatDate.format(newdate);
//
//   List<DeforestationModel> _deforestationLists = [];
//
//   List<DeforestationModel> get deforestationLists {
//     return [..._deforestationLists];
//   }
//
//   DeforestationModel findById(String id) {
//     return _deforestationLists.firstWhere((place) => place.id == id);
//   }
//
//   void addDeforestation(
//     String pickedcommunity,
//     String pickedgfwDirected,
//     String pickedseeDeforestation,
//     String pickeddeforestationCause,
//     String pickedtakeAction,
//     String pickedactionReason,
//     String pickedlatitude,
//     String pickedlongitude,
//     String pickedimage,
//     String pickedconStat,
//   ) {
//     final newDeforestationModel = DeforestationModel(
//       id: DateTime.now().toString(),
//       timeDisplay: formattedDat,
//       community: pickedcommunity,
//       gfwDirected: pickedgfwDirected,
//       seeDeforestation: pickedseeDeforestation,
//       deforestationCause: pickeddeforestationCause,
//       takeAction: pickedtakeAction,
//       actionReason: pickedactionReason,
//       latitude: pickedlatitude,
//       longitude: pickedlongitude,
//       image: pickedimage,
//       conStat: pickedconStat,
//     );
//     _deforestationLists.add(newDeforestationModel);
//     // _deforestationLists.insert(0, newDeforestationModel);
//     notifyListeners();
//
//     DBHelper.insert('deforestation', {
//       'id': newDeforestationModel.id,
//       'timeDisplay': newDeforestationModel.timeDisplay,
//       'community': newDeforestationModel.community,
//       'gfwDirected': newDeforestationModel.gfwDirected,
//       'seeDeforestation': newDeforestationModel.seeDeforestation,
//       'deforestationCause': newDeforestationModel.deforestationCause,
//       'takeAction': newDeforestationModel.takeAction,
//       'actionReason': newDeforestationModel.actionReason,
//       'latitude': newDeforestationModel.latitude,
//       'longitude': newDeforestationModel.longitude,
//       'image': newDeforestationModel.image,
//       'conStat': newDeforestationModel.conStat,
//     });
//   }
//
//   Future<void> fetchAndSetDeforestationModel() async {
//     final dataList = await DBHelper.fetchData('deforestation');
//     _deforestationLists = dataList
//         .map((deforestationLists) => DeforestationModel(
//               id: deforestationLists['id'],
//               timeDisplay: deforestationLists['timeDisplay'],
//               community: deforestationLists['community'],
//               gfwDirected: deforestationLists['gfwDirected'],
//               seeDeforestation: deforestationLists['seeDeforestation'],
//               deforestationCause: deforestationLists['deforestationCause'],
//               takeAction: deforestationLists['takeAction'],
//               actionReason: deforestationLists['actionReason'],
//               latitude: deforestationLists['latitude'],
//               longitude: deforestationLists['longitude'],
//               image: deforestationLists['image'],
//               conStat: deforestationLists['conStat'],
//             ))
//         .toList();
//     notifyListeners();
//   }
// }
