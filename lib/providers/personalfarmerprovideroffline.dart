// import 'package:flutter/foundation.dart';
// import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
// import '../helpers/dbhelper.dart';
//
// import 'package:intl/intl.dart';
//
// class PersonalFarmerProviderOffline extends ChangeNotifier {
//   static var newdate = DateTime.now();
//   static var formatDate = DateFormat('MMM d, y');
//   String formattedDat = formatDate.format(newdate);
//
//   List<PersonalFarmerOffline> _farmerListsOfflineLocal = [];
//
//   List<PersonalFarmerOffline> get farmerLists {
//     return [..._farmerListsOfflineLocal];
//   }
//
//   PersonalFarmerOffline findById(String id) {
//     return _farmerListsOfflineLocal.firstWhere((place) => place.id == id);
//   }
//
//   void addPersonalFarmerOffline(
// //beneficiary Type
//     String pickedbeneficiaryType,
//     String pickedEnumeratorValue,
//
// //farmer Details
//     // String farmerRegNum;
//     String pickedfarmerfirstName,
//     String pickedfarmerotherName,
//     String pickedfarmersurName,
//     String pickedfarmerGender,
//     String pickedfarmerPhoneNum,
//     String pickedfarmerDoB,
//     String pickedfarmerMail,
//     String pickedfarmerPostal,
//     String pickedkinName,
//     String pickedkinRelationShip,
//     String pickedkinDoB,
//     String pickedkinGender,
//     String pickedkinPhoneNum,
//     String pickedkinPostal,
//     String pickedfarmerPic64,
//
//     //group Details
//     String pickedgroupName,
//     String pickedgroupPresident,
//     String pickedgroupSecretary,
//     String pickedgroupphoneNumber,
//     String pickedgroupDirectors,
//     String pickedgroupEmail,
//     String pickedgroupAddress,
//
//     // declaration Signatures
//     String pickedfarmerdeclarationSig,
//
//     // connection Status
//     String pickedconStat,
//   ) {
//     final newPersonalFarmer = PersonalFarmerOffline(
//       id: DateTime.now().toString(),
//       tfoTimeDisplay: formattedDat,
//       tfoBeneficiaryType: pickedbeneficiaryType,
//       tfoEnumeratorValue: pickedEnumeratorValue,
//       tfoFarmerfirstName: pickedfarmerfirstName,
//       tfoFarmerotherName: pickedfarmerotherName,
//       tfoFarmersurName: pickedfarmersurName,
//       tfoFarmerGender: pickedfarmerGender,
//       tfoFarmerPhoneNum: pickedfarmerPhoneNum,
//       tfoFarmerDoB: pickedfarmerDoB,
//       tfoFarmerMail: pickedfarmerMail,
//       tfoFarmerPostal: pickedfarmerPostal,
//       tfoKinName: pickedkinName,
//       tfoKinRelationShip: pickedkinRelationShip,
//       tfoKinDoB: pickedkinDoB,
//       tfoKinGender: pickedkinGender,
//       tfoKinPhoneNum: pickedkinPhoneNum,
//       tfoKinPostal: pickedkinPostal,
//       tfoFarmerPic64: pickedfarmerPic64,
//       tfoGroupName: pickedgroupName,
//       tfoGroupPresident: pickedgroupPresident,
//       tfoGroupSecretary: pickedgroupSecretary,
//       tfoGroupphoneNumber: pickedgroupphoneNumber,
//       tfoGroupDirectors: pickedgroupDirectors,
//       tfoGroupEmail: pickedgroupEmail,
//       tfoGroupAddress: pickedgroupAddress,
//       tfoFarmerdeclarationSig: pickedfarmerdeclarationSig,
//       tfoConStat: pickedconStat,
//     );
//     _farmerListsOfflineLocal.add(newPersonalFarmer);
//     // _farmerLists.insert(0, newPersonalFarmer);
//     notifyListeners();
//
//     DBHelper.insert('tree_farmer_offline', {
//       'id': newPersonalFarmer.id,
//       'tfoTimeDisplay': newPersonalFarmer.tfoTimeDisplay,
//       'tfoBeneficiaryType': newPersonalFarmer.tfoBeneficiaryType,
//       'tfoEnumeratorValue': newPersonalFarmer.tfoEnumeratorValue,
//       'tfoFarmerfirstName': newPersonalFarmer.tfoFarmerfirstName,
//       'tfoFarmerotherName': newPersonalFarmer.tfoFarmerotherName,
//       'tfoFarmersurName': newPersonalFarmer.tfoFarmersurName,
//       'tfoFarmerGender': newPersonalFarmer.tfoFarmerGender,
//       'tfoFarmerPhoneNum': newPersonalFarmer.tfoFarmerPhoneNum,
//       'tfoFarmerDoB': newPersonalFarmer.tfoFarmerDoB,
//       'tfoFarmerMail': newPersonalFarmer.tfoFarmerMail,
//       'tfoFarmerPostal': newPersonalFarmer.tfoFarmerPostal,
//       'tfoKinName': newPersonalFarmer.tfoKinName,
//       'tfoKinRelationShip': newPersonalFarmer.tfoKinRelationShip,
//       'tfoKinDoB': newPersonalFarmer.tfoKinDoB,
//       'tfoKinGender': newPersonalFarmer.tfoKinGender,
//       'tfoKinPhoneNum': newPersonalFarmer.tfoKinPhoneNum,
//       'tfoKinPostal': newPersonalFarmer.tfoKinPostal,
//       'tfoFarmerPic64': newPersonalFarmer.tfoFarmerPic64,
//       'tfoGroupName': newPersonalFarmer.tfoGroupName,
//       'tfoGroupPresident': newPersonalFarmer.tfoGroupPresident,
//       'tfoGroupSecretary': newPersonalFarmer.tfoGroupSecretary,
//       'tfoGroupphoneNumber': newPersonalFarmer.tfoGroupphoneNumber,
//       'tfoGroupDirectors': newPersonalFarmer.tfoGroupDirectors,
//       'tfoGroupEmail': newPersonalFarmer.tfoGroupEmail,
//       'tfoGroupAddress': newPersonalFarmer.tfoGroupAddress,
//       'tfoFarmerdeclarationSig': newPersonalFarmer.tfoFarmerdeclarationSig,
//       'tfoConStat': newPersonalFarmer.tfoConStat,
//     });
//   }
//
//   Future<void> fetchAndSetPersonalFarmerOffline() async {
//     final dataList = await DBHelper.fetchData('tree_farmer_offline');
//     _farmerListsOfflineLocal = dataList
//         .map((farmerLists) => PersonalFarmerOffline(
//               id: farmerLists['id'],
//               tfoTimeDisplay: farmerLists['tfoTimeDisplay'],
//               tfoBeneficiaryType: farmerLists['tfoBeneficiaryType'],
//               tfoEnumeratorValue: farmerLists['tfoEnumeratorValue'],
//               tfoFarmerfirstName: farmerLists['tfoFarmerfirstName'],
//               tfoFarmerotherName: farmerLists['tfoFarmerotherName'],
//               tfoFarmersurName: farmerLists['tfoFarmersurName'],
//               tfoFarmerGender: farmerLists['tfoFarmerGender'],
//               tfoFarmerPhoneNum: farmerLists['tfoFarmerPhoneNum'],
//               tfoFarmerDoB: farmerLists['tfoFarmerDoB'],
//               tfoFarmerMail: farmerLists['tfoFarmerMail'],
//               tfoFarmerPostal: farmerLists['tfoFarmerPostal'],
//               tfoKinName: farmerLists['tfoKinName'],
//               tfoKinRelationShip: farmerLists['tfoKinRelationShip'],
//               tfoKinDoB: farmerLists['tfoKinDoB'],
//               tfoKinGender: farmerLists['tfoKinGender'],
//               tfoKinPhoneNum: farmerLists['tfoKinPhoneNum'],
//               tfoKinPostal: farmerLists['tfoKinPostal'],
//               tfoFarmerPic64: farmerLists['tfoFarmerPic64'],
//               tfoGroupName: farmerLists['tfoGroupName'],
//               tfoGroupPresident: farmerLists['tfoGroupPresident'],
//               tfoGroupSecretary: farmerLists['tfoGroupSecretary'],
//               tfoGroupphoneNumber: farmerLists['tfoGroupphoneNumber'],
//               tfoGroupDirectors: farmerLists['tfoGroupDirectors'],
//               tfoGroupEmail: farmerLists['tfoGroupEmail'],
//               tfoGroupAddress: farmerLists['tfoGroupAddress'],
//               tfoFarmerdeclarationSig: farmerLists['tfoFarmerdeclarationSig'],
//               tfoConStat: farmerLists['tfoConStat'],
//             ))
//         .toList();
//     notifyListeners();
//   }
// }
//
// class PersonalFarmerProviderApiList extends ChangeNotifier {
//   static var newdate = DateTime.now();
//   static var formatDate = DateFormat('MMM d, y');
//   String formattedDat = formatDate.format(newdate);
//
//   List<PersonalFarmerApiList> _farmerListsOfflineApi = [];
//
//   List<PersonalFarmerApiList> get farmerLists {
//     return [..._farmerListsOfflineApi];
//   }
//
//   PersonalFarmerApiList findById(String id) {
//     return _farmerListsOfflineApi.firstWhere((place) => place.id == id);
//   }
//
//   void addPersonalFarmerApiList(
// //beneficiary Type
//     String pickedbeneficiaryType,
//     String pickedEnumeratorValue,
//
// //farmer Details
//     // String farmerRegNum;
//     String pickedfarmerfirstName,
//     String pickedfarmerotherName,
//     String pickedfarmersurName,
//     String pickedfarmerGender,
//     String pickedfarmerPhoneNum,
//     String pickedfarmerDoB,
//     String pickedfarmerMail,
//     String pickedfarmerPostal,
//     String pickedkinName,
//     String pickedkinRelationShip,
//     String pickedkinDoB,
//     String pickedkinGender,
//     String pickedkinPhoneNum,
//     String pickedkinPostal,
//     String pickedfarmerPic64,
//
//     //group Details
//     String pickedgroupName,
//     String pickedgroupPresident,
//     String pickedgroupSecretary,
//     String pickedgroupphoneNumber,
//     String pickedgroupDirectors,
//     String pickedgroupEmail,
//     String pickedgroupAddress,
//
//     // declaration Signatures
//     String pickedfarmerdeclarationSig,
//
//     // connection Status
//     String pickedconStat,
//   ) {
//     final newPersonalFarmer = PersonalFarmerApiList(
//       id: DateTime.now().toString(),
//       tfaTimeDisplay: formattedDat,
//       tfaBeneficiaryType: pickedbeneficiaryType,
//       tfaEnumeratorValue: pickedEnumeratorValue,
//       tfaFarmerfirstName: pickedfarmerfirstName,
//       tfaFarmerotherName: pickedfarmerotherName,
//       tfaFarmersurName: pickedfarmersurName,
//       tfaFarmerGender: pickedfarmerGender,
//       tfaFarmerPhoneNum: pickedfarmerPhoneNum,
//       tfaFarmerDoB: pickedfarmerDoB,
//       tfaFarmerMail: pickedfarmerMail,
//       tfaFarmerPostal: pickedfarmerPostal,
//       tfaKinName: pickedkinName,
//       tfaKinRelationShip: pickedkinRelationShip,
//       tfaKinDoB: pickedkinDoB,
//       tfaKinGender: pickedkinGender,
//       tfaKinPhoneNum: pickedkinPhoneNum,
//       tfaKinPostal: pickedkinPostal,
//       tfaFarmerPic64: pickedfarmerPic64,
//       tfaGroupName: pickedgroupName,
//       tfaGroupPresident: pickedgroupPresident,
//       tfaGroupSecretary: pickedgroupSecretary,
//       tfaGroupphoneNumber: pickedgroupphoneNumber,
//       tfaGroupDirectors: pickedgroupDirectors,
//       tfaGroupEmail: pickedgroupEmail,
//       tfaGroupAddress: pickedgroupAddress,
//       tfaFarmerdeclarationSig: pickedfarmerdeclarationSig,
//       tfaConStat: pickedconStat,
//     );
//     _farmerListsOfflineApi.add(newPersonalFarmer);
//     // _farmerLists.insert(0, newPersonalFarmer);
//     notifyListeners();
//
//     DBHelper.insert('tree_farmer_api_list', {
//       'id': newPersonalFarmer.id,
//       'tfaTimeDisplay': newPersonalFarmer.tfaTimeDisplay,
//       'tfaBeneficiaryType': newPersonalFarmer.tfaBeneficiaryType,
//       'tfaEnumeratorValue': newPersonalFarmer.tfaEnumeratorValue,
//       'tfaFarmerfirstName': newPersonalFarmer.tfaFarmerfirstName,
//       'tfaFarmerotherName': newPersonalFarmer.tfaFarmerotherName,
//       'tfaFarmersurName': newPersonalFarmer.tfaFarmersurName,
//       'tfaFarmerGender': newPersonalFarmer.tfaFarmerGender,
//       'tfaFarmerPhoneNum': newPersonalFarmer.tfaFarmerPhoneNum,
//       'tfaFarmerDoB': newPersonalFarmer.tfaFarmerDoB,
//       'tfaFarmerMail': newPersonalFarmer.tfaFarmerMail,
//       'tfaFarmerPostal': newPersonalFarmer.tfaFarmerPostal,
//       'tfaKinName': newPersonalFarmer.tfaKinName,
//       'tfaKinRelationShip': newPersonalFarmer.tfaKinRelationShip,
//       'tfaKinDoB': newPersonalFarmer.tfaKinDoB,
//       'tfaKinGender': newPersonalFarmer.tfaKinGender,
//       'tfaKinPhoneNum': newPersonalFarmer.tfaKinPhoneNum,
//       'tfaKinPostal': newPersonalFarmer.tfaKinPostal,
//       'tfaFarmerPic64': newPersonalFarmer.tfaFarmerPic64,
//       'tfaGroupName': newPersonalFarmer.tfaGroupName,
//       'tfaGroupPresident': newPersonalFarmer.tfaGroupPresident,
//       'tfaGroupSecretary': newPersonalFarmer.tfaGroupSecretary,
//       'tfaGroupphoneNumber': newPersonalFarmer.tfaGroupphoneNumber,
//       'tfaGroupDirectors': newPersonalFarmer.tfaGroupDirectors,
//       'tfaGroupEmail': newPersonalFarmer.tfaGroupEmail,
//       'tfaGroupAddress': newPersonalFarmer.tfaGroupAddress,
//       'tfaFarmerdeclarationSig': newPersonalFarmer.tfaFarmerdeclarationSig,
//       'tfaConStat': newPersonalFarmer.tfaConStat,
//     });
//   }
//
//   Future<void> fetchAndSetPersonalFarmerApiList() async {
//     final dataList = await DBHelper.fetchData('tree_farmer_api_list');
//     _farmerListsOfflineApi = dataList
//         .map((farmerLists) => PersonalFarmerApiList(
//               id: farmerLists['id'],
//               tfaTimeDisplay: farmerLists['tfaTimeDisplay'],
//               tfaBeneficiaryType: farmerLists['tfaBeneficiaryType'],
//               tfaEnumeratorValue: farmerLists['tfaEnumeratorValue'],
//               tfaFarmerfirstName: farmerLists['tfaFarmerfirstName'],
//               tfaFarmerotherName: farmerLists['tfaFarmerotherName'],
//               tfaFarmersurName: farmerLists['tfaFarmersurName'],
//               tfaFarmerGender: farmerLists['tfaFarmerGender'],
//               tfaFarmerPhoneNum: farmerLists['tfaFarmerPhoneNum'],
//               tfaFarmerDoB: farmerLists['tfaFarmerDoB'],
//               tfaFarmerMail: farmerLists['tfaFarmerMail'],
//               tfaFarmerPostal: farmerLists['tfaFarmerPostal'],
//               tfaKinName: farmerLists['tfaKinName'],
//               tfaKinRelationShip: farmerLists['tfaKinRelationShip'],
//               tfaKinDoB: farmerLists['tfaKinDoB'],
//               tfaKinGender: farmerLists['tfaKinGender'],
//               tfaKinPhoneNum: farmerLists['tfaKinPhoneNum'],
//               tfaKinPostal: farmerLists['tfaKinPostal'],
//               tfaFarmerPic64: farmerLists['tfaFarmerPic64'],
//               tfaGroupName: farmerLists['tfaGroupName'],
//               tfaGroupPresident: farmerLists['tfaGroupPresident'],
//               tfaGroupSecretary: farmerLists['tfaGroupSecretary'],
//               tfaGroupphoneNumber: farmerLists['tfaGroupphoneNumber'],
//               tfaGroupDirectors: farmerLists['tfaGroupDirectors'],
//               tfaGroupEmail: farmerLists['tfaGroupEmail'],
//               tfaGroupAddress: farmerLists['tfaGroupAddress'],
//               tfaFarmerdeclarationSig: farmerLists['tfaFarmerdeclarationSig'],
//               tfaConStat: farmerLists['tfaConStat'],
//             ))
//         .toList();
//     notifyListeners();
//   }
// }
