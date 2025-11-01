// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// // import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/helpers/dbhelper.dart';
// import 'package:hcms_revived2/main.dart';
// import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
// import 'package:hcms_revived2/providers/monitoring/registeredfarmerApiAlternativeprovider.dart';
// import 'package:hcms_revived2/providers/monitoring/registeredfarmerApiSeedlingprovider.dart';
// import 'package:hcms_revived2/providers/monitoring/registeredfarmerprovider.dart';
// import 'package:hcms_revived2/screens/home/index.dart';
// import 'package:hcms_revived2/services/serverurls.dart';
// import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
// import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
//
// class FarmerBioData extends StatefulWidget {
//   @override
//   _FarmerBioDataState createState() => _FarmerBioDataState();
// }
//
// class _FarmerBioDataState extends State<FarmerBioData> {
//   final _formKey = GlobalKey<FormState>();
//   IndexPage pageIndex = IndexPage();
//
//   final _communityName = TextEditingController();
//   final _farmerfirstName = TextEditingController();
//   final _farmerotherName = TextEditingController();
//   final _farmersurName = TextEditingController();
//   final _farmerContact = TextEditingController();
//   final _areaSize = TextEditingController();
//   String? _farmerGender;
//   String? _farmerdOB;
//
//   bool isdateofbirth = false;
//   String? dateofbirthString;
//
//   bool errorMessage = false;
//
//   int? selectedFarmerRadioGender;
//
//   void setFDValuesT() {
//     regSP?.setString('fdfarmerfirstName', _farmerfirstName.text);
//     regSP?.setString('fdfarmerotherName', _farmerotherName.text);
//     regSP?.setString('fdfarmersurName', _farmersurName.text);
//     regSP?.setString('fdfarmerContact', _farmerContact.text);
//     regSP?.setString('fdfarmerDoB', _farmerdOB!);
//     regSP?.setString(
//         'fdfarmerGender',
//         _farmerGender == "male"
//             ? 'male'
//             : _farmerGender == "female"
//                 ? 'female'
//                 : '');
//     regSP?.setString(
//         'fdComName', boxChecked ? _communityName.text : _community!);
//
//     print("done setting");
//   }
//
//   // authenticatingLoader() {
//   //   showDialog(
//   //       barrierColor: Colors.white38,
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return Container(
//   //           child: Center(
//   //             child: SpinKitChasingDots(
//   //               color: Colors.orange,
//   //               size: 80.0,
//   //             ),
//   //           ),
//   //         );
//   //       });
//   // }
//
//   var commUrl = "$stageBaseUrl/communityapi/";
//
//   File? commjsonFile;
//   File? regionjsonFile;
//   Directory? dir;
//   String commfileName = "community.json";
//   bool commfileExists = false;
//   var commfileContent;
//   List<CommunityJson> _newcommValues = [];
//   List<CommunityJson> _commValues = [];
//
//   void createCommFile(var content, Directory dir, String fileName) {
//     print("Creating Community file!");
//     File file = new File(dir.path + "/" + fileName);
//     file.createSync();
//     commfileExists = true;
//     file.writeAsString(json.encode(content));
//   }
//
//   Future<List<CommunityJson>> writeToCommFile(BuildContext ctx) async {
//     print("Writing to community file! $commfileExists");
//     if (commfileExists) {
//       print("Community File exists $commfileExists");
//
//       try {
//         var response = await http.get(Uri.parse(commUrl));
//
//         if (response.statusCode == 200) {
//           final items = json.decode(response.body).cast<Map<String, dynamic>>();
//           print("Community");
//
//           print("content $items");
//           print("object");
//
//           // var content = {key: items};
//
//           var commjsonFileContent =
//               await json.decode(await commjsonFile!.readAsString());
//           commjsonFileContent.clear();
//           commjsonFileContent.addAll(items);
//           commjsonFile?.writeAsString(json.encode(commjsonFileContent));
//
//           // print("contennttss ${listOfRegions.runtimeType}");
//         } else {
//           print("didn't work here");
//         }
//       } on SocketException {
//         print("Error is first community");
//       }
//
//       // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
//       // districtjsonFileContent.addAll(content);
//       // districtjsonFile.writeAsString(json.encode(districtjsonFileContent));
//
//       // createFile(content, dir, districtfileName);
//     } else {
//       print("Community File does not exist! $commfileExists");
//       try {
//         var response = await http.get(Uri.parse(commUrl));
//
//         if (response.statusCode == 200) {
//           final items = json.decode(response.body).cast<Map<String, dynamic>>();
//           print("Community");
//
//           print("content $items");
//           print("object");
//
//           // var content = {key: items};
//
//           // var districtjsonFileContent = json.decode(districtjsonFile.readAsStringSync());
//           // districtjsonFileContent.clear();
//           // districtjsonFileContent.addAll(items);
//           // districtjsonFile.writeAsString(json.encode(districtjsonFileContent));
//
//           createCommFile(items, dir!, commfileName);
//
//           // print("contennttss ${listOfRegions.runtimeType}");
//         } else {
//           print("didn't work here");
//           getLocalCommValues(ctx);
//         }
//       } on SocketException {
//         print("Error is second comm");
//         getLocalCommValues(ctx);
//       }
//     }
//     commfileExists
//         ? commfileContent =
//             await json.decode(await commjsonFile!.readAsString())
//         : null;
//     print(commfileContent);
//
//     return commfileExists
//         ? _commValues =
//             commfileContent.map<CommunityJson>(CommunityJson.fromJson).toList()
//         : _newcommValues;
//   }
//
//   Future<List<CommunityJson>> getLocalCommValues(BuildContext context) async {
//     print("doing clocal comm");
//     final assetBundle = DefaultAssetBundle.of(context);
//     final data = await assetBundle.loadString('assets/community.json');
//     final body = json.decode(data);
//
//     _newcommValues = body.map<CommunityJson>(CommunityJson.fromJson).toList();
//
//     return _newcommValues;
//   }
//
//   String? _community;
//   int? _communityVal;
//
//   void _oncommChanged(String commVal) {
//     setState(() {
//       _community = commVal;
//     });
//   }
//
//   commFileInit() {
//     getApplicationDocumentsDirectory().then((Directory directory) async {
//       dir = directory;
//       commjsonFile = new File(dir!.path + "/" + commfileName);
//       commfileExists = commjsonFile!.existsSync();
//       if (commfileExists)
//         commfileContent = await json.decode(await commjsonFile!.readAsString());
//     });
//
//     return commfileContent;
//   }
//
//   Future<List<CommunityJson>>? myCFuture;
//
//   List<String> _commFound = [];
//   bool boxChecked = false;
//
//   onSelectedRow(bool selected, String selectedEst) async {
//     setState(() {
//       if (selected) {
//         _commFound.add(selectedEst);
//       } else {
//         _commFound.remove(selectedEst);
//       }
//     });
//   }
//
//   void _onWLChanged(bool val) {
//     setState(() {
//       boxChecked = val;
//     });
//   }
//
// // update local farmer api list
//
//   void _submissionLoading(ctx) {
//     showDialog(
//         barrierDismissible: false,
//         context: ctx,
//         builder: (BuildContext context) {
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(7.0),
//             child: Container(
//               // width: 5000,
//               child: AlertDialog(
//                 title: new Text(
//                   "Loading data",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                 ),
//                 content: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     new CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(fPrimaryColour),
//                     ),
//                     new Text(
//                       "Please wait a minute...",
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//   void saveToLocalDBSeedling(
//     id,
//     falFarmerName,
//     falCommunityName,
//     falCommunityId,
//     falContact,
//     falBaseline,
//   ) {
//     Provider.of<RegisteredFarmerListApiSeedlingApiProvider>(context,
//             listen: false)
//         .addRegisteredFarmerListApiSeedling(
//       id,
//       falFarmerName,
//       falCommunityName,
//       falCommunityId,
//       falContact,
//       falBaseline,
//     );
//
//     // print("Successfully saved to local DB");
//   }
//
//   Future<dynamic> savetoFarmerApiListSeedling(
//     farmercontact,
//     id,
//     falFarmerName,
//     falCommunityName,
//     falCommunityId,
//     falContact,
//     falBaseline,
//   ) async {
//     final db = await DBHelper.database();
//     // var count = await db
//     //     .rawQuery(
//     //         'SELECT falSContact FROM farmer_api_list_seedling WHERE falSContact'
//     //         ' LIKE $farmercontact')
//     var count = await db.query("farmer_api_list_seedling",
//         where: "falSContact = ?", whereArgs: [farmercontact]).then((value) {
//       if (value.isEmpty) {
//         print("need to save");
//         saveToLocalDBSeedling(
//           id.toString(),
//           falFarmerName,
//           falCommunityName,
//           falCommunityId.toString(),
//           falContact,
//           falBaseline.toString(),
//         );
//       } else {
//         print("Done deal");
//       }
//     });
//     return count;
//   }
//
//   int? index;
//   Future getFarmersApiListSeedling(BuildContext ctx) async {
//     _submissionLoading(ctx);
//
//     overlayNotification('Updating local database', "positive");
//     try {
//       var url = '$stageBaseUrl/farmerlist/?form=seedling';
//
//       var res = await http.get(Uri.parse(url));
//
//       final itemss = json.decode(res.body);
//
//       print("itemss $itemss");
//
//       if (res.statusCode == 200) {
//         var farmerdata = itemss as List;
//         for (var a in farmerdata) {
//           // print("Farmer id ${index + index++}")
//           // ;
//           savetoFarmerApiListSeedling(
//             a["contact"],
//             a["farmerid"].toString(),
//             a["farmer_name"],
//             a["community_name"],
//             a["community"],
//             a["contact"],
//             a["baseline"],
//           );
//           print("$a -- Farmer id ${a["farmer_name"]}");
//         }
//         Navigator.of(context).pop();
//
//         setState(() {
//           indeX = 0;
//         });
//         Navigator.of(context).pop();
//
//         getFarmersApiListAlternative(ctx);
//       } else {
//         overlayNotification('Error occured.', "negative");
//         Navigator.pop(context);
//         print('Error occured.');
//         // return res.statusCode;
//       }
//     } on SocketException catch (e) {
//       print("e === $e");
//       overlayNotification(
//           'Oops! Please connect to the internet to update local data.',
//           "negative");
//       Navigator.of(context).pop();
//     } catch (i) {
//       print("i ===> $i");
//       overlayNotification(i, "negative");
//       Navigator.of(context).pop();
//     }
//   }
//
//   //
//
//   void saveToLocalDBAlternative(
//     id,
//     falFarmerName,
//     falCommunityName,
//     falCommunityId,
//     falContact,
//     falBaseline,
//   ) {
//     Provider.of<RegisteredFarmerListApiAlternativeApiProvider>(context,
//             listen: false)
//         .addRegisteredFarmerListApiAlternative(
//       id,
//       falFarmerName,
//       falCommunityName,
//       falCommunityId,
//       falContact,
//       falBaseline,
//     );
//
//     // print("Successfully saved to local DB");
//   }
//
//   Future<dynamic> savetoFarmerApiListAlternative(
//     farmercontact,
//     id,
//     falFarmerName,
//     falCommunityName,
//     falCommunityId,
//     falContact,
//     falBaseline,
//   ) async {
//     final db = await DBHelper.database();
//     // var count = await db
//     //     .rawQuery(
//     //         'SELECT falAContact FROM farmer_api_list_alternative WHERE falAContact'
//     //         ' LIKE $farmercontact')
//     var count = await db.query("farmer_api_list_alternative",
//         where: "falAContact = ?", whereArgs: [farmercontact]).then((value) {
//       if (value.isEmpty) {
//         print("need to save");
//         saveToLocalDBAlternative(
//           id.toString(),
//           falFarmerName,
//           falCommunityName,
//           falCommunityId.toString(),
//           falContact,
//           falBaseline.toString(),
//         );
//       } else {
//         print("Done deal");
//       }
//     });
//     return count;
//   }
//
//   int? indeX;
//   Future getFarmersApiListAlternative(BuildContext ctx) async {
//     _submissionLoading(ctx);
//
//     overlayNotification('Updating local database', "positive");
//     try {
//       var url = '$stageBaseUrl/farmerlist/?form=alternative';
//
//       var res = await http.get(Uri.parse(url));
//
//       final itemss = json.decode(res.body);
//
//       print("itemss $itemss");
//
//       if (res.statusCode == 200) {
//         overlayNotification('Updated successfully', "positive");
//
//         var farmerdata = itemss as List;
//         for (var a in farmerdata) {
//           // print("Farmer id ${index + index++}")
//           // ;
//           savetoFarmerApiListAlternative(
//             a["contact"],
//             a["farmerid"].toString(),
//             a["farmer_name"],
//             a["community_name"],
//             a["community"],
//             a["contact"],
//             a["baseline"],
//           );
//           print("$a -- Farmer id ${a["farmer_name"]}");
//         }
//         Navigator.of(context).pop();
//         Navigator.of(context).pop();
//       } else {
//         overlayNotification('Error occured.', "negative");
//         Navigator.pop(context);
//         Navigator.of(context).pop();
//         Navigator.of(context).pop();
//         print('Error occured.');
//         // return res.statusCode;
//       }
//     } on SocketException catch (e) {
//       print("e === $e");
//       overlayNotification(
//           'Oops! Please connect to the internet to update local data.',
//           "negative");
//       Navigator.of(context).pop();
//       Navigator.of(context).pop();
//       Navigator.of(context).pop();
//     } catch (i) {
//       print("i ===> $i");
//       overlayNotification(i, "negative");
//       Navigator.of(context).pop();
//       Navigator.of(context).pop();
//       Navigator.of(context).pop();
//     }
//   }
//
//   // save farmer to local db
//   void saveToRegisteredFarmerLocalDB(String con) {
//     Provider.of<RegisteredFarmerProvider>(context, listen: false)
//         .addRegisteredFarmer(
//       _communityVal.toString(),
//       "${_farmerfirstName.text}" +
//           " ${_farmerotherName.text}" +
//           " ${_farmersurName.text}",
//       _farmerContact.text,
//       _farmerGender!,
//       _farmerdOB!,
//       _holderCategory!,
//       _areaSize.text,
//       con,
//     );
//
//     print("Local Registered Farmers");
//     Navigator.pop(context);
//   }
//
//   Future<dynamic> getFarmerFromFarmerOfflineLocalDB(farmercontact) async {
//     print("traversing offline farmer instead");
//     final db = await DBHelper.database();
//     // var count = await db
//     //     .rawQuery(
//     //         'SELECT foCommunity, foFarmerName, foContact, foGender, foDoB,'
//     //         ' foHolderCategory, foFarmSize FROM farmer_offline WHERE foContact'
//     //         ' LIKE $farmercontact')
//     var count = await db.query("farmer_offline",
//         where: "foContact = ?", whereArgs: [farmercontact]).then((value) {
//       if (value.isEmpty) {
//         saveToRegisteredFarmerLocalDB("offline");
//         Navigator.of(context).pop();
//       } else {
//         overlayNotification('Contact number is already in used.', "negative");
//         Navigator.pop(context);
//       }
//     });
//
//     // var list = count.toList();
//     return count;
//   }
//
//   Future<dynamic> getFarmerFromFarmerApiListLocalDB(farmercontact) async {
//     print("traversing local farmer api list");
//     final db = await DBHelper.database();
//     // var count = await db
//     //     .rawQuery(
//     //         'SELECT id FROM farmer_api_list_seedling WHERE falContact LIKE $farmercontact')
//     var count = await db.query("farmer_api_list_seedling",
//         where: "falSContact = ?", whereArgs: [farmercontact]).then((value) {
//       if (value.isEmpty) {
//         print("doing the then bit");
//         getFarmerFromFarmerOfflineLocalDB(farmercontact);
//       } else {
//         print("It isn't empty $value");
//         overlayNotification(
//             'Contact number has already been used.', "negative");
//         Navigator.pop(context);
//       }
//     });
//
//     // var list = count.toList();
//     return count;
//   }
//
// // send farmer data to api
//   _asyncAddFarmer(BuildContext ctx) async {
//     // getSPValues();
//     submissionLoader(ctx, "Uploading data", "Please wait a minute...");
//     // getEnumeratorValue('first_time_user');
//     overlayNotification('Adding farmer... Please wait.', "positive");
//
//     try {
//       var farmerBioData = {
//         "community": _communityVal,
//         "farmer_name": "${_farmerfirstName.text}" +
//             " ${_farmerotherName.text}" +
//             " ${_farmersurName.text}",
//         "contact": _farmerContact.text,
//         "gender": _farmerGender,
//         "dob": _farmerdOB,
//         "small_holder_category": _holderCategory,
//         "farm_size": double.parse(_areaSize.text)
//       };
//
//       var url = '$stageBaseUrl/farmerapi/';
//
//       var body = json.encode(farmerBioData);
//
// //here jsonEncode(data) return String bt in http body you are passing Map value
//
// //So you have to convert String to Map
//       var bodyMap = jsonDecode(body);
//       print(body);
//
// // your nested json data
//       var bodyData = bodyMap;
//
//       var res = await http
//           .post(Uri.parse(url), body: body)
//           .timeout(Duration(seconds: 10), onTimeout: () {
//         print("Timeout section");
//         getFarmerFromFarmerOfflineLocalDB(_farmerContact.text);
//         throw "error caught in timeout";
//       });
//       print("uploading...");
//       print("Statuscode is ${res.statusCode}");
//
//       final itemss = json.decode(res.body);
//
//       print("itemss $body");
//       print(itemss["status"]);
//       var status = itemss["status"];
//
//       if (status == "done") {
//         // saveToLocalDB("connected");
//         overlayNotification(
//             'Data sent successfully with status: $status.', "positive");
//
//         await getFarmersApiListSeedling(this.context);
//
//         regSP?.clear();
//         Navigator.of(context).pop();
//         // return res.statusCode;
//       } else if (status == "exist") {
//         overlayNotification('Data already: $status.', "positive");
//
//         await getFarmersApiListSeedling(this.context);
//
//         Navigator.pop(context);
//       } else {
//         overlayNotification(
//             'Error occured with error: ${itemss["error"]}', "negative");
//         Navigator.pop(context);
//         print('Error occured with error: ${itemss["error"]}');
//         // return res.statusCode;
//       }
//       // newVibe = items[0]["status"];
//     } on SocketException catch (e) {
//       overlayNotification(
//           'Oops! No Internet connection. Data has been saved locally',
//           "negative");
//       print("e === $e");
//       print("No internet section");
//       getFarmerFromFarmerOfflineLocalDB(_farmerContact.text);
//
//       regSP?.clear();
//       Navigator.of(context).pop();
//     } catch (i) {
//       print("i ===> $i");
//       overlayNotification(i, "negative");
//       Navigator.of(context).pop();
//     }
//     // throw "caught exception here";
//   }
//
//   String? _holderCategory;
//   List<String> _holderCategoryValues = [];
//
//   @override
//   void initState() {
//     super.initState();
//     selectedFarmerRadioGender = 0;
//
//     commFileInit();
//     myCFuture = writeToCommFile(this.context);
//
//     _holderCategoryValues.addAll([
//       "Owner",
//       "Share cropper",
//       "Caretaker",
//     ]);
//   }
//
//   setFarmerSelectedGender(val) {
//     setState(() {
//       selectedFarmerRadioGender = val;
//     });
//   }
//
//   void _onIdTypeChanged(String _holderValue) {
//     setState(() {
//       _holderCategory = _holderValue;
//     });
//   }
//
//   var timechecker = DateTime.now().year - 18;
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       appBar: AppBar( foregroundColor: fPrimaryWhite,
//         automaticallyImplyLeading: false,
//         backgroundColor: fPrimaryColour,
//         title: Text(
//           "Farmer Data",
//           style: TextStyle(color: fPrimaryWhite),
//         ),
//         actions: [
//           Tooltip(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: InkWell(
//                 child: Icon(Icons.home,  color: fPrimaryWhite),
//                 onTap: () => Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => IndexPage(),
//                   ),
//                 ),
//               ),
//             ),
//             message: "Takes you back to homepage",
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 30.0,
//             ),
//             Center(
//               child: Container(
//                 // height: MediaQuery.of(context).size.height,
//                 margin: EdgeInsets.all(0.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       // height: MediaQuery.of(context).size.height / 2,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Form(
//                             key: _formKey,
//                             child: Column(
//                               children: [
//                                 Material(
//                                   elevation: 0,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 8.0, right: 8.0, bottom: 20.0),
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Text(
//                                               "Farmer Details",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 24.0),
//                                             ),
//                                           ],
//                                         ),
//                                         titleOne("Farmer Details"),
//                                         formFieldLabel(width: size.width * .9, "Farmer First Name"),
//                                         TextFieldWidget(
//                                           decoration: InputDecoration(
//                                               labelText: "Farmer First Name"),
//                                           controller: _farmerfirstName,
//                                           validator: (input) =>
//                                               input!.trim().isEmpty
//                                                   ? 'Please enter first name'
//                                                   : null,
//                                         ),
//                                         formFieldLabel(width: size.width * .9, "Other Names"),
//                                         TextFieldWidget(
//                                           decoration: InputDecoration(
//                                               labelText: "Other Names"),
//                                           controller: _farmerotherName,
//                                           // validator: (input) => input!.trim().isEmpty
//                                           //     ? 'Please enter name'
//                                           //     : null,
//                                         ),
//                                         formFieldLabel(width: size.width * .9, "Surname Name"),
//                                         TextFieldWidget(
//                                           decoration: InputDecoration(
//                                               labelText: "Surname Name"),
//                                           controller: _farmersurName,
//                                           validator: (input) =>
//                                               input!.trim().isEmpty
//                                                   ? 'Please enter surname'
//                                                   : null,
//                                         ),
//                                         formFieldLabel(width: size.width * .9, "Contact"),
//                                         TextFieldWidget(
//                                           keyboardType: TextInputType.phone,
//                                           maxLength: 10,
//                                           decoration: InputDecoration(
//                                               labelText: "Contact"),
//                                           controller: _farmerContact,
//                                           validator: (input) => input!
//                                                   .trim()
//                                                   .isEmpty
//                                               ? 'Please enter a contact number'
//                                               : null,
//                                         ),
//                                         Container(
//                                           margin: EdgeInsets.symmetric(
//                                               vertical: 20),
//                                           child: new Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: <Widget>[
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             0.0),
//                                                     child: Text(
//                                                       "Date of birth",
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           color:
//                                                               Colors.black54),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(10.0),
//                                                 child: GestureDetector(
//                                                   child: isdateofbirth == true
//                                                       ? Container(
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color:
//                                                                 fPrimaryColour,
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         30),
//                                                           ),
//                                                           height: 40.0,
//                                                           width: MediaQuery.of(
//                                                                       context)
//                                                                   .size
//                                                                   .width /
//                                                               2.5,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .symmetric(
//                                                                     horizontal:
//                                                                         8.0),
//                                                             child: Row(
//                                                               children: <Widget>[
//                                                                 Icon(
//                                                                   Icons
//                                                                       .arrow_drop_down_circle,
//                                                                   size: 22,
//                                                                   color: Color(
//                                                                       0xFFffe423),
//                                                                 ),
//                                                                 Padding(
//                                                                   padding: const EdgeInsets
//                                                                       .symmetric(
//                                                                       horizontal:
//                                                                           8.0),
//                                                                   child: Text(
//                                                                     dateofbirthString ??
//                                                                         "date string",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Color(
//                                                                           0xFFf9f9f9),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         )
//                                                       : Row(
//                                                           children: <Widget>[
//                                                             Icon(
//                                                               Icons
//                                                                   .arrow_drop_down_circle,
//                                                               size: 18,
//                                                               color:
//                                                                   fPrimaryColour,
//                                                             ),
//                                                             Icon(
//                                                               Icons
//                                                                   .calendar_today,
//                                                               // size: 34,
//                                                             ),
//                                                             SizedBox(
//                                                               width: 20,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                   onTap: () {
//                                                     DatePicker.showDatePicker(
//                                                         context,
//                                                         theme: DatePickerTheme(
//                                                           backgroundColor:
//                                                               fPrimaryColour,
//                                                           itemStyle: TextStyle(
//                                                               color: Color(
//                                                                   0xFFf9f9f9)),
//                                                           cancelStyle: TextStyle(
//                                                               color: Color(
//                                                                   0xFFffe423)),
//                                                           doneStyle: TextStyle(
//                                                               color: Color(
//                                                                   0xFFf9f9f9)),
//                                                           containerHeight:
//                                                               210.0,
//                                                         ),
//                                                         showTitleActions: true,
//                                                         minTime: DateTime(1800),
//                                                         maxTime: DateTime(
//                                                             timechecker),
//                                                         onConfirm: (date) {
//                                                       if (DateTime.now().year -
//                                                               date.year <
//                                                           18) {
//                                                         overlayNotification(
//                                                             'Must be 18 years and above',
//                                                             "negative");
//                                                       } else {
//                                                         print('confirm $date');
//                                                         isdateofbirth = true;
//                                                         dateofbirthString =
//                                                             '${date.year}-${date.month}-${date.day}';
//                                                         setState(() {
//                                                           _farmerdOB =
//                                                               '${date.year}-${date.month}-${date.day}';
//                                                           print(
//                                                               "DOOB ${date.year}-${date.month}-${date.day}");
//                                                         });
//                                                       }
//                                                     },
//                                                         // currentTime: DateTime.now(),
//                                                         locale: LocaleType.en);
//                                                   },
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 0.0),
//                                           child: Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: <Widget>[
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             0.0),
//                                                     child: Text(
//                                                       "Gender",
//                                                       style: TextStyle(
//                                                         fontSize: 17,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               ButtonBar(
//                                                 alignment:
//                                                     MainAxisAlignment.start,
//                                                 children: <Widget>[
//                                                   Row(
//                                                     children: <Widget>[
//                                                       GenderRadioButton(
//                                                         value: 1,
//                                                         group:
//                                                             selectedFarmerRadioGender,
//                                                         selected: (val) {
//                                                           print(val);
//                                                           setState(() {
//                                                             selectedFarmerRadioGender =
//                                                                 val;
//                                                             print(val);
//                                                             _farmerGender =
//                                                                 "male";
//                                                           });
//                                                         },
//                                                       ),
//                                                       Text(
//                                                         "Male",
//                                                         // style: TextStyle(
//                                                         //     color: Color(0xFFf9f9f9)),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Row(
//                                                     children: <Widget>[
//                                                       GenderRadioButton(
//                                                         value: 2,
//                                                         group:
//                                                             selectedFarmerRadioGender,
//                                                         selected: (val) {
//                                                           print(val);
//                                                           setState(() {
//                                                             selectedFarmerRadioGender =
//                                                                 val;
//                                                             _farmerGender =
//                                                                 "female";
//                                                           });
//                                                         },
//                                                       ),
//                                                       Text(
//                                                         "Female",
//                                                         // style: TextStyle(
//                                                         //     color:
//                                                         //         Color(0xFFf9f9f9))
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         // !boxChecked
//                                         //     ?
//                                         Container(
//                                           // color: Color(0xFFFFFFFF),
//                                           child: Column(
//                                             children: <Widget>[
//                                               Container(
//                                                 margin: EdgeInsets.only(
//                                                   top: 8.0,
//                                                   left: .0,
//                                                   right: .0,
//                                                   bottom: 18.0,
//                                                 ),
//                                                 child: Column(
//                                                   children: <Widget>[
//                                                     Row(
//                                                       children: <Widget>[
//                                                         Container(
//                                                           margin:
//                                                               EdgeInsets.only(
//                                                             bottom: 14.0,
//                                                           ),
//                                                           child: Row(
//                                                             children: <Widget>[
//                                                               Text(
//                                                                   "Select Community"),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: <Widget>[
//                                                         Container(
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             border: Border.all(
//                                                                 width: 0.50,
//                                                                 color: Color(
//                                                                     0xFF000000)),
//                                                           ),
//                                                           // width: MediaQuery.of(context)
//                                                           //         .size
//                                                           //         .width /
//                                                           //     1.09,
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   6.0),
//                                                           child: FutureBuilder<
//                                                               List<
//                                                                   CommunityJson>>(
//                                                             future: mounted
//                                                                 ? myCFuture
//                                                                 : null,
//                                                             builder: (context,
//                                                                 AsyncSnapshot<
//                                                                         List<
//                                                                             CommunityJson>>
//                                                                     snapshot) {
//                                                               if (snapshot
//                                                                       .connectionState !=
//                                                                   ConnectionState
//                                                                       .done)
//                                                                 return CircularProgressIndicator(
//                                                                   valueColor: AlwaysStoppedAnimation<
//                                                                           Color>(
//                                                                       fPrimaryColour),
//                                                                 );
//                                                               else if (!snapshot
//                                                                   .hasData)
//                                                                 return Text(
//                                                                     "Operation failed. Sync to get data.",
//                                                                     style: TextStyle(
//                                                                         color:
//                                                                             fBackgroundColour));
//                                                               else if (snapshot
//                                                                   .hasData)
//                                                                 return commfileExists
//                                                                     ? Container(
//                                                                         // width: MediaQuery.of(context).size.width / 1.09,
//                                                                         child: StatefulBuilder(builder:
//                                                                             (context,
//                                                                                 state) {
//                                                                           return DropdownButtonHideUnderline(
//                                                                             child:
//                                                                                 new DropdownButton<String>(
//                                                                               value: _community,
//                                                                               items: _commValues.map((CommunityJson dvalue) {
//                                                                                 // fD = dvalue;
//                                                                                 return new DropdownMenuItem<String>(
//                                                                                   value: dvalue.name,
//                                                                                   child: new Row(
//                                                                                     children: <Widget>[
//                                                                                       Padding(
//                                                                                         padding: const EdgeInsets.all(10.0),
//                                                                                         child: new Text(
//                                                                                           "${dvalue.name}",
//                                                                                         ),
//                                                                                       )
//                                                                                     ],
//                                                                                   ),
//                                                                                 );
//                                                                               }).toList(),
//                                                                               onChanged: (String? value) {
//                                                                                 _community = value;
//                                                                                 _oncommChanged(value!);
//
//                                                                                 print("Community"
//                                                                                     "$_community");
//
//                                                                                 _commValues.map((CommunityJson ccvalue) {
//                                                                                   if (ccvalue.name == value) {
//                                                                                     print(ccvalue.comcode);
//
//                                                                                     setState(() {
//                                                                                       _communityVal = ccvalue.comcode;
//
//                                                                                       // opdagSP.setString(
//                                                                                       //     'corptown',
//                                                                                       //     _communityValue);
//
//                                                                                       print("Com COm COm $_communityVal");
//
//                                                                                       // opdagSP.setString(
//                                                                                       //     'communityvalue',
//                                                                                       //     _communityValue);
//                                                                                     });
//                                                                                   }
//                                                                                 }).toString();
//                                                                               },
//                                                                             ),
//                                                                           );
//                                                                         }),
//                                                                       )
//                                                                     : Container(
//                                                                         width: MediaQuery.of(context).size.width /
//                                                                             1.09,
//                                                                         child: StatefulBuilder(builder:
//                                                                             (context,
//                                                                                 state) {
//                                                                           return DropdownButtonHideUnderline(
//                                                                             child:
//                                                                                 new DropdownButton<String>(
//                                                                               value: _community,
//                                                                               items: _newcommValues.map((CommunityJson dvalue) {
//                                                                                 // fD = dvalue;
//                                                                                 return new DropdownMenuItem<String>(
//                                                                                   value: dvalue.name,
//                                                                                   child: new Row(
//                                                                                     children: <Widget>[
//                                                                                       Padding(
//                                                                                         padding: const EdgeInsets.all(10.0),
//                                                                                         child: new Text(
//                                                                                           "${dvalue.name}",
//                                                                                         ),
//                                                                                       )
//                                                                                     ],
//                                                                                   ),
//                                                                                 );
//                                                                               }).toList(),
//                                                                               onChanged: (String? value) {
//                                                                                 _community = value;
//                                                                                 _oncommChanged(value!);
//
//                                                                                 print("Community"
//                                                                                     "$_community");
//
//                                                                                 _newcommValues.map((CommunityJson ccvalue) {
//                                                                                   if (ccvalue.name == value) {
//                                                                                     print(ccvalue.comcode);
//
//                                                                                     setState(() {
//                                                                                       _communityVal = ccvalue.comcode;
//
//                                                                                       // opdagSP.setString(
//                                                                                       //     'corptown',
//                                                                                       //     _communityValue);
//
//                                                                                       print("Com COm COm $_communityVal");
//
//                                                                                       // opdagSP.setString(
//                                                                                       //     'communityvalue',
//                                                                                       //     _communityValue);
//                                                                                     });
//                                                                                   }
//                                                                                 }).toString();
//                                                                               },
//                                                                             ),
//                                                                           );
//                                                                         }),
//                                                                       );
//                                                               else
//                                                                 return Text(
//                                                                   "Please sync data",
//                                                                 );
//                                                             },
//                                                           ),
//                                                         ),
//                                                         IconButton(
//                                                           icon: Icon(
//                                                               Icons.replay),
//                                                           onPressed: () async {
//                                                             setState(() {
//                                                               myCFuture =
//                                                                   writeToCommFile(
//                                                                       this.context);
//                                                             });
//                                                           },
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//
//                                         Container(
//                                           // color: Color(0xFFFFFFFF),
//                                           child: Column(
//                                             children: <Widget>[
//                                               Container(
//                                                 margin: EdgeInsets.only(
//                                                   top: 8.0,
//                                                   left: .0,
//                                                   right: .0,
//                                                   bottom: 18.0,
//                                                 ),
//                                                 child: Column(
//                                                   children: <Widget>[
//                                                     Row(
//                                                       children: <Widget>[
//                                                         Container(
//                                                           margin:
//                                                               EdgeInsets.only(
//                                                             bottom: 14.0,
//                                                           ),
//                                                           child: Row(
//                                                             children: <Widget>[
//                                                               Text(
//                                                                   "Small Holder Category"),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: <Widget>[
//                                                         Container(
//                                                           // constraints:
//                                                           //     BoxConstraints(
//                                                           //         minHeight:
//                                                           //             60),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             border: Border.all(
//                                                                 width: 0.50,
//                                                                 color: Color(
//                                                                     0xFF000000)),
//                                                           ),
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   6.0),
//                                                           child: Container(
//                                                               width: MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .width /
//                                                                   1.09,
//                                                               child:
//                                                                   new DropdownButtonHideUnderline(
//                                                                 child:
//                                                                     new DropdownButton<
//                                                                         String>(
//                                                                   value:
//                                                                       _holderCategory,
//                                                                   items: _holderCategoryValues
//                                                                       .map((String
//                                                                           holderValue) {
//                                                                     // fD = dvalue;
//                                                                     return new DropdownMenuItem(
//                                                                       value:
//                                                                           holderValue,
//                                                                       child:
//                                                                           new Row(
//                                                                         children: <Widget>[
//                                                                           Padding(
//                                                                             padding:
//                                                                                 const EdgeInsets.all(10.0),
//                                                                             child:
//                                                                                 new Text(
//                                                                               "$holderValue",
//                                                                             ),
//                                                                           )
//                                                                         ],
//                                                                       ),
//                                                                     );
//                                                                   }).toList(),
//                                                                   onChanged:
//                                                                       (String?
//                                                                           value) {
//                                                                     _onIdTypeChanged(
//                                                                         value!);
//                                                                   },
//                                                                 ),
//                                                               )),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//
//                                         formFieldLabel(width: size.width * .9, "Area size or farm size (Acre)"),
//                                         TextFieldWidget(
//                                           keyboardType:
//                                               TextInputType.numberWithOptions(),
//                                           decoration: InputDecoration(
//                                               labelText:
//                                                   "Area size or farm size (Acre)"),
//                                           controller: _areaSize,
//                                           validator: (input) =>
//                                               input!.trim().isEmpty
//                                                   ? 'Please enter farm size'
//                                                   : null,
//                                         ),
//                                         // : SizedBox(),
//                                         // new CheckboxListTile(
//                                         //   contentPadding:
//                                         //       EdgeInsets.only(right: 0),
//                                         //   title: Text(
//                                         //     "Check box if community not found",
//                                         //     style: TextStyle(
//                                         //       color: Colors.black,
//                                         //     ),
//                                         //   ),
//                                         //   value: boxChecked,
//                                         //   activeColor: fPrimaryColour,
//                                         //   onChanged: (bool value) {
//                                         //     _onWLChanged(value);
//                                         //   },
//                                         // ),
//                                         // boxChecked
//                                         //     ? TextFieldWidget(
//                                         //         keyboardType:
//                                         //             TextInputType.text,
//                                         //         decoration: InputDecoration(
//                                         //             labelText:
//                                         //                 "(Enter community if not found)"),
//                                         //         controller: _communityName,
//                                         //         validator: (input) => input
//                                         //                 .trim()
//                                         //                 .isEmpty
//                                         //             ? 'Please enter community'
//                                         //             : null,
//                                         //         readOnly: boxChecked
//                                         //             ? false
//                                         //             : boxChecked,
//                                         //       )
//                                         //     : SizedBox(),
//                                         SizedBox(height: 30.0),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceAround,
//                                           children: [
//                                             Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   3,
//                                               height: 50.00,
//                                               child: ElevatedButton(
//                                                 style: ElevatedButton.styleFrom(
//                                                   elevation: 0.0,
//                                                   backgroundColor:
//                                                       fPrimaryColour,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10.0),
//                                                   ),
//                                                   textStyle: const TextStyle(
//                                                       color: fPrimaryWhite),
//                                                   // shadowColor: fPrimaryColour,
//                                                 ),
//                                                 child: Text(
//                                                   "Next",
//                                                   style: TextStyle(
//           color: fPrimaryWhite,
//                                                       fontSize: 17.0,
//                                                       fontWeight:
//                                                           FontWeight.normal),
//                                                 ),
//                                                 onPressed: () async {
//                                                   if (_farmerGender != "male" &&
//                                                       _farmerGender !=
//                                                           "female") {
//                                                     overlayNotification(
//                                                         'Farmer gender not selected',
//                                                         "negative");
//                                                   } else if (_community ==
//                                                           null &&
//                                                       !boxChecked) {
//                                                     overlayNotification(
//                                                         'Please select a community',
//                                                         "negative");
//                                                   } else if (_formKey
//                                                       .currentState!
//                                                       .validate()) {
//                                                     _asyncAddFarmer(context);
//                                                   }
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
