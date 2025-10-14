// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/boilerplate/widgets.dart';
// import 'package:hcms_revived2/main.dart';
// import 'package:hcms_revived2/models/apimodels/districtmodel.dart';
// import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmcordinates.dart';
// import 'package:hcms_revived2/screens/home/index.dart';

// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// class Other extends StatefulWidget {
//   @override
//   _FarmDetailsState createState() => _FarmDetailsState();
// }

// class _FarmDetailsState extends State<Other> {
//   File jsonFile;
//   Directory dir;
//   String fileName = "districts.json";
//   bool fileExists = false;
//   var fileContent;
//   bool confileContent = false;
//   List<DistrictsJson> _newdistrictValues = [];
//   List<DistrictsJson> _districtValues = [];

//   void createFile(var content, Directory dir, String fileName) {
//     print("Creating file!");
//     File file = new File(dir.path + "/" + fileName);
//     file.createSync();
//     fileExists = true;
//     file.writeAsString(json.encode(content));
//     final body = json.decode(json.encode(content));

//     confileContent = true;
//   }

//   Future<List<DistrictsJson>> writeToFile(BuildContext ctx) async {
//     print("Writing to file!");
//     if (fileExists) {
//       print("File exists");

//       try {
//         var response = await http.get(Uri.parse(districtsUrl));

//         if (response.statusCode == 200) {
//           final items = json.decode(response.body).cast<Map<String, dynamic>>();
//           print("responselr");

//           print("content $items");
//           print("object");

//           // var content = {key: items};

//           var jsonFileContent = json.decode(jsonFile.readAsStringSync());
//           jsonFileContent.clear();
//           jsonFileContent.addAll(items);
//           jsonFile.writeAsString(json.encode(jsonFileContent));

//           // print("contennttss ${listOfRegions.runtimeType}");
//         } else {
//           print("didn't work here");
//         }
//       } on SocketException {
//         print("Error is ");
//       }

//       // var jsonFileContent = json.decode(jsonFile.readAsStringSync());
//       // jsonFileContent.addAll(content);
//       // jsonFile.writeAsString(json.encode(jsonFileContent));

//       // createFile(content, dir, fileName);
//     } else {
//       print("File does not exist!");
//       try {
//         var response = await http.get(Uri.parse(districtsUrl));

//         if (response.statusCode == 200) {
//           final items = json.decode(response.body).cast<Map<String, dynamic>>();
//           print("responselr");

//           print("content $items");
//           print("object");

//           // var content = {key: items};

//           // var jsonFileContent = json.decode(jsonFile.readAsStringSync());
//           // jsonFileContent.clear();
//           // jsonFileContent.addAll(items);
//           // jsonFile.writeAsString(json.encode(jsonFileContent));

//           createFile(items, dir, fileName);

//           // print("contennttss ${listOfRegions.runtimeType}");
//         } else {
//           print("didn't work here");
//           getLocalDistricts(ctx);
//         }
//       } on SocketException {
//         print("Error is ");
//         getLocalDistricts(ctx);
//       }
//     }
//     fileExists
//         ? fileContent = await json.decode(await jsonFile.readAsString())
//         : null;
//     print(fileContent);

//     return fileExists
//         ? _districtValues =
//             fileContent.map<DistrictsJson>(DistrictsJson.fromJson).toList()
//         : null;
//   }

//   var districtsUrl = "$stageBaseUrl/districtapi/";
//   Future<List<DistrictsJson>> _tester({BuildContext cotx}) async {
//     try {
//       var response = await http.get(Uri.parse(districtsUrl));

//       if (response.statusCode == 200) {
//         final items = json.decode(response.body).cast<Map<String, dynamic>>();
//         print("responselr");

//         print("content $items");
//         print("object");
//         var confileContent = items;
//         print("contenntt ${confileContent.runtimeType}");

//         // var listOfRegions = items.map((json) {
//         //   return DistrictsJson.fromJson(json);
//         // });

//         // writeToFile(0.toString(), items);
//         // getLocalDistricts(cotx, some: items);

//         // print("contennttss ${listOfRegions.runtimeType}");
//       } else {
//         getLocalDistricts(cotx);
//         print("Worked here");
//       }
//     } catch (o) {
//       getLocalDistricts(cotx);
//       print("Error is $o");
//     }
//   }

//   final _formKey = GlobalKey<FormState>();

// // for form validation
//   int _mmdas;
//   String reg = "";
//   var fD;

//   String _regionValue;
//   String _districtValue;

//   List<String> _regionValues = new List<String>();
//   String _disV;

//   Future<List<DistrictsJson>> getLocalDistricts(BuildContext context) async {
//     final assetBundle = DefaultAssetBundle.of(context);
//     final data = await assetBundle.loadString('assets/districts.json');
//     final body = json.decode(data);

//     _newdistrictValues =
//         body.map<DistrictsJson>(DistrictsJson.fromJson).toList();

//     // writeToFile(body);

//     // _disV = _districtValues[0].districtName;
//     return _districtValues;
//   }

//   void _onRegionChanged(String regVal) {
//     setState(() {
//       _regionValue = regVal;
//     });
//   }

//   void _onDistrictChanged(String disVal) {
//     setState(() {
//       _districtValue = disVal;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getApplicationDocumentsDirectory().then((Directory directory) {
//       dir = directory;
//       jsonFile = new File(dir.path + "/" + fileName);
//       fileExists = jsonFile.existsSync();
//       if (fileExists)
//         this.setState(
//             () => fileContent = json.decode(jsonFile.readAsStringSync()));
//     });

//     reg = "Western Region";
//     fD = "First";

//     _regionValues.addAll([
//       "Western Region",
//     ]);
//     _regionValue = _regionValues.elementAt(0);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar( foregroundColor: fPrimaryWhite,
//         automaticallyImplyLeading: false,
//         title: Text(
//           "Registration of Planted Trees",
//         ),
//         actions: [
//           Tooltip(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: InkWell(
//                 child: Icon(
//                   Icons.home,  color: fPrimaryWhite,
//                 ),
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
//         child: Container(
//           // height: size.height,
//           margin: EdgeInsets.all(0.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: fDefaultPadding),
//                         child: Center(
//                           child: Text(
//                             "Tree Farm Information",
//                             style: TextStyle(
//                                 fontSize: 20.0, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         color: Color(0xFFFFFFFF),
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                                 margin: EdgeInsets.all(8.0),
//                                 child: Column(children: <Widget>[
//                                   Row(
//                                     children: <Widget>[
//                                       Container(
//                                         margin: EdgeInsets.only(
//                                           bottom: 14.0,
//                                         ),
//                                         child: Row(
//                                           children: <Widget>[
//                                             Text("Select Region"),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: <Widget>[
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                               width: 0.50,
//                                               color: Color(0xFF000000)),
//                                         ),
//                                         width:
//                                             MediaQuery.of(context).size.width /
//                                                 1.09,
//                                         padding: EdgeInsets.all(6.0),
//                                         child: DropdownButtonHideUnderline(
//                                           child: new DropdownButton(
//                                             value: _regionValue,
//                                             items: _regionValues
//                                                 .map((String rvalue) {
//                                               return new DropdownMenuItem(
//                                                 value: rvalue,
//                                                 child: new Row(
//                                                   children: <Widget>[
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               10.0),
//                                                       child: new Text(
//                                                         "$rvalue",
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               );
//                                             }).toList(),
//                                             onChanged: (String value) {
//                                               _onRegionChanged(value);
//                                               reg = value;
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ])),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         color: Color(0xFFFFFFFF),
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.only(
//                                 top: 8.0,
//                                 left: 8.0,
//                                 right: 8.0,
//                                 bottom: 18.0,
//                               ),
//                               child: Column(
//                                 children: <Widget>[
//                                   Row(
//                                     children: <Widget>[
//                                       Container(
//                                         margin: EdgeInsets.only(
//                                           bottom: 14.0,
//                                         ),
//                                         child: Row(
//                                           children: <Widget>[
//                                             Text("Select Forest District"),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: <Widget>[
//                                       Container(
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 width: 0.50,
//                                                 color: Color(0xFF000000)),
//                                           ),
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               1.09,
//                                           padding: EdgeInsets.all(6.0),
//                                           child: FutureBuilder<
//                                               List<DistrictsJson>>(
//                                             future: writeToFile(context),
//                                             builder: (context, snapshot) {
//                                               return fileExists
//                                                   ? DropdownButtonHideUnderline(
//                                                       child: new DropdownButton<
//                                                           String>(
//                                                         value: _disV,
//                                                         items: _districtValues
//                                                             .map((DistrictsJson
//                                                                 dvalue) {
//                                                           fD = dvalue;
//                                                           return new DropdownMenuItem<
//                                                               String>(
//                                                             value:
//                                                                 dvalue.district,
//                                                             child: new Row(
//                                                               children: <
//                                                                   Widget>[
//                                                                 Padding(
//                                                                   padding:
//                                                                       const EdgeInsets
//                                                                               .all(
//                                                                           10.0),
//                                                                   child:
//                                                                       new Text(
//                                                                     "${dvalue.district}",
//                                                                   ),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           );
//                                                         }).toList(),
//                                                         onChanged:
//                                                             (String value) {
//                                                           _disV = value;
//                                                           _onDistrictChanged(
//                                                               value);
//                                                           // fD = value;
//                                                           // print(_districtValues
//                                                           //     .elementAt(_districtValues
//                                                           //         .indexOf(value))
//                                                           //     .districtcode);
//                                                           // _districtValues.map(
//                                                           //     (DistrictsJson
//                                                           //         ddvalue) {
//                                                           //   if (ddvalue.district ==
//                                                           //       value) {
//                                                           //     print(ddvalue
//                                                           //         .districtcode);
//                                                           //   }
//                                                           // }).toString();
//                                                         },
//                                                       ),
//                                                     )
//                                                   : DropdownButtonHideUnderline(
//                                                       child: new DropdownButton<
//                                                           String>(
//                                                         value: _disV,
//                                                         items: _newdistrictValues
//                                                             .map((DistrictsJson
//                                                                 dvalue) {
//                                                           fD = dvalue;
//                                                           return new DropdownMenuItem<
//                                                               String>(
//                                                             value:
//                                                                 dvalue.district,
//                                                             child: new Row(
//                                                               children: <
//                                                                   Widget>[
//                                                                 Padding(
//                                                                   padding:
//                                                                       const EdgeInsets
//                                                                               .all(
//                                                                           10.0),
//                                                                   child:
//                                                                       new Text(
//                                                                     "${dvalue.district}",
//                                                                   ),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           );
//                                                         }).toList(),
//                                                         onChanged:
//                                                             (String value) {
//                                                           _disV = value;
//                                                           _onDistrictChanged(
//                                                               value);
//                                                           // fD = value;
//                                                           // print(_districtValues
//                                                           //     .elementAt(_districtValues
//                                                           //         .indexOf(value))
//                                                           //     .districtcode);
//                                                           // _districtValues.map(
//                                                           //     (DistrictsJson
//                                                           //         ddvalue) {
//                                                           //   if (ddvalue.district ==
//                                                           //       value) {
//                                                           //     print(ddvalue
//                                                           //         .districtcode);
//                                                           //   }
//                                                           // }).toString();
//                                                         },
//                                                       ),
//                                                     );
//                                             },
//                                           )),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                         color: Color(0xFFFFFFFF),
//                         child: Column(
//                           children: <Widget>[
//                             Column(
//                               children: <Widget>[
//                                 Container(
//                                   width: MediaQuery.of(context).size.width / 3,
//                                   height: 50.00,
//                                   child: RaisedButton(
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     child: Text(
//                                       "Next",
//                                       style: TextStyle(
//                                           fontSize: 17.0,
//                                           fontWeight: FontWeight.normal),
//                                     ),
//                                     color: fPrimaryColour,
//                                     textColor: Colors.white,
//                                     onPressed: () async {
//                                       _tester();
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget _pickImage(String name, String dir) {
//   //   if (_theme != AppTheme.candy) {
//   //     var file = _getLocalImageFile(name, dir);
//   //     return Image.file(file);
//   //   }
//   //   return Image.asset('assets/images/$name');
//   // }

//   // File _getLocalImageFile(String name, String dir) => File('$dir/$name');

//   // Future<void> _downloadAssets(String name) async {
//   //   if (_dir == null) {
//   //     _dir = (await getApplicationDocumentsDirectory()).path;
//   //   }

//   //   if (!await _hasToDownloadAssets(name, _dir)) {
//   //     return;
//   //   }
//   //   var zippedFile = await _downloadFile(
//   //       '$api/$name.zip?alt=media&token=7442d067-a656-492f-9791-63e8fc082379',
//   //       '$name.zip',
//   //       _dir);

//   //   var bytes = zippedFile.readAsBytesSync();
//   //   var archive = ZipDecoder().decodeBytes(bytes);

//   //   for (var file in archive) {
//   //     var filename = '$_dir/${file.name}';
//   //     if (file.isFile) {
//   //       var outFile = File(filename);
//   //       outFile = await outFile.create(recursive: true);
//   //       await outFile.writeAsBytes(file.content);
//   //     }
//   //   }
//   // }

//   // Future<bool> _hasToDownloadAssets(String name, String dir) async {
//   //   var file = File('$dir/$name.zip');
//   //   return !(await file.exists());
//   // }

//   // Future<File> _downloadFile(String url, String filename, String dir) async {
//   //   var req = await http.Client().get(Uri.parse(Uri.parse(url)));
//   //   var file = File('$dir/$filename');
//   //   return file.writeAsBytes(req.bodyBytes);
//   // }
// }
