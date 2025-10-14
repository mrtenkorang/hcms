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
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Prekese",
                                              quantityReceived:
                                                  pr_quantityReceived,
                                              quantityPlanted:
                                                  pr_quantityPlanted,
                                              farmerDateSelected:
                                                  pr_isFarmerDateSelected,
                                              birthdayString:
                                                  pr_farmerBirthDateInString,
                                              farmerDOB: pr_farmerdOB,
                                            );
                                          })
                                        : const SizedBox(),

                                    // Kokrodua/ Afromosia Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Kokrodua_Afromosia")
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Kokrodua/ Afromosia",
                                              quantityReceived:
                                                  ka_quantityReceived,
                                              quantityPlanted:
                                                  ka_quantityPlanted,
                                              farmerDateSelected:
                                                  ka_isFarmerDateSelected,
                                              birthdayString:
                                                  ka_farmerBirthDateInString,
                                              farmerDOB: ka_farmerdOB,
                                            );
                                          })
                                        : const SizedBox(),

                                    // Dahoma Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Dahoma")
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Dahoma",
                                              quantityReceived:
                                                  da_quantityReceived,
                                              quantityPlanted:
                                                  da_quantityPlanted,
                                              farmerDateSelected:
                                                  da_isFarmerDateSelected,
                                              birthdayString:
                                                  da_farmerBirthDateInString,
                                              farmerDOB: da_farmerdOB,
                                            );
                                          })
                                        : const SizedBox(),

                                    // Edinam Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Edinam")
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Edinam",
                                              quantityReceived:
                                                  ed_quantityReceived,
                                              quantityPlanted:
                                                  ed_quantityPlanted,
                                              farmerDateSelected:
                                                  ed_isFarmerDateSelected,
                                              birthdayString:
                                                  ed_farmerBirthDateInString,
                                              farmerDOB: ed_farmerdOB,
                                            );
                                          })
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
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Ofram",
                                              quantityReceived:
                                                  of_quantityReceived,
                                              quantityPlanted:
                                                  of_quantityPlanted,
                                              farmerDateSelected:
                                                  of_isFarmerDateSelected,
                                              birthdayString:
                                                  of_farmerBirthDateInString,
                                              farmerDOB: of_farmerdOB,
                                            );
                                          })
                                        : const SizedBox(),

                                    // Mahogany/ Dubini Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Mahogany_Dubini")
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Mahogany/ Dubini",
                                              quantityReceived:
                                                  md_quantityReceived,
                                              quantityPlanted:
                                                  md_quantityPlanted,
                                              farmerDateSelected:
                                                  md_isFarmerDateSelected,
                                              birthdayString:
                                                  md_farmerBirthDateInString,
                                              farmerDOB: md_farmerdOB,
                                            );
                                          })
                                        : const SizedBox(),

                                    // Mansonia/ Oprono Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Mansonia_Oprono")
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Mansonia/ Oprono",
                                              quantityReceived:
                                                  mo_quantityReceived,
                                              quantityPlanted:
                                                  mo_quantityPlanted,
                                              farmerDateSelected:
                                                  mo_isFarmerDateSelected,
                                              birthdayString:
                                                  mo_farmerBirthDateInString,
                                              farmerDOB: mo_farmerdOB,
                                            );
                                          })
                                        : const SizedBox(),

                                    // Okoro Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Okoro")
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Okoro",
                                              quantityReceived:
                                                  ok_quantityReceived,
                                              quantityPlanted:
                                                  ok_quantityPlanted,
                                              farmerDateSelected:
                                                  ok_isFarmerDateSelected,
                                              birthdayString:
                                                  ok_farmerBirthDateInString,
                                              farmerDOB: ok_farmerdOB,
                                            );
                                          })
                                        : const SizedBox(),

                                    // Efoobodedwo/ Utile Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Efoobodedwo_Utile")
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Efoobodedwo/ Utile",
                                              quantityReceived:
                                                  eu_quantityReceived,
                                              quantityPlanted:
                                                  eu_quantityPlanted,
                                              farmerDateSelected:
                                                  eu_isFarmerDateSelected,
                                              birthdayString:
                                                  eu_farmerBirthDateInString,
                                              farmerDOB: eu_farmerdOB,
                                            );
                                          })
                                        : const SizedBox(),

                                    // Bako Expansion Tile
                                    widget.selectedSpeciesPlanted!
                                            .contains("Bako")
                                        ? StatefulBuilder(
                                            builder: (context, d) {
                                            return expansionTileTemplate(
                                              context,size,
                                              tileName: "Bako",
                                              quantityReceived:
                                                  ba_quantityReceived,
                                              quantityPlanted:
                                                  ba_quantityPlanted,
                                              farmerDateSelected:
                                                  ba_isFarmerDateSelected,
                                              birthdayString:
                                                  ba_farmerBirthDateInString,
                                              farmerDOB: ba_farmerdOB,
                                            );
                                          })
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

  Padding expansionTileTemplate(
    BuildContext context, size, {
    String tileName = "",
    TextEditingController? quantityReceived,
    TextEditingController? quantityPlanted,
    bool farmerDateSelected = false,
    String? birthdayString,
    String? farmerDOB,
  }) {
    bool f = widget.selectedSpeciesPlanted!.indexOf(tileName) % 2 == 0;
    double padding = 10.0;
    bool tileExpanded = false;

    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: tileExpanded == true ? padding : 0.0),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: primaryColour, width: 1.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        collapsedBackgroundColor: f ? secondaryColour2 : Colors.transparent,
        onExpansionChanged: (d) {
          debugPrint("Expansion value $d");
          setState(() {
            tileExpanded = d;
          });
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
                            farmerDOB =
                                '${date.year}-${date.month}-${date.day}';
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
      ),
    );
  }
}
