import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkit;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/providers/personalfarmerprovideroffline.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/components/groupdetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/components/personalDetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/farmerdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/buttons/custombuttons.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';

class TreeFarmerSearchandType extends StatefulWidget {
  const TreeFarmerSearchandType({
    Key? key,
  }) : super(key: key);
  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<TreeFarmerSearchandType> {
  final _formKey = GlobalKey<FormState>();

  final _farmerContact = TextEditingController();

  String? retfamerProfilePic;
  String? retfarmerfirstName;
  String? retfarmersurName;
  String? retfarmerotherName;
  String? retfarmerGender;
  String? retfarmerDoB;
  String? retfarmerPostal;
  String? retfarmerPhoneNum;
  String? retfarmerMail;
  String? retkinName;
  String? retkinPhoneNum;
  String? retkinGender;
  String? retkinPostal;
  String? retkinDoB;
  String? retkinRelationship;

  String? retcompanyDirectors;
  String? retgroupName;
  String? retgroupPresident;
  String? retgroupSecretary;
  String? retgroupPhone;
  String? retgroupregNumb;
  String? retgroupEmail;
  String? retgroupAddress;

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
        overlayNotification(
            'Account not found. Select other tab and search again.',
            "negative");
      } else {
        Navigator.pop(context);

        // Navigator.of(context).push(
        //   CupertinoPageRoute(
        //     builder: (context) => FarmerDetails(
        setState(() {
          retfamerProfilePic = "seen";
          retfarmerfirstName = value[0]["tfaFarmerfirstName"].toString();
          retfarmersurName = value[0]["tfaFarmersurName"].toString();
          retfarmerotherName = value[0]["tfaFarmerotherName"].toString();
          retfarmerGender = value[0]["tfaFarmerGender"].toString();
          retfarmerDoB = value[0]["tfaFarmerDoB"].toString();
          retfarmerPostal = value[0]["tfaFarmerPostal"].toString();
          retfarmerPhoneNum = value[0]["tfaFarmerPhoneNum"].toString();
          retfarmerMail = value[0]["tfaFarmerMail"].toString();
          retkinName = value[0]["tfaKinName"].toString();
          retkinPhoneNum = value[0]["tfaKinPhoneNum"].toString();
          retkinGender = value[0]["tfaKinGender"].toString();
          retkinPostal = value[0]["tfaKinPostal"].toString();
          retkinDoB = value[0]["tfaKinDoB"].toString();
          retkinRelationship = value[0]["tfaKinRelationShip"].toString();
        });
        //     ),
        //   ),
        // );

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
        overlayNotification(
            'Account not found. Select other tab and search again.',
            "negative");
      } else {
        Navigator.pop(context);

        // Navigator.of(context).push(CupertinoPageRoute(
        //     builder: (context) => GroupDetails(
        setState(() {
          retcompanyDirectors = value[0]["tfoGroupDirectors"].toString();
          retgroupName = value[0]["tfoGroupName"].toString();
          retgroupPresident = value[0]["tfoGroupPresident"].toString();
          retgroupSecretary = value[0]["tfoGroupSecretary"].toString();
          retgroupPhone = value[0]["tfoGroupphoneNumber"].toString();
          retgroupregNumb = value[0]["tfoGroupphoneNumber"].toString();
          retgroupEmail = value[0]["tfoGroupEmail"].toString();
          retgroupAddress = value[0]["tfoGroupAddress"].toString();
        });
        // )));

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
        where: selectedFarmerType == "Individual"
            ? "tfaFarmerPhoneNum = ?"
            : "tfaGroupphoneNumber = ?",
        whereArgs: [farmercontact]).then((value) {
      if (value.isEmpty) {
        print("doing tree farmer offline check $selectedFarmerType");
        selectedFarmerType == "Individual"
            ? getIndiviFarmerFromFarmerOfflineLocalDB(farmercontact)
            : getGroupFarmerFromFarmerOfflineLocalDB(farmercontact);
      } else {
        print("It isn't empty $value");
        Navigator.pop(context);

        selectedFarmerType == "Individual"
            ?
            // Navigator.of(context).push(
            //     CupertinoPageRoute(
            //       builder: (context) => FarmerDetails(
            setState(() {
                retfamerProfilePic = "seen";
                retfarmerfirstName = value[0]["tfaFarmerfirstName"].toString();
                retfarmersurName = value[0]["tfaFarmersurName"].toString();
                retfarmerotherName = value[0]["tfaFarmerotherName"].toString();
                retfarmerGender = value[0]["tfaFarmerGender"].toString();
                retfarmerDoB = value[0]["tfaFarmerDoB"].toString();
                retfarmerPostal = value[0]["tfaFarmerPostal"].toString();
                retfarmerPhoneNum = value[0]["tfaFarmerPhoneNum"].toString();
                retfarmerMail = value[0]["tfaFarmerMail"].toString();
                retkinName = value[0]["tfaKinName"].toString();
                retkinPhoneNum = value[0]["tfaKinPhoneNum"].toString();
                retkinGender = value[0]["tfaKinGender"].toString();
                retkinPostal = value[0]["tfaKinPostal"].toString();
                retkinDoB = value[0]["tfaKinDoB"].toString();
                retkinRelationship = value[0]["tfaKinRelationShip"].toString();
              })
            //     ),
            //   ),
            // )
            :
            // Navigator.of(context).push(CupertinoPageRoute(
            //     builder: (context) => GroupDetails(
            setState(() {
                retcompanyDirectors = value[0]["tfaGroupDirectors"].toString();
                retgroupName = value[0]["tfaGroupName"].toString();
                retgroupPresident = value[0]["tfaGroupPresident"].toString();
                retgroupSecretary = value[0]["tfaGroupSecretary"].toString();
                retgroupPhone = value[0]["tfaGroupphoneNumber"].toString();
                retgroupregNumb = value[0]["tfaGroupphoneNumber"].toString();
                retgroupEmail = value[0]["tfaGroupEmail"].toString();
                retgroupAddress = value[0]["tfaGroupAddress"].toString();
              });
        // )));

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

  Future _asyncSearchFarmerOnline(BuildContext ctx) async {
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
          regSP?.setString("farmerId", items["farmerid"]).then(
                (value) => newBene == "Individual"
                    ?
                    // Navigator.of(context).push(
                    //     CupertinoPageRoute(
                    //       builder: (context) => FarmerDetails(
                    setState(() {
                        selectedFarmerType = "Individual";
                        regSP?.setString(
                            '_beneficiaryType', selectedFarmerType);

                        retfamerProfilePic = "seen";
                        retfarmerfirstName = items["indvi_first_name"];
                        retfarmersurName = items["indvi_surname"];
                        retfarmerotherName = items["indvi_other_names"];
                        retfarmerGender = items["indvi_gender"];
                        retfarmerDoB = items["indvi_dob"];
                        retfarmerPostal = items["indvi_address"];
                        retfarmerPhoneNum = items["indvi_phone_no"];
                        retfarmerMail = items["indvi_email"];
                        retkinName = items["indvi_next_of_kin"];
                        retkinPhoneNum = items["indvi_next_of_kin_phone_no"];
                        retkinGender = items["indvi_next_of_kin_gender"];
                        retkinPostal = items["indvi_next_of_kin_address"];
                        retkinDoB = items["indvi_next_of_kin_dob"];
                        retkinRelationship = items["indvi_relationship"];
                      })
                    //     ),
                    //   ),
                    // )
                    :
                    // Navigator.of(context).push(CupertinoPageRoute(
                    //     builder: (context) => GroupDetails(
                    setState(() {
                        selectedFarmerType = "Group";
                        regSP?.setString(
                            '_beneficiaryType', selectedFarmerType);

                        retcompanyDirectors = items["group_directors"];
                        retgroupName = items["group_name"];
                        retgroupPresident = items["group_president"];
                        retgroupSecretary = items["group_secretary"];
                        retgroupPhone = items["group_phone"];
                        retgroupregNumb = items["group_phone"];
                        retgroupEmail = items["group_email"];
                        retgroupAddress = items["group_company_add"];
                      }),
              );
          // ))));

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

  String selectedFarmerType = "Individual";

  @override
  void initState() {
    super.initState();
    // regSP?.clear();

    selectedFarmerType = regSP?.getString("_beneficiaryType") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColour,
      floatingActionButton: Tooltip(
        message: "Search for registered farmer..",
        child: Material(
          elevation: 10.0,
          shadowColor: Colors.redAccent.withOpacity(.4),
          color: primaryColour,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingHardButton(
                title: "Search",
                fontSize: 18.0,
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      bool _loader = false;

                      return Form(
                        key: _formKey,
                        child: StatefulBuilder(builder: (context, state) {
                          return AlertDialog(
                            title: const Text('Search for farmer ID'),
                            content: TextFieldWidget(
                              decoration: const InputDecoration(
                                  labelText: "Farmer First Name"),
                              controller: _farmerContact,
                              onChanged: (value) {},
                              validator: (input) {
                                if (input!.trim().isEmpty) {
                                  return 'Please enter an ID';
                                } else {
                                  setState(() {
                                    _farmerContact.text = input;
                                  });
                                }
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              LoadingHardButton(
                                title: "Search",
                                fontSize: 18.0,
                                loadingTrigger: _loader,
                                onPress: () {
                                  setState(() {
                                    _loader = true;
                                  });
                                  // Navigator.pop(context);
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  if (_formKey.currentState!.validate()) {
                                    _asyncSearchFarmerOnline(context)
                                        .then((value) {
                                      setState(() {
                                        _loader = false;
                                      });
                                      Navigator.pop(context);
                                    });
                                  }
                                  // Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        }),
                      );
                    },
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8.0, top: 5.0, bottom: 5.0),
                child: Icon(
                  Icons.person_search_rounded,
                  size: 40.0,
                  color: primaryWhite,
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  elevation: 0.0,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  color: primaryColour,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: primaryWhite,
                        size: 40.0,
                      )),
                ),
                Text(
                  "Farmer Type".toUpperCase(),
                  style: const TextStyle(
                    color: primaryWhite,
                    fontSize: 20.0,
                  ),
                ),
                Material(
                  elevation: 0.0,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  color: primaryColour,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FarmDetails()));
                      },
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: primaryWhite,
                        size: 40.0,
                      )),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * .85,
              decoration: const BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFarmerType = "Individual";
                              });
                            },
                            child: Material(
                              elevation: selectedFarmerType == "Individual"
                                  ? 6.0
                                  : 0.0,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedFarmerType == "Individual"
                                      ? secondaryColour
                                      : primaryWhite,
                                  border: Border.all(
                                      color: selectedFarmerType == "Individual"
                                          ? secondaryColour
                                          : secondaryColour),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Individual".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFarmerType = "Group";
                              });
                            },
                            child: Material(
                              elevation:
                                  selectedFarmerType == "Group" ? 6.0 : 0.0,
                              color: primaryWhite,
                              // borderRadius: const BorderRadius.only(
                              //   topLeft: Radius.circular(25.0),
                              // ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedFarmerType == "Group"
                                      ? secondaryColour
                                      : primaryWhite,
                                  border: Border.all(
                                      color: selectedFarmerType == "Group"
                                          ? secondaryColour
                                          : secondaryColour),
                                  // borderRadius: const BorderRadius.only(
                                  //   topRight: Radius.circular(25.0),
                                  // ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Group/ Company".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: farmerTypeView(selectedFarmerType),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget farmerTypeView(String selectedView) {
    Widget result = const SizedBox();

    switch (selectedView) {
      case "Individual":
        result = PersonalDetails(
          retfamerProfilePic: retfamerProfilePic ?? "",
          retfarmerfirstName: retfarmerfirstName ?? "",
          retfarmersurName: retfarmersurName ?? "",
          retfarmerotherName: retfarmerotherName ?? "",
          retfarmerGender: retfarmerGender ?? "",
          retfarmerDoB: retfarmerDoB ?? "",
          retfarmerPostal: retfarmerPostal ?? "",
          retfarmerPhoneNum: retfarmerPhoneNum ?? "",
          retfarmerMail: retfarmerMail ?? "",
          retkinName: retkinName ?? "",
          retkinPhoneNum: retkinPhoneNum ?? "",
          retkinGender: retkinGender ?? "",
          retkinPostal: retkinPostal ?? "",
          retkinDoB: retkinDoB ?? "",
          retkinRelationship: retkinRelationship ?? "",
        );
        break;

      case "Group":
        result = GroupDetails(
          retcompanyDirectors: retcompanyDirectors ?? "",
          retgroupName: retgroupName ?? "",
          retgroupPresident: retgroupPresident ?? "",
          retgroupSecretary: retgroupSecretary ?? "",
          retgroupPhone: retgroupPhone ?? "",
          retgroupregNumb: retgroupregNumb ?? "",
          retgroupEmail: retgroupEmail ?? "",
          retgroupAddress: retgroupAddress ?? "",
        );
        break;

      default:
    }

    return result;
  }
}
