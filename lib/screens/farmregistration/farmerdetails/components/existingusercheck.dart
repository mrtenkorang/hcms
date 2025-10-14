import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/personalfarmerprovideroffline.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/components/groupdetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/farmerdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/treedetails.dart';
import 'package:hcms_revived2/screens/treemonitoring/seedlingMonitoring/updateseedVisit.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class ExistingUserCheck extends StatefulWidget {
  final String? beneficiaryType;
  const ExistingUserCheck({Key? key, this.beneficiaryType}) : super(key: key);

  @override
  _ExistingUserCheckState createState() => _ExistingUserCheckState();
}

class _ExistingUserCheckState extends State<ExistingUserCheck> {
  final _formKey = GlobalKey<FormState>();

  final _farmerContact = TextEditingController();

// search offline farmer database
// Individual farmer
  Future<dynamic> getIndiviFarmerFromFarmerOfflineLocalDB(farmercontact) async {
    print("traversing offline tree farmer instead");
    final db = await DBHelper.database();
    var count = await db.query("tree_farmer_offline",
        where: "tfoFarmerPhoneNum = ?",
        whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        Navigator.pop(context);
        overlayNotification('Account not found.', "negative");
      } else {
        Navigator.pop(context);

        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => FarmerDetails(
              retfamerProfilePic: "seen",
              retfarmerfirstName: value[0]["tfaFarmerfirstName"].toString(),
              retfarmersurName: value[0]["tfaFarmersurName"].toString(),
              retfarmerotherName: value[0]["tfaFarmerotherName"].toString(),
              retfarmerGender: value[0]["tfaFarmerGender"].toString(),
              retfarmerDoB: value[0]["tfaFarmerDoB"].toString(),
              retfarmerPostal: value[0]["tfaFarmerPostal"].toString(),
              retfarmerPhoneNum: value[0]["tfaFarmerPhoneNum"].toString(),
              retfarmerMail: value[0]["tfaFarmerMail"].toString(),
              retkinName: value[0]["tfaKinName"].toString(),
              retkinPhoneNum: value[0]["tfaKinPhoneNum"].toString(),
              retkinGender: value[0]["tfaKinGender"].toString(),
              retkinPostal: value[0]["tfaKinPostal"].toString(),
              retkinDoB: value[0]["tfaKinDoB"].toString(),
              retkinRelationship: value[0]["tfaKinRelationShip"].toString(),
            ),
          ),
        );

        overlayNotification('Record found', "positive");
      }
    });

    return count;
  }

// Group farmer
  Future<dynamic> getGroupFarmerFromFarmerOfflineLocalDB(farmercontact) async {
    print("traversing offline tree farmer instead");
    final db = await DBHelper.database();
    var count = await db.query("tree_farmer_offline",
        where: "tfoGroupphoneNumber = ?",
        whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        Navigator.pop(context);
        overlayNotification('Account not found.', "negative");
      } else {
        Navigator.pop(context);

        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => GroupDetails(
                  retcompanyDirectors: value[0]["tfoGroupDirectors"].toString(),
                  retgroupName: value[0]["tfoGroupName"].toString(),
                  retgroupPresident: value[0]["tfoGroupPresident"].toString(),
                  retgroupSecretary: value[0]["tfoGroupSecretary"].toString(),
                  retgroupPhone: value[0]["tfoGroupphoneNumber"].toString(),
                  retgroupregNumb: value[0]["tfoGroupphoneNumber"].toString(),
                  retgroupEmail: value[0]["tfoGroupEmail"].toString(),
                  retgroupAddress: value[0]["tfoGroupAddress"].toString(),
                )));

        overlayNotification('Record found', "positive");
      }
    });

    return count;
  }

// search local api tree farmer database
//Individual
  Future<dynamic> getIndiviFarmerFromFarmerApiListLocalDB(farmercontact) async {
    print("traversing local tree farmer api list");
    final db = await DBHelper.database();
    var count = await db.query("tree_farmer_api_list",
        where: widget.beneficiaryType == "Individual"
            ? "tfaFarmerPhoneNum = ?"
            : "tfaGroupphoneNumber = ?",
        whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        print("doing tree farmer offline check ${widget.beneficiaryType}");
        widget.beneficiaryType == "Individual"
            ? getIndiviFarmerFromFarmerOfflineLocalDB(farmercontact)
            : getGroupFarmerFromFarmerOfflineLocalDB(farmercontact);
      } else {
        print("It isn't empty $value");
        Navigator.pop(context);

        widget.beneficiaryType == "Individual"
            ? Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => FarmerDetails(
                    retfamerProfilePic: "seen",
                    retfarmerfirstName:
                        value[0]["tfaFarmerfirstName"].toString(),
                    retfarmersurName: value[0]["tfaFarmersurName"].toString(),
                    retfarmerotherName:
                        value[0]["tfaFarmerotherName"].toString(),
                    retfarmerGender: value[0]["tfaFarmerGender"].toString(),
                    retfarmerDoB: value[0]["tfaFarmerDoB"].toString(),
                    retfarmerPostal: value[0]["tfaFarmerPostal"].toString(),
                    retfarmerPhoneNum: value[0]["tfaFarmerPhoneNum"].toString(),
                    retfarmerMail: value[0]["tfaFarmerMail"].toString(),
                    retkinName: value[0]["tfaKinName"].toString(),
                    retkinPhoneNum: value[0]["tfaKinPhoneNum"].toString(),
                    retkinGender: value[0]["tfaKinGender"].toString(),
                    retkinPostal: value[0]["tfaKinPostal"].toString(),
                    retkinDoB: value[0]["tfaKinDoB"].toString(),
                    retkinRelationship:
                        value[0]["tfaKinRelationShip"].toString(),
                  ),
                ),
              )
            : Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => GroupDetails(
                      retcompanyDirectors:
                          value[0]["tfaGroupDirectors"].toString(),
                      retgroupName: value[0]["tfaGroupName"].toString(),
                      retgroupPresident:
                          value[0]["tfaGroupPresident"].toString(),
                      retgroupSecretary:
                          value[0]["tfaGroupSecretary"].toString(),
                      retgroupPhone: value[0]["tfaGroupphoneNumber"].toString(),
                      retgroupregNumb:
                          value[0]["tfaGroupphoneNumber"].toString(),
                      retgroupEmail: value[0]["tfaGroupEmail"].toString(),
                      retgroupAddress: value[0]["tfaGroupAddress"].toString(),
                    )));

        overlayNotification('Farmer details found.', "positive");
      }
    });

    return count;
  }

// save tree farmer api data locally
  int? index;
  Future saveTreeFarmerApiList(BuildContext ctx) async {
    overlayNotification('Updating local database', "positive");
    try {
      var url = '$stageBaseUrl/fetchalltreefarmer/';

      var res = await http.get(Uri.parse(url));

      final itemss = json.decode(res.body);

      print("itemss $itemss");

      if (res.statusCode == 200) {
        var farmerdata = itemss as List;
        for (var a in farmerdata) {
          // print("Farmer id ${index + index++}")
          // ;
          Provider.of<PersonalFarmerProviderApiList>(context, listen: false)
              .addPersonalFarmerApiList(
            a["type_beneficiary"].toString(),
            "",
            a["indvi_first_name"].toString(),
            a["indvi_other_names"].toString(),
            a["indvi_surname"].toString(),
            a["indvi_gender"].toString(),
            a["indvi_phone_no"].toString(),
            a["indvi_dob"].toString(),
            a["indvi_email"].toString(),
            a["indvi_address"].toString(),
            a["indvi_next_of_kin"].toString(),
            a["indvi_relationship"].toString(),
            a["indvi_next_of_kin_dob"].toString(),
            a["indvi_next_of_kin_gender"].toString(),
            a["indvi_next_of_kin_phone_no"].toString(),
            a["indvi_next_of_kin_address"].toString(),
            "",
            a["group_name"].toString(),
            a["group_president"].toString(),
            a["group_secretary"].toString(),
            a["group_phone"].toString(),
            a["group_directors"].toString(),
            a["group_email"].toString(),
            a["group_company_add"].toString(),
            "",
            "",
          );
          print("$a -- Farmer id ${a["farmer_name"]}");
        }
        Navigator.of(context).pop();

        Navigator.of(context).pop();
      } else {
        // overlayNotification('Error occured.', "negative");
        Navigator.pop(context);
        print('Error occured.');
        // return res.statusCode;
      }
    } on SocketException catch (e) {
      print("e === $e");
      // overlayNotification(
      //     'Oops! Please connect to the internet to update local data.',
      //     "negative");
      Navigator.of(context).pop();
    } catch (i) {
      print("i ===> $i");
      overlayNotification(i, "negative");
      Navigator.of(context).pop();
    }
  }

  _asyncSearchFarmerOnline(BuildContext ctx) async {
    submissionLoader(ctx, "Retrieving account", "Please wait a minute...");
    var newVibe, newBene;
    try {
      final response = await http.get(Uri.parse(
          "$stageBaseUrl/searchtreeregisterfarmer/?contact=${_farmerContact.text}"));

      final items = json.decode(response.body);

      print(response.body);
      print(items);
      newVibe = items["farmerid"];
      newBene = items["type_beneficiary"];

      print("Vibely new vibe $newVibe");

      try {
        if (newVibe != null) {
          Navigator.of(context).pop();
          regSP
              ?.setString("farmerId", items["farmerid"])
              .then((value) => newBene == "Individual"
                  ? Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => FarmerDetails(
                          retfamerProfilePic: "seen",
                          retfarmerfirstName: items["indvi_first_name"],
                          retfarmersurName: items["indvi_surname"],
                          retfarmerotherName: items["indvi_other_names"],
                          retfarmerGender: items["indvi_gender"],
                          retfarmerDoB: items["indvi_dob"],
                          retfarmerPostal: items["indvi_address"],
                          retfarmerPhoneNum: items["indvi_phone_no"],
                          retfarmerMail: items["indvi_email"],
                          retkinName: items["indvi_next_of_kin"],
                          retkinPhoneNum: items["indvi_next_of_kin_phone_no"],
                          retkinGender: items["indvi_next_of_kin_gender"],
                          retkinPostal: items["indvi_next_of_kin_address"],
                          retkinDoB: items["indvi_next_of_kin_dob"],
                          retkinRelationship: items["indvi_relationship"],
                        ),
                      ),
                    )
                  : Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => GroupDetails(
                            retcompanyDirectors: items["group_directors"],
                            retgroupName: items["group_name"],
                            retgroupPresident: items["group_president"],
                            retgroupSecretary: items["group_secretary"],
                            retgroupPhone: items["group_phone"],
                            retgroupregNumb: items["group_phone"],
                            retgroupEmail: items["group_email"],
                            retgroupAddress: items["group_company_add"],
                          ))));

          overlayNotification('Record found.', "positive");
          print("Scale 2");
        } else {
          getIndiviFarmerFromFarmerApiListLocalDB(_farmerContact.text);

          print("Exception part caught");
          print("Scale 5");
        }
      } on SocketException catch (_) {
        overlayNotification(
            'No internet connection. Searching local database...', "negative");

        getIndiviFarmerFromFarmerApiListLocalDB(_farmerContact.text);
        print("Fireabse Notification failed");
        print("Scale 6");
      }

      return response;
    } on SocketException {
      overlayNotification(
          'No internet connection. Searching local database...', "negative");

      getIndiviFarmerFromFarmerApiListLocalDB(_farmerContact.text);
      print("Scale 7");
    }
  }

  @override
  void initState() {
    super.initState();
    regSP!.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
        automaticallyImplyLeading: false,
        backgroundColor: fPrimaryColour,
        title: Text(
          "Search for Account",
          style: TextStyle(color: fPrimaryWhite),
        ),
        actions: [
          Tooltip(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: InkWell(
                child: Icon(Icons.home,  color: fPrimaryWhite),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => IndexPage(),
                  ),
                ),
              ),
            ),
            message: "Takes you back to homepage",
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ],
                ),

                Container(
                  // height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Material(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20.0),
                                child: Column(
                                  children: [
                                    formFieldLabel(width: size.width * .9, "Enter contact of registered farmer"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                          labelText:
                                              "Enter contact of registered farmer"),
                                      controller: _farmerContact,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please enter a contact number'
                                              : null,
                                    ),
                                    SizedBox(height: 30.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: 50.00,
                                          child:
                                              // _visitNumber == "1" ||
                                              //         _visitNumber == null
                                              //     ? RaisedButton(
                                              //         elevation: 0,
                                              //         shape: RoundedRectangleBorder(
                                              //           borderRadius:
                                              //               BorderRadius.circular(
                                              //                   10.0),
                                              //         ),
                                              //         child: Text(
                                              //           "Next",
                                              //           style: TextStyle(
                                              //               fontSize: 17.0,
                                              //               fontWeight:
                                              //                   FontWeight.normal),
                                              //         ),
                                              //         color: fPrimaryColour,
                                              //         textColor: Colors.white,
                                              //         onPressed: () async {
                                              //           if (_visitNumber == null) {
                                              //             Alert.showSnackBar(
                                              //               context,
                                              //               text:
                                              //                   'Please select an order of visit',
                                              //               color: Colors.red,
                                              //             );
                                              //           } else if (_visitDateYear ==
                                              //               null) {
                                              //             Alert.showSnackBar(
                                              //               context,
                                              //               text:
                                              //                   'Please select date year',
                                              //               color: Colors.red,
                                              //             );
                                              //           } else if (_formKey
                                              //               .currentState
                                              //               .validate()) {
                                              //             setSMValuesT();
                                              //             // regSP?.setBool(
                                              //             //     "farmerskipped", false);
                                              //             Navigator.of(context)
                                              //                 .push(
                                              //               CupertinoPageRoute(
                                              //                 builder: (BuildContext
                                              //                         context) =>
                                              //                     SeedlingFarmer(),
                                              //               ),
                                              //             );
                                              //           }
                                              //         },
                                              //       )
                                              //     :
                                              ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0.0,
                                              backgroundColor: fPrimaryColour,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              textStyle: const TextStyle(
                                                  color: Colors.white),
                                              // shadowColor: fPrimaryColour,
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: fPrimaryColour),
                                            ),
                                            child: Text(
                                              "Next",
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  fontWeight:
                                                      FontWeight.normal, color: Colors.white),
                                            ),
                                            onPressed: () async {
                                              // if (_visitNumber == null) {
                                              //   Alert.showSnackBar(
                                              //     context,
                                              //     text:
                                              //         'Please select an order of visit',
                                              //     color: Colors.red,
                                              //   );
                                              // } else
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _asyncSearchFarmerOnline(
                                                    context);
                                              }
                                            },
                                          ),
                                        ),
                                        // RaisedButton(
                                        //   elevation: 0,
                                        //   shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //         BorderRadius.circular(10.0),
                                        //   ),
                                        //   child: Text(
                                        //     "Delee",
                                        //     style: TextStyle(
                                        //         fontSize: 17.0,
                                        //         fontWeight: FontWeight.normal),
                                        //   ),
                                        //   color: fPrimaryColour,
                                        //   textColor: Colors.white,
                                        //   onPressed: () async {
                                        //     DBHelper.deleteLFD("farmer_offline",
                                        //         _farmerContact.text);
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        child: Align(
                          // alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 10.0,
                            ),
                            width: MediaQuery.of(context).size.width * .6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: fPrimaryColour,
                                border: Border(
                                  top: BorderSide(
                                    width: 1.0,
                                    color: fPrimaryColour,
                                  ),
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: fPrimaryColour,
                                  ),
                                  left: BorderSide(
                                    width: 1.0,
                                    color: fPrimaryColour,
                                  ),
                                  right: BorderSide(
                                    width: 1.0,
                                    color: fPrimaryColour,
                                  ),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "New farmer",
                                  style: TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    widget.beneficiaryType == "Individual"
                                        ? Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  FarmerDetails(
                                                retfamerProfilePic: "",
                                                retfarmerfirstName: "",
                                                retfarmersurName: "",
                                                retfarmerotherName: "",
                                                retfarmerGender: "",
                                                retfarmerDoB: "",
                                                retfarmerPostal: "",
                                                retfarmerPhoneNum: "",
                                                retfarmerMail: "",
                                                retkinName: "",
                                                retkinPhoneNum: "",
                                                retkinGender: "",
                                                retkinPostal: "",
                                                retkinDoB: "",
                                                retkinRelationship: "",
                                              ),
                                            ),
                                          )
                                        : Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    GroupDetails(
                                                      retcompanyDirectors: "",
                                                      retgroupName: "",
                                                      retgroupPresident: "",
                                                      retgroupSecretary: "",
                                                      retgroupPhone: "",
                                                      retgroupregNumb: "",
                                                      retgroupEmail: "",
                                                      retgroupAddress: "",
                                                    )));
                                  },
                                  icon: Icon(Icons.add, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     Text(
                      //       "Don't have any record?",
                      //       style: TextStyle(
                      //         color: Colors.black54,
                      //         fontSize: 18.0,
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {
                      //         Navigator.of(context).push(
                      //           CupertinoPageRoute(
                      //             builder: (context) => FarmerDetails(
                      //               retfamerProfilePic: "",
                      //               retfarmerfirstName: "",
                      //               retfarmersurName: "",
                      //               retfarmerotherName: "",
                      //               retfarmerGender: "",
                      //               retfarmerDoB: "",
                      //               retfarmerPostal: "",
                      //               retfarmerPhoneNum: "",
                      //               retfarmerMail: "",
                      //               retkinName: "",
                      //               retkinPhoneNum: "",
                      //               retkinGender: "",
                      //               retkinPostal: "",
                      //               retkinDoB: "",
                      //               retkinRelationship: "",
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //       icon: Icon(
                      //         Icons.arrow_forward_ios,
                      //         size: 30.0,
                      //         color: fPrimaryColour,
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
                // Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
