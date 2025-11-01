// import 'package:flutter/foundation.dart';
// import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
// import '../helpers/dbhelper.dart';
//
// import 'package:intl/intl.dart';
//
// class PersonalFarmerProvider extends ChangeNotifier {
//   static var newdate = DateTime.now();
//   static var formatDate = DateFormat('MMM d, y');
//   String formattedDat = formatDate.format(newdate);
//
//   List<PersonalFarmer> _farmerLists = [];
//
//   List<PersonalFarmer> get farmerLists {
//     return [..._farmerLists];
//   }
//
//   List<UserFreq> _userPersistData = [];
//
//   List<UserFreq> get userPersistData {
//     return [..._userPersistData];
//   }
//
//   PersonalFarmer findById(String id) {
//     return _farmerLists.firstWhere((place) => place.id == id);
//   }
//
//   void addPersonalFarmer(
// //beneficiary Type
//     String pickedfarmerId,
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
//     //farm Details
//     String pickedregion,
//     String pickedforestDistrict,
//     String pickedmddas,
//     String pickedmddasName,
//     String pickedcommunity,
//     String pickedfamily,
//     String pickedtypeofEstablishment,
//
//     //farm Cordinates
//     String pickedfarmID,
//     String pickedfarmArea,
//     String pickedpointsGet,
//
//     //tree Plantation Detail
//     String pickedc2treePlantationDetail,
//     String pickedc3treePlantationDetail,
//
//     // declaration Signatures
//     String pickedfarmerdeclarationSig,
//     String pickedwitnessdeclarationSig,
//     String pickedWintessName,
//     String pickedWitnessPhone,
//
//     // connection Status
//     String pickedconStat,
//   ) {
//     final newPersonalFarmer = PersonalFarmer(
//       id: DateTime.now().toString(),
//       timeDisplay: formattedDat,
//       farmerId: pickedfarmerId,
//       beneficiaryType: pickedbeneficiaryType,
//       enumeratorValue: pickedEnumeratorValue,
//       farmerfirstName: pickedfarmerfirstName,
//       farmerotherName: pickedfarmerotherName,
//       farmersurName: pickedfarmersurName,
//       farmerGender: pickedfarmerGender,
//       farmerPhoneNum: pickedfarmerPhoneNum,
//       farmerDoB: pickedfarmerDoB,
//       farmerMail: pickedfarmerMail,
//       farmerPostal: pickedfarmerPostal,
//       kinName: pickedkinName,
//       kinRelationShip: pickedkinRelationShip,
//       kinDoB: pickedkinDoB,
//       kinGender: pickedkinGender,
//       kinPhoneNum: pickedkinPhoneNum,
//       kinPostal: pickedkinPostal,
//       farmerPic64: pickedfarmerPic64,
//       groupName: pickedgroupName,
//       groupPresident: pickedgroupPresident,
//       groupSecretary: pickedgroupSecretary,
//       groupphoneNumber: pickedgroupphoneNumber,
//       groupDirectors: pickedgroupDirectors,
//       groupEmail: pickedgroupEmail,
//       groupAddress: pickedgroupAddress,
//       region: pickedregion,
//       forestDistrict: pickedforestDistrict,
//       mddas: pickedmddas,
//       mddasName: pickedmddasName,
//       community: pickedcommunity,
//       family: pickedfamily,
//       typeofEstablishment: pickedtypeofEstablishment,
//       farmID: pickedfarmID,
//       farmArea: pickedfarmArea,
//       pointsGet: pickedpointsGet,
//       c2treePlantationDetail: pickedc2treePlantationDetail,
//       c3treePlantationDetail: pickedc3treePlantationDetail,
//       farmerdeclarationSig: pickedfarmerdeclarationSig,
//       witnessdeclarationSig: pickedwitnessdeclarationSig,
//       witnessName: pickedWintessName,
//       witnessPhone: pickedWitnessPhone,
//       conStat: pickedconStat,
//     );
//     _farmerLists.add(newPersonalFarmer);
//     // _farmerLists.insert(0, newPersonalFarmer);
//     notifyListeners();
//
//     DBHelper.insert('forest_app', {
//       'id': newPersonalFarmer.id,
//       'timeDisplay': newPersonalFarmer.timeDisplay,
//       'farmerId': newPersonalFarmer.farmerId,
//       'beneficiaryType': newPersonalFarmer.beneficiaryType,
//       'enumeratorValue': newPersonalFarmer.enumeratorValue,
//       'farmerfirstName': newPersonalFarmer.farmerfirstName,
//       'farmerotherName': newPersonalFarmer.farmerotherName,
//       'farmersurName': newPersonalFarmer.farmersurName,
//       'farmerGender': newPersonalFarmer.farmerGender,
//       'farmerPhoneNum': newPersonalFarmer.farmerPhoneNum,
//       'farmerDoB': newPersonalFarmer.farmerDoB,
//       'farmerMail': newPersonalFarmer.farmerMail,
//       'farmerPostal': newPersonalFarmer.farmerPostal,
//       'kinName': newPersonalFarmer.kinName,
//       'kinRelationShip': newPersonalFarmer.kinRelationShip,
//       'kinDoB': newPersonalFarmer.kinDoB,
//       'kinGender': newPersonalFarmer.kinGender,
//       'kinPhoneNum': newPersonalFarmer.kinPhoneNum,
//       'kinPostal': newPersonalFarmer.kinPostal,
//       'farmerPic64': newPersonalFarmer.farmerPic64,
//       'groupName': newPersonalFarmer.groupName,
//       'groupPresident': newPersonalFarmer.groupPresident,
//       'groupSecretary': newPersonalFarmer.groupSecretary,
//       'groupphoneNumber': newPersonalFarmer.groupphoneNumber,
//       'groupDirectors': newPersonalFarmer.groupDirectors,
//       'groupEmail': newPersonalFarmer.groupEmail,
//       'groupAddress': newPersonalFarmer.groupAddress,
//       'region': newPersonalFarmer.region,
//       'forestDistrict': newPersonalFarmer.forestDistrict,
//       'mddas': newPersonalFarmer.mddas,
//       'mddasName': newPersonalFarmer.mddasName,
//       'community': newPersonalFarmer.community,
//       'family': newPersonalFarmer.family,
//       'typeofEstablishment': newPersonalFarmer.typeofEstablishment,
//       'farmID': newPersonalFarmer.farmID,
//       'farmArea': newPersonalFarmer.farmArea,
//       'pointsGet': newPersonalFarmer.pointsGet,
//       'c2treePlantationDetail': newPersonalFarmer.c2treePlantationDetail,
//       'c3treePlantationDetail': newPersonalFarmer.c3treePlantationDetail,
//       'farmerdeclarationSig': newPersonalFarmer.farmerdeclarationSig,
//       'witnessdeclarationSig': newPersonalFarmer.witnessdeclarationSig,
//       'witnessName': newPersonalFarmer.witnessName,
//       'witnessPhone': newPersonalFarmer.witnessPhone,
//       'conStat': newPersonalFarmer.conStat,
//     });
//   }
//
//   void setPersistData(
//     String pickedID,
//     String pickedFirstTime,
//     String pickedDisplayName,
//     String pickedEnumeratorValue,
//     String pickedStatus,
//     String pickedlogStatus,
//     String pickedcontact,
//     String pickedpassword,
//   ) {
//     final persistData = UserFreq(
//       id: 0.toString(),
//       firstTime: pickedFirstTime,
//       displayName: pickedDisplayName,
//       enumeratorValue: pickedEnumeratorValue,
//       status: pickedStatus,
//       logStatus: pickedlogStatus,
//       enumeratorContact: pickedcontact,
//       enumeratorPassword: pickedpassword,
//     );
//     _userPersistData.add(persistData);
//     notifyListeners();
//
//     DBHelper.insert('first_time_user', {
//       'id': persistData.id,
//       'firstTime': persistData.firstTime,
//       'displayName': persistData.displayName,
//       'enumeratorValue': persistData.enumeratorValue,
//       'status': persistData.status,
//       'log': persistData.logStatus,
//       'contact': persistData.enumeratorContact,
//       'password': persistData.enumeratorPassword,
//     });
//   }
//
//   Future<void> validateShow() async {
//     final userDataValue = await DBHelper.fetchData('first_time_user');
//     _userPersistData = userDataValue
//         .map((userPersistDatas) => UserFreq(
//               id: userPersistDatas['id'],
//               firstTime: userPersistDatas['firstTime'],
//               displayName: userPersistDatas['displayName'],
//               enumeratorValue: userPersistDatas['enumeratorValue'],
//               status: userPersistDatas['status'],
//               logStatus: userPersistDatas['log'],
//               enumeratorContact: userPersistDatas['contact'],
//               enumeratorPassword: userPersistDatas['password'],
//             ))
//         .toList();
//     notifyListeners();
//   }
//
//   Future<void> fetchAndSetPersonalFarmer() async {
//     final dataList = await DBHelper.fetchData('forest_app');
//     _farmerLists = dataList
//         .map((farmerLists) => PersonalFarmer(
//               id: farmerLists['id'],
//               timeDisplay: farmerLists['timeDisplay'],
//               farmerId: farmerLists['farmerId'],
//               beneficiaryType: farmerLists['beneficiaryType'],
//               enumeratorValue: farmerLists['enumeratorValue'],
//               farmerfirstName: farmerLists['farmerfirstName'],
//               farmerotherName: farmerLists['farmerotherName'],
//               farmersurName: farmerLists['farmersurName'],
//               farmerGender: farmerLists['farmerGender'],
//               farmerPhoneNum: farmerLists['farmerPhoneNum'],
//               farmerDoB: farmerLists['farmerDoB'],
//               farmerMail: farmerLists['farmerMail'],
//               farmerPostal: farmerLists['farmerPostal'],
//               kinName: farmerLists['kinName'],
//               kinRelationShip: farmerLists['kinRelationShip'],
//               kinDoB: farmerLists['kinDoB'],
//               kinGender: farmerLists['kinGender'],
//               kinPhoneNum: farmerLists['kinPhoneNum'],
//               kinPostal: farmerLists['kinPostal'],
//               farmerPic64: farmerLists['farmerPic64'],
//               groupName: farmerLists['groupName'],
//               groupPresident: farmerLists['groupPresident'],
//               groupSecretary: farmerLists['groupSecretary'],
//               groupphoneNumber: farmerLists['groupphoneNumber'],
//               groupDirectors: farmerLists['groupDirectors'],
//               groupEmail: farmerLists['groupEmail'],
//               groupAddress: farmerLists['groupAddress'],
//               region: farmerLists['region'],
//               forestDistrict: farmerLists['forestDistrict'],
//               mddas: farmerLists['mddas'],
//               mddasName: farmerLists['mddasName'],
//               community: farmerLists['community'],
//               family: farmerLists['family'],
//               typeofEstablishment: farmerLists['typeofEstablishment'],
//               farmID: farmerLists['farmID'],
//               farmArea: farmerLists['farmArea'],
//               pointsGet: farmerLists['pointsGet'],
//               c2treePlantationDetail: farmerLists['c2treePlantationDetail'],
//               c3treePlantationDetail: farmerLists['c3treePlantationDetail'],
//               farmerdeclarationSig: farmerLists['farmerdeclarationSig'],
//               witnessdeclarationSig: farmerLists['witnessdeclarationSig'],
//               witnessName: farmerLists['witnessName'],
//               witnessPhone: farmerLists['witnessPhone'],
//               conStat: farmerLists['conStat'],
//             ))
//         .toList();
//     notifyListeners();
//   }
// }
