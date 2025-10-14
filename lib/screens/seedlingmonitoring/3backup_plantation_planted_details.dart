// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/models/apimodels/communitymodel.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/4mapped_area.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/globals.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// import '../../../../main.dart';

class SeedlingMonitoringPlantedDetails extends StatefulWidget {
  final List<String>? selectedSpeciesPlanted;

  const SeedlingMonitoringPlantedDetails(
      {Key? key, this.selectedSpeciesPlanted})
      : super(key: key);

  @override
  _SeedlingMonitoringPlantedDetailsState createState() =>
      _SeedlingMonitoringPlantedDetailsState();
}

class _SeedlingMonitoringPlantedDetailsState
    extends State<SeedlingMonitoringPlantedDetails> {
  final _formKey = GlobalKey<FormState>();

  // prekese
  final pr_quantityReceived = TextEditingController();
  final pr_quantityPlanted = TextEditingController();
  bool pr_isFarmerDateSelected = false;
  String? pr_farmerBirthDateInString;
  String? pr_farmerdOB;

  // Kokrodua
  final ka_quantityReceived = TextEditingController();
  final ka_quantityPlanted = TextEditingController();
  bool ka_isFarmerDateSelected = false;
  String? ka_farmerBirthDateInString;
  String? ka_farmerdOB;

  // Dahoma
  final da_quantityReceived = TextEditingController();
  final da_quantityPlanted = TextEditingController();
  bool da_isFarmerDateSelected = false;
  String? da_farmerBirthDateInString;
  String? da_farmerdOB;

  // Edinam
  final ed_quantityReceived = TextEditingController();
  final ed_quantityPlanted = TextEditingController();
  bool ed_isFarmerDateSelected = false;
  String? ed_farmerBirthDateInString;
  String? ed_farmerdOB;

  // Emire
  final em_quantityReceived = TextEditingController();
  final em_quantityPlanted = TextEditingController();
  bool em_isFarmerDateSelected = false;
  String? em_farmerBirthDateInString;
  String? em_farmerdOB;

  // Ofram
  final of_quantityReceived = TextEditingController();
  final of_quantityPlanted = TextEditingController();
  bool of_isFarmerDateSelected = false;
  String? of_farmerBirthDateInString;
  String? of_farmerdOB;

  // Mahogany
  final md_quantityReceived = TextEditingController();
  final md_quantityPlanted = TextEditingController();
  bool md_isFarmerDateSelected = false;
  String? md_farmerBirthDateInString;
  String? md_farmerdOB;

  // Mansonia
  final mo_quantityReceived = TextEditingController();
  final mo_quantityPlanted = TextEditingController();
  bool mo_isFarmerDateSelected = false;
  String? mo_farmerBirthDateInString;
  String? mo_farmerdOB;

  // Okoro
  final ok_quantityReceived = TextEditingController();
  final ok_quantityPlanted = TextEditingController();
  bool ok_isFarmerDateSelected = false;
  String? ok_farmerBirthDateInString;
  String? ok_farmerdOB;

  // Efoobodedwo
  final eu_quantityReceived = TextEditingController();
  final eu_quantityPlanted = TextEditingController();
  bool eu_isFarmerDateSelected = false;
  String? eu_farmerBirthDateInString;
  String? eu_farmerdOB;

  // Bako
  final ba_quantityReceived = TextEditingController();
  final ba_quantityPlanted = TextEditingController();
  bool ba_isFarmerDateSelected = false;
  String? ba_farmerBirthDateInString;
  String? ba_farmerdOB;

  // String initFarmerValue = "Select your Birth Date";
  // bool isFarmerDateSelected = false;
  // DateTime? farmerBirthDate;
  // String? farmerBirthDateInString;
  // bool hasFarmerBeenClicked = false;

  // String initKinValue = "Select your Birth Date";
  // bool isKinDateSelected = false;
  // DateTime? kinBirthDate;
  // String? kinBirthDateInString;
  // bool hasKinBeenClicked = false;

  var timechecker = DateTime.now().year - 18;

  bool errorMessage = false;

  int? selectedFarmerRadioGender;
  int? selectedKinRadioGender;

  Future setSSR3ValuesT() async {
    await regSP?.setString('pr_quantityReceived', pr_quantityReceived.text);
    await regSP?.setString('pr_quantityPlanted', pr_quantityPlanted.text);
    await regSP?.setString('pr_farmerdOB', pr_farmerdOB ?? "null");

    await regSP?.setString('ka_quantityReceived', ka_quantityReceived.text);
    await regSP?.setString('ka_quantityPlanted', ka_quantityPlanted.text);
    await regSP?.setString('ka_farmerdOB', ka_farmerdOB ?? "null");

    await regSP?.setString('da_quantityReceived', da_quantityReceived.text);
    await regSP?.setString('da_quantityPlanted', da_quantityPlanted.text);
    await regSP?.setString('da_farmerdOB', da_farmerdOB ?? "null");

    await regSP?.setString('ed_quantityReceived', ed_quantityReceived.text);
    await regSP?.setString('ed_quantityPlanted', ed_quantityPlanted.text);
    await regSP?.setString('ed_farmerdOB', ed_farmerdOB ?? "null");

    await regSP?.setString('em_quantityReceived', em_quantityReceived.text);
    await regSP?.setString('em_quantityPlanted', em_quantityPlanted.text);
    await regSP?.setString('em_farmerdOB', em_farmerdOB ?? "null");

    await regSP?.setString('of_quantityReceived', of_quantityReceived.text);
    await regSP?.setString('of_quantityPlanted', of_quantityPlanted.text);
    await regSP?.setString('of_farmerdOB', of_farmerdOB ?? "null");

    await regSP?.setString('md_quantityReceived', md_quantityReceived.text);
    await regSP?.setString('md_quantityPlanted', md_quantityPlanted.text);
    await regSP?.setString('md_farmerdOB', md_farmerdOB ?? "null");

    await regSP?.setString('mo_quantityReceived', mo_quantityReceived.text);
    await regSP?.setString('mo_quantityPlanted', mo_quantityPlanted.text);
    await regSP?.setString('mo_farmerdOB', mo_farmerdOB ?? "null");

    await regSP?.setString('ok_quantityReceived', ok_quantityReceived.text);
    await regSP?.setString('ok_quantityPlanted', ok_quantityPlanted.text);
    await regSP?.setString('ok_farmerdOB', ok_farmerdOB ?? "null");

    await regSP?.setString('eu_quantityReceived', eu_quantityReceived.text);
    await regSP?.setString('eu_quantityPlanted', eu_quantityPlanted.text);
    await regSP?.setString('eu_farmerdOB', eu_farmerdOB ?? "null");

    await regSP?.setString('ba_quantityReceived', ba_quantityReceived.text);
    await regSP?.setString('ba_quantityPlanted', ba_quantityPlanted.text);
    await regSP?.setString('ba_farmerdOB', ba_farmerdOB ?? "null");

    print("done setting");
  }

  @override
  void initState() {
    super.initState();

    selectedFarmerRadioGender = 0;
    selectedKinRadioGender = 0;

    // regSP?.clear();
  }

  setFarmerSelectedGender(val) {
    setState(() {
      selectedFarmerRadioGender = val;
    });
  }

  setKinSelectedGender(val) {
    setState(() {
      selectedKinRadioGender = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: fPrimaryColour,

      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   backgroundColor: fPrimaryColour,
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     "Seedling Monitoring",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     Tooltip(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
      //         child: InkWell(
      //           child: const Icon(Icons.home, color: fPrimaryWhite),
      //           onTap: () => Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => const IndexPage(),
      //             ),
      //           ),
      //         ),
      //       ),
      //       message: "Takes you back to homepage",
      //     )
      //   ],
      // ),
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
                  "Seedling Monitoring".toUpperCase(),
                  style: const TextStyle(
                    color: primaryWhite,
                    fontSize: 20.0,
                  ),
                ),
                Tooltip(
                  message: "Takes you back to homepage",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: InkWell(
                      child: const Icon(Icons.home, color: fPrimaryWhite),
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const IndexPage(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * .86,
                decoration: const BoxDecoration(
                  color: primaryWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                ),
                margin: const EdgeInsets.all(0.0),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Material(
                            elevation: 0,
                            color: primaryWhite,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 20.0),
                              child: Container(
                                height: size.height * .8,
                                child: ListView(
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          "Species Planted",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ],
                                    ),

                                    // Prekese Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Prekese")
                                        ? ExpansionTile(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(25.0),
                                                  topRight:
                                                      Radius.circular(25.0)),
                                            ),
                                            title: const Text("Prekese"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: pr_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      pr_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: pr_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      pr_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            pr_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              pr_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            pr_isFarmerDateSelected =
                                                                true;
                                                            pr_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              pr_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $pr_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // Kokrodua/ Afromosia Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Kokrodua_Afromosia")
                                        ? ExpansionTile(
                                            title: const Text(
                                                "Kokrodua/ Afromosia"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: ka_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      ka_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: ka_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      ka_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            ka_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              ka_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            ka_isFarmerDateSelected =
                                                                true;
                                                            ka_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              ka_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $ka_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // Dahoma Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Dahoma")
                                        ? ExpansionTile(
                                            title: const Text("Dahoma"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: da_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      da_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: da_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      da_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            da_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              da_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            da_isFarmerDateSelected =
                                                                true;
                                                            da_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              da_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $da_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // Edinam Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Edinam")
                                        ? ExpansionTile(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(25.0),
                                                  topRight:
                                                      Radius.circular(25.0)),
                                            ),
                                            title: const Text("Edinam"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: ed_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      ed_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: ed_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      ed_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            ed_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              ed_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            ed_isFarmerDateSelected =
                                                                true;
                                                            ed_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              ed_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $ed_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // Emire Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Emire")
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Emire",
                                              quantityReceived:
                                                  em_quantityReceived,
                                              quantityPlanted:
                                                  em_quantityPlanted,
                                              farmerDateSelected:
                                                  em_isFarmerDateSelected,
                                              birthdayString:
                                                  em_farmerBirthDateInString,
                                              farmerDOB: em_farmerdOB,
                                            );
                                          })
                                        : const SizedBox(),

                                    // Ofram Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Ofram")
                                        ? ExpansionTile(
                                            title: const Text("Ofram"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: of_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      of_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: of_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      of_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            of_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              of_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            of_isFarmerDateSelected =
                                                                true;
                                                            of_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              of_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $of_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // Mahogany/ Dubini Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Mahogany_Dubini")
                                        ? ExpansionTile(
                                            title:
                                                const Text("Mahogany/ Dubini"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: md_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      md_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: md_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      md_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            md_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              md_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            md_isFarmerDateSelected =
                                                                true;
                                                            md_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              md_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $md_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // Mansonia/ Oprono Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Mansonia_Oprono")
                                        ? ExpansionTile(
                                            title:
                                                const Text("Mansonia/ Oprono"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: mo_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      mo_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: mo_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      mo_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            mo_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              mo_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            mo_isFarmerDateSelected =
                                                                true;
                                                            mo_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              mo_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $mo_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // Okoro Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Okoro")
                                        ? ExpansionTile(
                                            title: const Text("Okoro"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: ok_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      ok_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: ok_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      ok_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            ok_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              ok_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            ok_isFarmerDateSelected =
                                                                true;
                                                            ok_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              ok_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $ok_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // Efoobodedwo/ Utile Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Efoobodedwo_Utile")
                                        ? ExpansionTile(
                                            title: const Text(
                                                "Efoobodedwo/ Utile"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: eu_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      eu_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: eu_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      eu_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            eu_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              eu_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            eu_isFarmerDateSelected =
                                                                true;
                                                            eu_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              eu_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $eu_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // Bako Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Bako")
                                        ? ExpansionTile(
                                            title: const Text("Bako"),
                                            children: [
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity received"),
                                                labelText: "Quantity received",
                                                controller: ba_quantityReceived,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      ba_quantityReceived.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Quantity planted"),
                                                labelText: "Quantity planted",
                                                controller: ba_quantityPlanted,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter your first name';
                                                  } else {
                                                    setState(() {
                                                      ba_quantityPlanted.text =
                                                          input;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                // width: MediaQuery.of(context).size.width - 90,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text(
                                                            "Date of planting",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                        child:
                                                            ba_isFarmerDateSelected ==
                                                                    true
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          fPrimaryColour,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    height:
                                                                        40.0,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          const Icon(
                                                                            Icons.arrow_drop_down_circle,
                                                                            size:
                                                                                22,
                                                                            color:
                                                                                Color(0xFFffe423),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Text(
                                                                              ba_farmerBirthDateInString ?? "date planted",
                                                                              style: const TextStyle(
                                                                                color: Color(0xFFf9f9f9),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const Row(
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        size:
                                                                            18,
                                                                        color:
                                                                            fPrimaryColour,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        // size: 34,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                    ],
                                                                  ),
                                                        onTap: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  const DatePickerTheme(
                                                                backgroundColor:
                                                                    fPrimaryColour,
                                                                itemStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                cancelStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFffe423)),
                                                                doneStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFf9f9f9)),
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  1800, 1, 1),
                                                              maxTime: DateTime
                                                                  .now(),
                                                              onConfirm:
                                                                  (date) {
                                                            // if (DateTime.now()
                                                            //             .year -
                                                            //         date.year <
                                                            //     18) {
                                                            //   overlayNotification(
                                                            //       'Must be 18 years and above',
                                                            //       "negative");
                                                            // } else {
                                                            print(
                                                                'confirm $date');
                                                            ba_isFarmerDateSelected =
                                                                true;
                                                            ba_farmerBirthDateInString =
                                                                '${date.day}/${date.month}/${date.year}';
                                                            setState(() {
                                                              ba_farmerdOB =
                                                                  '${date.year}-${date.month}-${date.day}';
                                                              print(
                                                                  "DOOB $ba_farmerdOB");
                                                            });
                                                            // }
                                                          },
                                                              // currentTime: DateTime.now(),
                                                              locale: LocaleType
                                                                  .en);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),

                                    // end of tiles

                                    const SizedBox(height: 30.0),
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
                                          child: ElevatedButton(
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
                                            child: const Text(
                                              "Next",
                                              style: TextStyle(
                                                  color: fPrimaryWhite,
                                                  fontSize: 17.0,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            onPressed: () async {
                                              await setSSR3ValuesT()
                                                  .then((value) {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  // print(
                                                  //     "Farmer detail ${farmerfirstName.text} and $_farmerdOB and $_kinGender");
                                                  regSP?.setBool(
                                                      "ssr3_skipped", false);
                                                  Navigator.of(context).push(
                                                    CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          SeedlingMonitoringMappedArea(),
                                                    ),
                                                  );
                                                }
                                                // else if (farmerBirthDateInString ==
                                                //     null) {
                                                //   overlayNotification(
                                                //       'Farmer Date of birth not selected',
                                                //       "negative");
                                                // } else if (kinBirthDateInString ==
                                                //     null) {
                                                //   overlayNotification(
                                                //       'Kin Date of birth not selected',
                                                //       "negative");
                                                // } else if (_farmerGender !=
                                                //         "male" &&
                                                //     _farmerGender !=
                                                //         "female") {
                                                //   overlayNotification(
                                                //       'Farmer gender not selected',
                                                //       "negative");
                                                // } else if (_kinGender !=
                                                //         "male" &&
                                                //     _kinGender !=
                                                //         "female") {
                                                //   overlayNotification(
                                                //       'Kin gender not selected',
                                                //       "negative");
                                                // }
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: 50.00,
                                          child: ElevatedButton(
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
                                            child: const Text(
                                              "Skip",
                                              style: TextStyle(
                                                  color: fPrimaryWhite,
                                                  fontSize: 17.0,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            onPressed: () async {
                                              regSP?.setBool(
                                                  "ssr3_skipped", true);
                                              // if (_establishment.isEmpty) {
                                              //   overlayNotification(
                                              //       'Please select type of establishment',
                                              //       "negative");
                                              // } else {
                                              setSSR3ValuesT();
                                              Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      SeedlingMonitoringMappedArea(),
                                                ),
                                              );

                                              // print(
                                              //     "Selected types are $_establishment");
                                              // }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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

  ExpansionTile expansionTileTemplate(
    BuildContext context, size, {
    String tileName = "",
    TextEditingController? quantityReceived,
    TextEditingController? quantityPlanted,
    bool farmerDateSelected = false,
    String? birthdayString,
    String? farmerDOB,
  }) {
    bool f = widget.selectedSpeciesPlanted!.length %
            widget.selectedSpeciesPlanted!.indexOf(tileName) ==
        0;

    return ExpansionTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: primaryColour, width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      collapsedBackgroundColor: f ? secondaryColour2 : Colors.transparent,
      onExpansionChanged: (d) {
        debugPrint("Expansion value $d");
      },
      childrenPadding: const EdgeInsets.symmetric(vertical: 10.0),
      // title: const Text("Emire"),
      title: formFieldLabel(width: size.width * .9, tileName),
      children: [
        TextFieldWidget(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Quantity received"),
          labelText: "Quantity received",
          controller: quantityReceived!,
          onChanged: (value) {},
          validator: (input) {
            if (input!.trim().isEmpty) {
              return 'Please enter your first name';
            } else {
              setState(() {
                quantityReceived.text = input;
              });
            }
          },
        ),
        TextFieldWidget(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Quantity planted"),
          labelText: "Quantity planted",
          controller: quantityPlanted!,
          onChanged: (value) {},
          validator: (input) {
            if (input!.trim().isEmpty) {
              return 'Please enter your first name';
            } else {
              setState(() {
                quantityPlanted.text = input;
              });
            }
          },
        ),
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              formFieldLabel(width: size.width * .9, "Date of planting"),
              StatefulBuilder(builder: (context, d) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: farmerDateSelected == true
                        ? Container(
                            decoration: BoxDecoration(
                              color: fPrimaryColour,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 40.0,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.arrow_drop_down_circle,
                                    size: 22,
                                    color: Color(0xFFffe423),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      birthdayString ?? "date planted",
                                      style: const TextStyle(
                                        color: Color(0xFFf9f9f9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const Row(
                            children: <Widget>[
                              Icon(
                                Icons.arrow_drop_down_circle,
                                size: 18,
                                color: fPrimaryColour,
                              ),
                              Icon(
                                Icons.calendar_today,
                                // size: 34,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          theme: const DatePickerTheme(
                            backgroundColor: fPrimaryColour,
                            itemStyle: TextStyle(color: Color(0xFFf9f9f9)),
                            cancelStyle: TextStyle(color: Color(0xFFffe423)),
                            doneStyle: TextStyle(color: Color(0xFFf9f9f9)),
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(1800, 1, 1),
                          maxTime: DateTime.now(), onConfirm: (date) {
                        // if (DateTime.now()
                        //             .year -
                        //         date.year <
                        //     18) {
                        //   overlayNotification(
                        //       'Must be 18 years and above',
                        //       "negative");
                        // } else {
                        print('confirm $date');
                        setState(() {
                          farmerDateSelected = true;
                          birthdayString =
                              '${date.day}/${date.month}/${date.year}';
                          farmerDOB = '${date.year}-${date.month}-${date.day}';
                          print("DOOB $farmerDOB");
                        });
                        // }
                      },
                          // currentTime: DateTime.now(),
                          locale: LocaleType.en);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
