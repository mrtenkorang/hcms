import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/methods.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/senddata/components/treefarminformationcomponents/farminformationarraydetails.dart';
import 'package:hcms_revived2/providers/personalfarmerprovider.dart';
import 'package:hcms_revived2/screens/Treespeciescatalogue/speciesgallery.dart';
import 'package:hcms_revived2/screens/farmregistration/declaration/components/signatureoptions.dart';
import 'package:hcms_revived2/screens/farmregistration/declaration/components/witsignatureoptions.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/farmerdate.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/farmergender.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/kindate.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/plotinfo.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/treefarm.dart';
import 'package:hcms_revived2/screens/viewsubmissions/components/treeinfo.dart';
import 'package:hcms_revived2/screens/viewsubmissions/viewpage.dart';

import 'package:provider/provider.dart';

import 'components/kingender.dart';

class DetailDisplayIncomplete extends StatefulWidget {
  static const routeName = '/detail_display_incomplete';
  final Function()? notifyParent;

  const DetailDisplayIncomplete({Key? key, this.notifyParent})
      : super(key: key);

  @override
  _DetailDisplayIncompleteState createState() =>
      _DetailDisplayIncompleteState();
}

class _DetailDisplayIncompleteState extends State<DetailDisplayIncomplete> {
  //basic data
  final _formKey = GlobalKey<FormState>();
  final _decformKey = GlobalKey<FormState>();
  File? _pickedImage;

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  String _base64Image = "";
  String _declarationSig = "";
  String _witnessDeclarationSig = "";

  bool buildC = false;

  final groupName = TextEditingController();
  final groupPresident = TextEditingController();
  final groupSecretary = TextEditingController();
  final groupDirectors = TextEditingController();
  final groupPhoneNum = TextEditingController();
  final groupEmail = TextEditingController();
  final groupAddress = TextEditingController();

  final farmerFirstName = TextEditingController();
  final farmerOtherName = TextEditingController();
  final farmerLastName = TextEditingController();
  final farmerPhoneNum = TextEditingController();
  // final farmerGender = TextEditingController();
  // final _farmerdOB = TextEditingController();
  final farmerMail = TextEditingController();
  final farmerAddress = TextEditingController();
  final kinName = TextEditingController();
  final kinRelation = TextEditingController();
  // final _kinGender = TextEditingController();
  // final kinDoB = TextEditingController();
  final kinPhoneNum = TextEditingController();
  final kinAddress = TextEditingController();

  String? _farmerGender;
  String? _kinGender;
  int? selectedFarmerRadioGender;
  int? selectedKinRadioGender;

  String? _farmerdOB;

  String? _kindOB;
  String initKinValue = "Select your Birth Date";
  bool isKinDateSelected = false;
  DateTime? kinBirthDate;
  String? kinBirthDateInString;
  bool? hasKinBeenClicked;

  final farmArea = TextEditingController();

  final witnessName = TextEditingController();
  final witnessPhone = TextEditingController();

  String? _disV;
  int? _mmdV;

  String? _family;
  String? _community;

// for form validation
  String? _mmdas;

  String? _regionValue;
  String? _districtValue;

  List<String> _establishment = [];
  // farm cordinates
  String? farmCord;
  List<FarmInformationArray> item = [];

  String? c2items;
  String? c3items;

  //declaration vals
  File? _farmerSig;
  File? _witnessSig;

  void _farmerSign(File pickedImage) {
    _farmerSig = pickedImage;
  }

  void _witnessSign(File pickedImage) {
    _witnessSig = pickedImage;
  }

  @override
  void initState() {
    super.initState();
    //farmerGender
    _farmerGender = regSP?.getString("fgender");
    _kinGender = regSP?.getString("kgender");

    if (_farmerGender == "male") {
      selectedFarmerRadioGender = 1;
    } else if (_farmerGender == "female") {
      selectedFarmerRadioGender = 2;
    } else {
      return null;
    }

    if (_kinGender == "male") {
      selectedKinRadioGender = 1;
    } else if (_kinGender == "female") {
      selectedKinRadioGender = 2;
    } else {
      return null;
    }
  }

  void getbase64Img() async {
    _farmerGender = (regSP?.getString('farmerGenderR') ?? "");
    _farmerdOB = (regSP?.getString('farmerDoBR') ?? "");

    _kindOB = (regSP?.getString('kinDoBR') ?? "");
    _kinGender = (regSP?.getString('kinGenderR') ?? "");

    _base64Image = (regSP?.getString('base64Image') ?? "");
    _declarationSig = (regSP?.getString('base64signature') ?? "");
    _witnessDeclarationSig = (regSP?.getString('witnessbase64signature') ?? "");

    c2items = (regSP?.getString('c2itemsR') ?? "");
    c3items = (regSP?.getString('c3itemsR') ?? "");
    farmCord = (regSP?.getString('itemR') ?? null);

    _regionValue = (regSP?.getString('regionR') ?? null);
    _districtValue = (regSP?.getString('forestDistrictR') ?? null);
    _family = (regSP?.getString('familyR') ?? null);
    _mmdV = (regSP?.getInt('mddasR') ?? null);
    _disV = (regSP?.getString('mddasNameR') ?? null);
    _community = (regSP?.getString('communityR') ?? null);
    _establishment = (regSP?.getStringList("estR") ?? []);

    farmCord = regSP?.getString("itemR");
    farmCord != null ? item = FarmInformationArray.decode(farmCord!) : null;
  }

  Future<bool> _onbackPressed() {
    return Navigator.of(context)
        .pushAndRemoveUntil(
            CupertinoPageRoute(builder: (c) => ViewReport()), (route) => false)
        .then((value) => value);
    // Navigator.popUntil(context, true);

    // throw ("went wrong here");
    // return true;
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace =
        Provider.of<PersonalFarmerProvider>(context, listen: false)
            .findById(id.toString());

    // final farmCords = selectedPlace.pointsGet.isNotEmpty
    //     ? json.decode(selectedPlace.pointsGet).cast<Map<String, dynamic>>()
    //     : Map();

    List<FarmInformationArray> pp =
        FarmInformationArray.decode(selectedPlace.pointsGet);

    // List<FarmInformationArray> item = [];
    // coat(selectedPlace.pointsGet);

    return WillPopScope(
      onWillPop: _onbackPressed,
      child: Scaffold(
        appBar: AppBar( foregroundColor: fPrimaryWhite,
          backgroundColor: fPrimaryColour,
          title: Text("Report Details",
          style: TextStyle(color: fPrimaryWhite),),
          actions: [
            PopupMenuButton<String>(
              offset: Offset(2.00, 3.00),
              color: Colors.black,
              onSelected: (String _downChoice) {
                if (_downChoice == Constants.home) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => IndexPage(),
                    ),
                  );
                } else if (_downChoice == Constants.viewspecies) {
                  // writeToFile(context);

                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) => SpeciesGallery()));
                }
              },
              itemBuilder: (BuildContext context) {
                return Constants.viewIncompletedownChoices
                    .map((String _downChoice) {
                  return PopupMenuItem<String>(
                    value: _downChoice,
                    child: Container(
                      margin: EdgeInsets.only(right: 0),
                      child: Text(
                        _downChoice,
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: null,
              builder: (context, snapshot) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.all(0.0),
                  child: ListView(children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          selectedPlace.beneficiaryType == "Group"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Group/ Company Details",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Group/ Company Name",
                                            controller: groupName.text.isEmpty
                                                ? TextEditingController(
                                                    text:
                                                        selectedPlace.groupName)
                                                : groupName,
                                            suffixIconData: Icons.edit,
                                            onSubmitted: (val) =>
                                                groupName.text = val,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  groupName.text = value;
                                                });
                                              }
                                            },
                                            // onClicked: () {
                                            //   _submissionLoading(
                                            //     context,
                                            //     label: "Group/ Company Name",
                                            //     id: selectedPlace.id,
                                            //     init: selectedPlace.groupName,
                                            //     colVal: "groupName",
                                            //   );
                                            // },
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Group President",
                                            controller:
                                                groupPresident.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .groupPresident)
                                                    : groupPresident,
                                            suffixIconData: Icons.edit,
                                            onSubmitted: (val) =>
                                                groupPresident.text = val,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  groupPresident.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Group Secretary",
                                            controller:
                                                groupSecretary.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .groupSecretary)
                                                    : groupSecretary,
                                            suffixIconData: Icons.edit,
                                            onSubmitted: (val) =>
                                                groupSecretary.text = val,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  groupSecretary.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Company directors",
                                            controller:
                                                groupDirectors.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .groupDirectors)
                                                    : groupDirectors,
                                            suffixIconData: Icons.edit,
                                            onSubmitted: (val) =>
                                                groupDirectors.text = val,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  groupDirectors.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            type: TextInputType.phone,
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Mobile number",
                                            maxlength: 10,
                                            controller:
                                                groupPhoneNum.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .groupphoneNumber)
                                                    : groupPhoneNum,
                                            suffixIconData: Icons.edit,
                                            onSubmitted: (val) =>
                                                groupPhoneNum.text = val,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  groupPhoneNum.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            type: TextInputType.emailAddress,
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Email Address",
                                            controller: groupEmail.text.isEmpty
                                                ? TextEditingController(
                                                    text: selectedPlace
                                                        .groupEmail)
                                                : groupEmail,
                                            suffixIconData: Icons.edit,
                                            onSubmitted: (val) =>
                                                groupEmail.text = val,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  groupEmail.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Postal Address",
                                            controller:
                                                groupAddress.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .groupAddress)
                                                    : groupAddress,
                                            suffixIconData: Icons.edit,
                                            onSubmitted: (val) =>
                                                groupAddress.text = val,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  groupAddress.text = value;
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Farmer Details",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ProfileImageInput(_selectedImage,
                                              alreadyPic:
                                                  selectedPlace.farmerPic64),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "First Name",
                                            controller:
                                                farmerFirstName.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .farmerfirstName)
                                                    : farmerFirstName,
                                            suffixIconData: Icons.edit,
                                            validator: (value) {
                                              setState(() {
                                                farmerFirstName.text = value;
                                              });
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Other Names",
                                            controller:
                                                farmerOtherName.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .farmerotherName)
                                                    : farmerOtherName,
                                            suffixIconData: Icons.edit,
                                            validator: (value) {
                                              setState(() {
                                                farmerOtherName.text = value;
                                              });
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Surname",
                                            controller:
                                                farmerLastName.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .farmersurName)
                                                    : farmerLastName,
                                            suffixIconData: Icons.edit,
                                            onSubmitted: (val) =>
                                                farmerLastName.text = val,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  farmerLastName.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          FarmerGender(),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            maxlength: 10,
                                            hintText: "Input text here",
                                            labelText: "Mobile Number",
                                            controller:
                                                farmerPhoneNum.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .farmerPhoneNum)
                                                    : farmerPhoneNum,
                                            type: TextInputType.phone,
                                            suffixIconData: Icons.edit,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  farmerPhoneNum.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          FarmerDate(),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Email Address",
                                            controller: farmerMail.text.isEmpty
                                                ? TextEditingController(
                                                    text: selectedPlace
                                                        .farmerMail)
                                                : farmerMail,
                                            suffixIconData: Icons.edit,
                                            validator: (value) {
                                              setState(() {
                                                farmerMail.text = value;
                                              });
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Postal Address",
                                            controller:
                                                farmerAddress.text.isEmpty
                                                    ? TextEditingController(
                                                        text: selectedPlace
                                                            .farmerPostal)
                                                    : farmerAddress,
                                            suffixIconData: Icons.edit,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  farmerAddress.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Kin Details",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Next of kin",
                                            controller: kinName.text.isEmpty
                                                ? TextEditingController(
                                                    text: selectedPlace.kinName)
                                                : kinName,
                                            suffixIconData: Icons.edit,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  kinName.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Relationship",
                                            controller: kinRelation.text.isEmpty
                                                ? TextEditingController(
                                                    text: selectedPlace
                                                        .kinRelationShip)
                                                : kinRelation,
                                            suffixIconData: Icons.edit,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  kinRelation.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          KinGender(),
                                          KinDate(),
                                          BoilerTextFieldWidget(
                                            type: TextInputType.phone,
                                            readonly: false,
                                            hintText: "Input text here",
                                            maxlength: 10,
                                            labelText: "Phone number",
                                            controller: kinPhoneNum.text.isEmpty
                                                ? TextEditingController(
                                                    text: selectedPlace
                                                        .kinPhoneNum)
                                                : kinPhoneNum,
                                            suffixIconData: Icons.edit,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  kinPhoneNum.text = value;
                                                });
                                              }
                                            },
                                          ),
                                          BoilerTextFieldWidget(
                                            readonly: false,
                                            hintText: "Input text here",
                                            labelText: "Postal Address",
                                            controller: kinAddress.text.isEmpty
                                                ? TextEditingController(
                                                    text:
                                                        selectedPlace.kinPostal)
                                                : kinAddress,
                                            suffixIconData: Icons.edit,
                                            validator: (value) {
                                              {
                                                setState(() {
                                                  kinAddress.text = value;
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                          // Tree Farm Information
                          TreeFarmInfo(
                            typeofEstablishment:
                                selectedPlace.typeofEstablishment,
                            community: selectedPlace.community,
                            mddasName: selectedPlace.mddasName,
                            family: selectedPlace.family,
                            forestDistrict: selectedPlace.forestDistrict,
                            region: selectedPlace.region,
                          ),

                          // Plot/ Farm Information
                          PlotFarmInfo(),

                          // Tree Information on Planted Species
                          TreeInfo(
                              typeofEstablishment:
                                  selectedPlace.typeofEstablishment,
                              kk: selectedPlace.c3treePlantationDetail),

                          // Declaration
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Declaration",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    BoilerTextFieldWidget(
                                      hintText: selectedPlace.id,
                                      labelText: "Date",
                                      initialVal: selectedPlace.timeDisplay,
                                      // suffixIconData: Icons.edit,
                                    ),
                                    BoilerTextFieldWidget(
                                        readonly: false,
                                        hintText: "Input text here",
                                        labelText: "Witness Name",
                                        controller: witnessName.text.isEmpty
                                            ? TextEditingController(
                                                text: selectedPlace.witnessName)
                                            : witnessName,
                                        suffixIconData: Icons.edit,
                                        validator: (value) {
                                          {
                                            setState(() {
                                              witnessName.text = value;
                                            });
                                          }
                                        }),
                                    BoilerTextFieldWidget(
                                      type: TextInputType.phone,
                                      readonly: false,
                                      hintText: "Input text here",
                                      labelText: "Witness Contact",
                                      maxlength: 10,
                                      controller: witnessPhone.text.isEmpty
                                          ? TextEditingController(
                                              text: selectedPlace.witnessPhone)
                                          : witnessPhone,
                                      suffixIconData: Icons.edit,
                                      validator: (value) {
                                        {
                                          setState(() {
                                            witnessPhone.text = value;
                                          });
                                        }
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xFFfc1d20),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: SignatureOptions(
                                                  _farmerSign,
                                                  alreadyVal: selectedPlace
                                                      .farmerdeclarationSig),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30.0,
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xFFfc1d20),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: WitSignatureOptions(
                                                  _witnessSign, "",
                                                  alreadyval: selectedPlace
                                                      .witnessdeclarationSig),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              top: 18.0,
                                            ),
                                            child: Container(
                                              width: 90,
                                              height: 90,
                                              child: Text(
                                                "Farmer Signature",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30.0,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              top: 18.0,
                                            ),
                                            child: Container(
                                              width: 90,
                                              height: 90,
                                              child: Text(
                                                "Witness Signature",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    selectedPlace.conStat == "not connected"
                                        ? Container(
                                            child: selectedPlace
                                                        .beneficiaryType ==
                                                    "Group"
                                                ? ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0.0,
                                                      backgroundColor:
                                                          fPrimaryColour,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      textStyle: const TextStyle(
                                                          color: fPrimaryWhite),
                                                      // shadowColor: fPrimaryColour,
                                                    ),
                                                    child: Text(
                                                      "Save Changes",
                                                      style: TextStyle(
          color: fPrimaryWhite,
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    onPressed: () async {
                                                      getbase64Img();
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        final String newitem = item
                                                                .isNotEmpty
                                                            ? FarmInformationArray
                                                                .encode(item)
                                                            : selectedPlace
                                                                .pointsGet;

                                                        DBHelper.updateGroupBeforeSend(
                                                                groupName.text,
                                                                groupPresident
                                                                    .text,
                                                                groupSecretary
                                                                    .text,
                                                                groupPhoneNum
                                                                    .text,
                                                                groupDirectors
                                                                    .text,
                                                                groupEmail.text,
                                                                groupAddress
                                                                    .text,
                                                                _regionValue ==
                                                                        null
                                                                    ? selectedPlace
                                                                        .region
                                                                    : _regionValue!,
                                                                _districtValue ==
                                                                        null
                                                                    ? selectedPlace
                                                                        .forestDistrict
                                                                    : _districtValue!,
                                                                _mmdV == null
                                                                    ? selectedPlace
                                                                        .mddas
                                                                    : _mmdV
                                                                        .toString(),
                                                                _disV == null
                                                                    ? selectedPlace
                                                                        .mddasName
                                                                    : _disV!,
                                                                _community ==
                                                                        null
                                                                    ? selectedPlace
                                                                        .community
                                                                    : _community!,
                                                                _family ==
                                                                        null
                                                                    ? selectedPlace
                                                                        .family
                                                                    : _family!,
                                                                _establishment
                                                                        .isEmpty
                                                                    ? selectedPlace
                                                                        .typeofEstablishment
                                                                    : json.encode(
                                                                        _establishment),
                                                                selectedPlace
                                                                    .farmID,
                                                                selectedPlace
                                                                    .farmArea,
                                                                newitem.trim().isEmpty
                                                                    ? selectedPlace
                                                                        .pointsGet
                                                                    : newitem,
                                                                c2items!.isEmpty
                                                                    ? selectedPlace
                                                                        .c2treePlantationDetail
                                                                    : c2items!,
                                                                c3items!.isEmpty
                                                                    ? selectedPlace
                                                                        .c3treePlantationDetail
                                                                    : c3items!,
                                                                _declarationSig
                                                                        .trim()
                                                                        .isEmpty
                                                                    ? selectedPlace
                                                                        .farmerdeclarationSig
                                                                    : _declarationSig,
                                                                _witnessDeclarationSig
                                                                        .trim()
                                                                        .isEmpty
                                                                    ? selectedPlace
                                                                        .witnessdeclarationSig
                                                                    : _witnessDeclarationSig,
                                                                witnessName.text
                                                                        .isEmpty
                                                                    ? selectedPlace
                                                                        .witnessName
                                                                    : witnessName
                                                                        .text,
                                                                witnessPhone
                                                                        .text
                                                                        .isEmpty
                                                                    ? selectedPlace
                                                                        .witnessPhone
                                                                    : witnessPhone
                                                                        .text,
                                                                "not connected",
                                                                selectedPlace.id)
                                                            .then(
                                                          (value) => Navigator
                                                                  .of(context)
                                                              .pushReplacement(
                                                            CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  ViewReport(),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      // setState(() {
                                                      //   buildC = !buildC;
                                                      //   widget.notifyParent();
                                                      // });
                                                    },
                                                  )
                                                : ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0.0,
                                                      backgroundColor:
                                                          fPrimaryColour,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      textStyle: const TextStyle(
                                                          color: fPrimaryWhite),
                                                      // shadowColor: fPrimaryColour,
                                                    ),
                                                    child: Text(
                                                      "Save Changes",
                                                      style: TextStyle(
          color: fPrimaryWhite,
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    onPressed: () async {
                                                      getbase64Img();
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        final String newitem = item
                                                                .isNotEmpty
                                                            ? FarmInformationArray
                                                                .encode(item)
                                                            : selectedPlace
                                                                .pointsGet;

                                                        debugPrint(
                                                            "Points is $newitem");
                                                        debugPrint(
                                                            "Points is other ${selectedPlace.pointsGet}");

                                                        DBHelper.updateIndBeforeSend(
                                                                farmerFirstName
                                                                    .text,
                                                                farmerOtherName
                                                                    .text,
                                                                farmerLastName
                                                                    .text,
                                                                _farmerGender!.isEmpty
                                                                    ? selectedPlace
                                                                        .farmerGender
                                                                    : _farmerGender!,
                                                                farmerPhoneNum
                                                                    .text,
                                                                _farmerdOB!.isEmpty
                                                                    ? selectedPlace
                                                                        .farmerDoB
                                                                    : _farmerdOB!,
                                                                farmerMail.text,
                                                                farmerAddress
                                                                    .text,
                                                                kinName.text,
                                                                kinRelation
                                                                    .text,
                                                                _kindOB!.isEmpty
                                                                    ? selectedPlace
                                                                        .kinDoB
                                                                    : _kindOB!,
                                                                _kinGender!.isEmpty
                                                                    ? selectedPlace
                                                                        .kinGender
                                                                    : _kinGender!,
                                                                kinPhoneNum
                                                                    .text,
                                                                kinAddress.text,
                                                                _base64Image.trim().isEmpty
                                                                    ? selectedPlace
                                                                        .farmerPic64
                                                                    : _base64Image,
                                                                _regionValue == null
                                                                    ? selectedPlace
                                                                        .region
                                                                    : _regionValue!,
                                                                _districtValue == null
                                                                    ? selectedPlace
                                                                        .forestDistrict
                                                                    : _districtValue!,
                                                                _mmdV == null
                                                                    ? selectedPlace
                                                                        .mddas
                                                                    : _mmdV
                                                                        .toString(),
                                                                _disV == null
                                                                    ? selectedPlace
                                                                        .mddasName
                                                                    : _disV!,
                                                                _community == null
                                                                    ? selectedPlace
                                                                        .community
                                                                    : _community!,
                                                                _family == null
                                                                    ? selectedPlace
                                                                        .family
                                                                    : _family!,
                                                                _establishment == null
                                                                    ? selectedPlace
                                                                        .typeofEstablishment
                                                                    : json.encode(
                                                                        _establishment),
                                                                selectedPlace
                                                                    .farmID,
                                                                selectedPlace
                                                                    .farmArea,
                                                                newitem.trim().isEmpty
                                                                    ? selectedPlace
                                                                        .pointsGet
                                                                    : newitem,
                                                                c2items!.isEmpty
                                                                    ? selectedPlace
                                                                        .c2treePlantationDetail
                                                                    : c2items!,
                                                                c3items!.isEmpty
                                                                    ? selectedPlace
                                                                        .c3treePlantationDetail
                                                                    : c3items!,
                                                                _declarationSig
                                                                        .trim()
                                                                        .isEmpty
                                                                    ? selectedPlace
                                                                        .farmerdeclarationSig
                                                                    : _declarationSig,
                                                                _witnessDeclarationSig
                                                                        .trim()
                                                                        .isEmpty
                                                                    ? selectedPlace
                                                                        .witnessdeclarationSig
                                                                    : _witnessDeclarationSig,
                                                                witnessName.text.isEmpty
                                                                    ? selectedPlace
                                                                        .witnessName
                                                                    : witnessName
                                                                        .text,
                                                                witnessPhone.text.isEmpty
                                                                    ? selectedPlace.witnessPhone
                                                                    : witnessPhone.text,
                                                                "not connected",
                                                                selectedPlace.id)
                                                            .then(
                                                          (value) => Navigator
                                                                  .of(context)
                                                              .pushReplacement(
                                                            CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  ViewReport(),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                          )
                                        : selectedPlace.conStat == "incomplete"
                                            ? Container(
                                                child: selectedPlace
                                                            .beneficiaryType ==
                                                        "Group"
                                                    ? ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          elevation: 0.0,
                                                          backgroundColor:
                                                              fPrimaryColour,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          textStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors.red),
                                                          // shadowColor: fPrimaryColour,
                                                        ),
                                                        child: Text(
                                                          "Save",
                                                          style: TextStyle(color: fPrimaryWhite,
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                        onPressed: () async {
                                                          getbase64Img();
                                                          _formKey.currentState!
                                                              .validate();

                                                          submissionOptions(
                                                              context,
                                                              "Save form as",
                                                              "Form Completed",
                                                              "Complete later",
                                                              "Cancel",
                                                              approvePress: () {
                                                            if (groupName.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter company/group name',
                                                                  "negative");
                                                            } else if (groupPresident.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter group president name',
                                                                  "negative");
                                                            } else if (groupSecretary.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter secretary name',
                                                                  "negative");
                                                            } else if (groupDirectors.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter company directors name',
                                                                  "negative");
                                                            } else if (groupPhoneNum.text
                                                                    .trim()
                                                                    .length <
                                                                10) {
                                                              overlayNotification(
                                                                  'Mobile number digits are less than 10',
                                                                  "negative");
                                                            } else if (groupEmail.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter an email address',
                                                                  "negative");
                                                            } else if (groupAddress.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter an address',
                                                                  "negative");
                                                            } else if (_regionValue == null &&
                                                                selectedPlace
                                                                    .region
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please select a region',
                                                                  "negative");
                                                            } else if (_districtValue == null &&
                                                                selectedPlace
                                                                    .forestDistrict
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please select a forest district',
                                                                  "negative");
                                                            } else if (_family == null &&
                                                                selectedPlace
                                                                    .family
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please select a family',
                                                                  "negative");
                                                            } else if (_mmdV == null &&
                                                                selectedPlace
                                                                    .mddasName
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please select an MMDA',
                                                                  "negative");
                                                            } else if (_community == null &&
                                                                selectedPlace
                                                                    .community
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please select a community',
                                                                  "negative");
                                                            } else if (_establishment == null &&
                                                                selectedPlace
                                                                    .typeofEstablishment
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please select type of establishment',
                                                                  "negative");
                                                            } else if (item == null
                                                                ? selectedPlace.pointsGet
                                                                    .trim()
                                                                    .isEmpty
                                                                : item.length < 4 && selectedPlace.pointsGet.trim().isEmpty) {
                                                              overlayNotification(
                                                                  'Picked cordinates must be at least 4',
                                                                  "negative");
                                                            } else if (c2items!.length < 5 && selectedPlace.c2treePlantationDetail.length < 5 && c3items!.length < 5 && selectedPlace.c3treePlantationDetail.length < 5) {
                                                              overlayNotification(
                                                                  'Please add tree information dataR',
                                                                  "negative");
                                                            } else if (_declarationSig.trim().isEmpty && selectedPlace.farmerdeclarationSig.trim().isEmpty || _witnessDeclarationSig.trim().isEmpty && selectedPlace.witnessdeclarationSig.trim().isEmpty) {
                                                              overlayNotification(
                                                                  'Please upload a signature',
                                                                  "negative");
                                                            } else if (witnessName.text.trim().isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter witness name',
                                                                  "negative");
                                                            } else if (witnessPhone.text.trim().length < 10) {
                                                              overlayNotification(
                                                                  'Witness mobile number digits are less than 10',
                                                                  "negative");
                                                            } else if (_formKey.currentState!.validate()) {
                                                              final String newitem = item
                                                                      .isNotEmpty
                                                                  ? FarmInformationArray
                                                                      .encode(
                                                                          item)
                                                                  : selectedPlace
                                                                      .pointsGet;

                                                              DBHelper.updateGroupBeforeSend(
                                                                      groupName
                                                                          .text,
                                                                      groupPresident
                                                                          .text,
                                                                      groupSecretary
                                                                          .text,
                                                                      groupPhoneNum
                                                                          .text,
                                                                      groupDirectors
                                                                          .text,
                                                                      groupEmail
                                                                          .text,
                                                                      groupAddress
                                                                          .text,
                                                                      _regionValue ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .region
                                                                          : _regionValue!,
                                                                      _districtValue ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .forestDistrict
                                                                          : _districtValue!,
                                                                      _mmdV ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .mddas
                                                                          : _mmdV
                                                                              .toString(),
                                                                      _disV ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .mddasName
                                                                          : _disV!,
                                                                      _community ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .community
                                                                          : _community!,
                                                                      _family ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .family
                                                                          : _family!,
                                                                      _establishment.isEmpty
                                                                          ? selectedPlace
                                                                              .typeofEstablishment
                                                                          : json
                                                                              .encode(
                                                                                  _establishment),
                                                                      selectedPlace
                                                                          .farmID,
                                                                      selectedPlace
                                                                          .farmArea,
                                                                      newitem
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .pointsGet
                                                                          : newitem,
                                                                      c2items!.isEmpty
                                                                          ? selectedPlace
                                                                              .c2treePlantationDetail
                                                                          : c2items!,
                                                                      c3items!
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .c3treePlantationDetail
                                                                          : c3items!,
                                                                      _declarationSig
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .farmerdeclarationSig
                                                                          : _declarationSig,
                                                                      _witnessDeclarationSig
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessdeclarationSig
                                                                          : _witnessDeclarationSig,
                                                                      witnessName
                                                                              .text
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessName
                                                                          : witnessName
                                                                              .text,
                                                                      witnessPhone
                                                                              .text
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessPhone
                                                                          : witnessPhone
                                                                              .text,
                                                                      "not connected",
                                                                      selectedPlace
                                                                          .id)
                                                                  .then(
                                                                (value) => Navigator.of(
                                                                        context)
                                                                    .pushReplacement(
                                                                  CupertinoPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ViewReport(),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          }, editPress: () {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              final String newitem = item
                                                                      .isNotEmpty
                                                                  ? FarmInformationArray
                                                                      .encode(
                                                                          item)
                                                                  : selectedPlace
                                                                      .pointsGet;

                                                              DBHelper.updateGroupBeforeSend(
                                                                      groupName
                                                                          .text,
                                                                      groupPresident
                                                                          .text,
                                                                      groupSecretary
                                                                          .text,
                                                                      groupPhoneNum
                                                                          .text,
                                                                      groupDirectors
                                                                          .text,
                                                                      groupEmail
                                                                          .text,
                                                                      groupAddress
                                                                          .text,
                                                                      _regionValue ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .region
                                                                          : _regionValue!,
                                                                      _districtValue ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .forestDistrict
                                                                          : _districtValue!,
                                                                      _mmdV ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .mddas
                                                                          : _mmdV
                                                                              .toString(),
                                                                      _disV ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .mddasName
                                                                          : _disV!,
                                                                      _community ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .community
                                                                          : _community!,
                                                                      _family ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .family
                                                                          : _family!,
                                                                      _establishment.isEmpty
                                                                          ? selectedPlace
                                                                              .typeofEstablishment
                                                                          : json
                                                                              .encode(
                                                                                  _establishment),
                                                                      selectedPlace
                                                                          .farmID,
                                                                      selectedPlace
                                                                          .farmArea,
                                                                      newitem
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .pointsGet
                                                                          : newitem,
                                                                      c2items!.isEmpty
                                                                          ? selectedPlace
                                                                              .c2treePlantationDetail
                                                                          : c2items!,
                                                                      c3items!
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .c3treePlantationDetail
                                                                          : c3items!,
                                                                      _declarationSig
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .farmerdeclarationSig
                                                                          : _declarationSig,
                                                                      _witnessDeclarationSig
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessdeclarationSig
                                                                          : _witnessDeclarationSig,
                                                                      witnessName
                                                                              .text
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessName
                                                                          : witnessName
                                                                              .text,
                                                                      witnessPhone
                                                                              .text
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessPhone
                                                                          : witnessPhone
                                                                              .text,
                                                                      "incomplete",
                                                                      selectedPlace
                                                                          .id)
                                                                  .then(
                                                                (value) => Navigator.of(
                                                                        context)
                                                                    .pushReplacement(
                                                                  CupertinoPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ViewReport(),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                              disapprovePress:
                                                                  () {});
                                                          // setState(() {
                                                          //   buildC = !buildC;
                                                          //   widget.notifyParent();
                                                          // });
                                                        },
                                                      )
                                                    : ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          elevation: 0.0,
                                                          backgroundColor:
                                                              fPrimaryColour,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          textStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      fPrimaryWhite),
                                                          // shadowColor: fPrimaryColour,
                                                        ),
                                                        child: Text(
                                                          "Save",
                                                          style: TextStyle(color: fPrimaryWhite,
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                        onPressed: () async {
                                                          getbase64Img();
                                                          _formKey.currentState!
                                                              .validate();
                                                          submissionOptions(
                                                              context,
                                                              "Save form as",
                                                              "Form Completed",
                                                              "Complete later",
                                                              "Cancel",
                                                              approvePress: () {
                                                            if (farmerFirstName.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter your first name',
                                                                  "negative");
                                                            } else if (farmerLastName.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter your surname',
                                                                  "negative");
                                                            } else if (_farmerGender!.trim().isEmpty &&
                                                                selectedPlace.farmerGender
                                                                    .trim()
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please select gender',
                                                                  "negative");
                                                            } else if (farmerPhoneNum.text.trim().length <
                                                                10) {
                                                              overlayNotification(
                                                                  'Mobile number digits are less than 10',
                                                                  "negative");
                                                            } else if (_farmerdOB!
                                                                    .trim()
                                                                    .isEmpty &&
                                                                selectedPlace.farmerDoB
                                                                    .trim()
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter your date of birth',
                                                                  "negative");
                                                            } else if (farmerAddress.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter a postal address',
                                                                  "negative");
                                                            } else if (kinName.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter next of kin name',
                                                                  "negative");
                                                            } else if (kinRelation.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter kin relationship',
                                                                  "negative");
                                                            } else if (_kinGender!
                                                                    .trim()
                                                                    .isEmpty &&
                                                                selectedPlace.kinGender
                                                                    .trim()
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter kin gender',
                                                                  "negative");
                                                            } else if (_kindOB!.trim().isEmpty &&
                                                                selectedPlace.kinDoB
                                                                    .trim()
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter kin date of birth',
                                                                  "negative");
                                                            } else if (kinPhoneNum.text.trim().length <
                                                                10) {
                                                              overlayNotification(
                                                                  'Kin mobile number digits are less than 10',
                                                                  "negative");
                                                            } else if (kinAddress.text
                                                                .trim()
                                                                .isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter kin postal address',
                                                                  "negative");
                                                            } else if (_base64Image.isEmpty &&
                                                                selectedPlace
                                                                    .farmerPic64
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please provide farmer image',
                                                                  "negative");
                                                            } else if (_regionValue == null &&
                                                                selectedPlace
                                                                    .region
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please select a region',
                                                                  "negative");
                                                            } else if (_districtValue == null &&
                                                                selectedPlace
                                                                    .forestDistrict
                                                                    .isEmpty) {
                                                              overlayNotification(
                                                                  'Please select a forest district',
                                                                  "negative");
                                                            } else if (_family == null && selectedPlace.family.isEmpty) {
                                                              overlayNotification(
                                                                  'Please select a family',
                                                                  "negative");
                                                            } else if (_mmdV == null && selectedPlace.mddasName.isEmpty) {
                                                              overlayNotification(
                                                                  'Please select an MMDA',
                                                                  "negative");
                                                            } else if (_community == null && selectedPlace.community.isEmpty) {
                                                              overlayNotification(
                                                                  'Please select a community',
                                                                  "negative");
                                                            } else if (_establishment.isEmpty && selectedPlace.typeofEstablishment.isEmpty) {
                                                              overlayNotification(
                                                                  'Please select type of establishment',
                                                                  "negative");
                                                            } else if (item == null ? selectedPlace.pointsGet.trim().isEmpty : item.length < 4 && selectedPlace.pointsGet.trim().isEmpty) {
                                                              overlayNotification(
                                                                  'Picked cordinates must be at least 4',
                                                                  "negative");
                                                            } else if (c2items!.length < 5 && selectedPlace.c2treePlantationDetail.length < 5 && c3items!.length < 5 && selectedPlace.c3treePlantationDetail.length < 5) {
                                                              overlayNotification(
                                                                  'Please add tree information data',
                                                                  "negative");
                                                            } else if (_declarationSig.trim().isEmpty && selectedPlace.farmerdeclarationSig.trim().isEmpty || _witnessDeclarationSig.trim().isEmpty && selectedPlace.witnessdeclarationSig.trim().isEmpty) {
                                                              overlayNotification(
                                                                  'Please upload a signature',
                                                                  "negative");
                                                            } else if (witnessName.text.trim().isEmpty) {
                                                              overlayNotification(
                                                                  'Please enter witness name',
                                                                  "negative");
                                                            } else if (witnessPhone.text.trim().length < 10) {
                                                              overlayNotification(
                                                                  'Witness mobile number digits are less than 10',
                                                                  "negative");
                                                            } else if (_formKey.currentState!.validate()) {
                                                              final String newitem = item
                                                                      .isNotEmpty
                                                                  ? FarmInformationArray
                                                                      .encode(
                                                                          item)
                                                                  : selectedPlace
                                                                      .pointsGet;

                                                              DBHelper.updateIndBeforeSend(
                                                                      farmerFirstName
                                                                          .text,
                                                                      farmerOtherName
                                                                          .text,
                                                                      farmerLastName
                                                                          .text,
                                                                      _farmerGender!.isEmpty
                                                                          ? selectedPlace
                                                                              .farmerGender
                                                                          : _farmerGender!,
                                                                      farmerPhoneNum
                                                                          .text,
                                                                      _farmerdOB!.isEmpty
                                                                          ? selectedPlace
                                                                              .farmerDoB
                                                                          : _farmerdOB!,
                                                                      farmerMail
                                                                          .text,
                                                                      farmerAddress
                                                                          .text,
                                                                      kinName
                                                                          .text,
                                                                      kinRelation
                                                                          .text,
                                                                      _kindOB!.isEmpty
                                                                          ? selectedPlace
                                                                              .kinDoB
                                                                          : _kindOB!,
                                                                      _kinGender!
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .kinGender
                                                                          : _kinGender!,
                                                                      kinPhoneNum
                                                                          .text,
                                                                      kinAddress
                                                                          .text,
                                                                      _base64Image
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .farmerPic64
                                                                          : _base64Image,
                                                                      _regionValue ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .region
                                                                          : _regionValue!,
                                                                      _districtValue ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .forestDistrict
                                                                          : _districtValue!,
                                                                      _mmdV == null
                                                                          ? selectedPlace
                                                                              .mddas
                                                                          : _mmdV
                                                                              .toString(),
                                                                      _disV == null
                                                                          ? selectedPlace
                                                                              .mddasName
                                                                          : _disV!,
                                                                      _community ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .community
                                                                          : _community!,
                                                                      _family ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .family
                                                                          : _family!,
                                                                      _establishment ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .typeofEstablishment
                                                                          : json
                                                                              .encode(
                                                                                  _establishment),
                                                                      selectedPlace
                                                                          .farmID,
                                                                      selectedPlace
                                                                          .farmArea,
                                                                      newitem.isEmpty
                                                                          ? selectedPlace
                                                                              .pointsGet
                                                                          : newitem,
                                                                      c2items!
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .c2treePlantationDetail
                                                                          : c2items!,
                                                                      c3items!
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .c3treePlantationDetail
                                                                          : c2items!,
                                                                      _declarationSig
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .farmerdeclarationSig
                                                                          : _declarationSig,
                                                                      _witnessDeclarationSig
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessdeclarationSig
                                                                          : _witnessDeclarationSig,
                                                                      witnessName
                                                                              .text
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessName
                                                                          : witnessName
                                                                              .text,
                                                                      witnessPhone
                                                                              .text
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessPhone
                                                                          : witnessPhone
                                                                              .text,
                                                                      "not connected",
                                                                      selectedPlace
                                                                          .id)
                                                                  .then(
                                                                (value) => Navigator.of(
                                                                        context)
                                                                    .pushReplacement(
                                                                  CupertinoPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ViewReport()),
                                                                ),
                                                              );
                                                            }
                                                          }, editPress:
                                                                  () async {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              final String newitem = item
                                                                      .isNotEmpty
                                                                  ? FarmInformationArray
                                                                      .encode(
                                                                          item)
                                                                  : selectedPlace
                                                                      .pointsGet;

                                                              DBHelper.updateIndBeforeSend(
                                                                      farmerFirstName
                                                                          .text,
                                                                      farmerOtherName
                                                                          .text,
                                                                      farmerLastName
                                                                          .text,
                                                                      _farmerGender!
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .farmerGender
                                                                          : _farmerGender!,
                                                                      farmerPhoneNum
                                                                          .text,
                                                                      _farmerdOB!
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .farmerDoB
                                                                          : _farmerdOB!,
                                                                      farmerMail
                                                                          .text,
                                                                      farmerAddress
                                                                          .text,
                                                                      kinName
                                                                          .text,
                                                                      kinRelation
                                                                          .text,
                                                                      _kindOB!.isEmpty
                                                                          ? selectedPlace
                                                                              .kinDoB
                                                                          : _kindOB!,
                                                                      _kinGender!
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .kinGender
                                                                          : _kinGender!,
                                                                      kinPhoneNum
                                                                          .text,
                                                                      kinAddress
                                                                          .text,
                                                                      _base64Image
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .farmerPic64
                                                                          : _base64Image,
                                                                      _regionValue ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .region
                                                                          : _regionValue!,
                                                                      _districtValue ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .forestDistrict
                                                                          : _districtValue!,
                                                                      _mmdV ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .mddas
                                                                          : _mmdV
                                                                              .toString(),
                                                                      _disV ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .mddasName
                                                                          : _disV!,
                                                                      _community ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .community
                                                                          : _community!,
                                                                      _family ==
                                                                              null
                                                                          ? selectedPlace
                                                                              .family
                                                                          : _family!,
                                                                      _establishment.isEmpty
                                                                          ? selectedPlace
                                                                              .typeofEstablishment
                                                                          : json
                                                                              .encode(
                                                                                  _establishment),
                                                                      selectedPlace
                                                                          .farmID,
                                                                      selectedPlace
                                                                          .farmArea,
                                                                      newitem
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .pointsGet
                                                                          : newitem,
                                                                      c2items!.isEmpty
                                                                          ? selectedPlace
                                                                              .c2treePlantationDetail
                                                                          : c2items!,
                                                                      c3items!
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .c3treePlantationDetail
                                                                          : c3items!,
                                                                      _declarationSig
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .farmerdeclarationSig
                                                                          : _declarationSig,
                                                                      _witnessDeclarationSig
                                                                              .trim()
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessdeclarationSig
                                                                          : _witnessDeclarationSig,
                                                                      witnessName
                                                                              .text
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessName
                                                                          : witnessName
                                                                              .text,
                                                                      witnessPhone
                                                                              .text
                                                                              .isEmpty
                                                                          ? selectedPlace
                                                                              .witnessPhone
                                                                          : witnessPhone
                                                                              .text,
                                                                      "incomplete",
                                                                      selectedPlace
                                                                          .id)
                                                                  .then(
                                                                (value) => Navigator.of(
                                                                        context)
                                                                    .pushReplacement(
                                                                  CupertinoPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ViewReport()),
                                                                ),
                                                              );
                                                              print(
                                                                  farmerFirstName
                                                                      .text);
                                                            }
                                                          },
                                                              disapprovePress:
                                                                  () {});
                                                        },
                                                      ),
                                              )
                                            : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ]),
                );
              }),
        ),
      ),
    );
  }
}
