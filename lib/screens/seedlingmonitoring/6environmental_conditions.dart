import 'dart:convert';
import 'dart:io';

import 'package:hcms_revived2/models/apimodels/communitymodel.dart';
import 'package:hcms_revived2/models/apimodels/forestdistrict.dart';
import 'package:hcms_revived2/models/apimodels/regionmodel.dart';
import 'package:hcms_revived2/models/apimodels/stool.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/3plantation_planted_details.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/7final_page.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/models/apimodels/districtmodel.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmcordinates.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import '../../../main.dart';

class SeedlingMonitoringEnvironmentalConditions extends StatefulWidget {
  @override
  _SeedlingMonitoringEnvironmentalConditionsState createState() =>
      _SeedlingMonitoringEnvironmentalConditionsState();
}

class _SeedlingMonitoringEnvironmentalConditionsState
    extends State<SeedlingMonitoringEnvironmentalConditions> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _otherController = TextEditingController();
  List<String> _sourceOfWater = [];
  List<String> _extremeWeathers = [];

// for source of water - bools
  bool _isRFchecked = false;
  bool _isMWchecked = false;
  bool _isIPchecked = false;

// for extreme weathers - bools
  bool _isDrchecked = false;
  bool _isFlchecked = false;
  bool _isFichecked = false;
  bool _isOtchecked = false;

// saved preference
  void setSSR6ValuesT() {
    regSP?.setStringList("ssr_sourceOfWater", _sourceOfWater);
    regSP?.setString("ssr_wateringFrequency", _waterFrequency ?? "null");
    regSP?.setString("ssr_anyExtremeSigns", _yesNoValue ?? "null");
    regSP?.setStringList("ssr_extremeWeathers", _extremeWeathers);

    debugPrint("Tree Information values gotten!");
  }

// for selections
  onSelectedRow(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _sourceOfWater.add(selectedEst);
      } else {
        _sourceOfWater.remove(selectedEst);
      }
    });
  }

  onSelectedReasonForDeaths(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _extremeWeathers.add(selectedEst);
      } else {
        _extremeWeathers.remove(selectedEst);
      }
    });
  }

// for source of water
  void _onRfChanged(bool val) {
    setState(() {
      _isRFchecked = val;
      onSelectedRow(val, "Rain_Fed");

      if (val) {
        _isRFchecked = _isRFchecked;
        _isMWchecked = _isMWchecked;
        _isIPchecked = _isIPchecked;
      }
    });
  }

  void _onMWChanged(bool val) {
    setState(() {
      _isMWchecked = val;
      onSelectedRow(val, "Manual_Watering");

      if (val) {
        _isRFchecked = _isRFchecked;
        _isMWchecked = _isMWchecked;
        _isIPchecked = _isIPchecked;
      }
    });
  }

  void _onIPChanged(bool val) {
    setState(() {
      _isIPchecked = val;
      onSelectedRow(val, "Irrigation_With_Pumps");

      if (val) {
        _isRFchecked = _isRFchecked;
        _isMWchecked = _isMWchecked;
        _isIPchecked = _isIPchecked;
      }
    });
  }
// end of for source of water

// for reasons for death
  void _onDrChanged(bool val) {
    setState(() {
      _isDrchecked = val;
      onSelectedReasonForDeaths(val, "Drought");
      debugPrint("Val be $val");

      if (val) {
        _isDrchecked = _isDrchecked;
        _isFlchecked = _isFlchecked;
        _isFichecked = _isFichecked;
        _isOtchecked = _isOtchecked;
      }
    });
  }

  void _onFlChanged(bool val) {
    setState(() {
      _isFlchecked = val;
      onSelectedReasonForDeaths(val, "Flooding");
      debugPrint("Val be $val");

      if (val) {
        _isDrchecked = _isDrchecked;
        _isFlchecked = _isFlchecked;
        _isFichecked = _isFichecked;
        _isOtchecked = _isOtchecked;
      }
    });
  }

  void _onFiChanged(bool val) {
    setState(() {
      _isFichecked = val;
      onSelectedReasonForDeaths(val, "Fire");
      debugPrint("Val be $val");

      if (val) {
        _isDrchecked = _isDrchecked;
        _isFlchecked = _isFlchecked;
        _isFichecked = _isFichecked;
        _isOtchecked = _isOtchecked;
      }
    });
  }

  void _onOtChanged(bool val) {
    setState(() {
      _isOtchecked = val;
      onSelectedReasonForDeaths(val, "Other");
      debugPrint("Val be $val");

      if (val) {
        _isDrchecked = _isDrchecked;
        _isFlchecked = _isFlchecked;
        _isFichecked = _isFichecked;
        _isOtchecked = _isOtchecked;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectedFarmerRadioGender = 0;
    yesNoRadio = 0;

    // forestdistrictFileInit();
    // stoolFileInit();
    // districtFileInit();
    // commFileInit();
    // regionFileInit();

    // myDFuture = writeToDistrictFile(this.context);
    // myFDFuture = writeToForestDistrictFile(this.context);
    // mySFuture = writeToStoolFile(this.context);
    // myCFuture = writeToCommFile(this.context);
    // myRFuture = writeToRegionFile(this.context);

    // _mmdas = 96;
    // reg = "Western Region";
    // fD = "First";

    // _establishment = [];
  }

  final farmerGender = TextEditingController();
  String? _waterFrequency;
  int? selectedFarmerRadioGender;

  String? _yesNoValue;
  int? yesNoRadio;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: fPrimaryColour,

      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: fPrimaryColour,
      //   title: const Text(
      //     "Seedling Monitoring",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     PopupMenuButton<String>(
      //       offset: const Offset(2.00, 3.00),
      //       color: Colors.black,
      //       onSelected: (String _downChoice) {
      //         if (_downChoice == Constants.home) {
      //           Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => const IndexPage(),
      //             ),
      //           );
      //         } else if (_downChoice == Constants.load) {
      //           Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext context) => this.widget));
      //           // setState(() {
      //           //   getApplicationDocumentsDirectory().then(
      //           //     (Directory directory) async {
      //           //       dir = directory;
      //           //       districtjsonFile =
      //           //           new File(dir!.path + "/" + districtfileName);
      //           //       districtfileExists = await districtjsonFile.exists();
      //           //       forestdistrictjsonFile =
      //           //           new File(dir!.path + "/" + forestdistrictfileName);
      //           //       forestdistrictfileExists =
      //           //           await forestdistrictjsonFile.exists();
      //           //       stooljsonFile = new File(dir!.path + "/" + stoolfileName);
      //           //       stoolfileExists = await stooljsonFile.exists();

      //           //       if (forestdistrictfileExists &&
      //           //           districtfileExists &&
      //           //           stoolfileExists) {
      //           //         forestdistrictfileContent = await json.decode(
      //           //             await forestdistrictjsonFile!.readAsString());

      //           //         districtfileContent = await json
      //           //             .decode(await districtjsonFile!.readAsString());

      //           //         stoolfileContent = await json
      //           //             .decode(await stooljsonFile!.readAsString());
      //           //       }
      //           //       //else {}
      //           //       // if (districtfileExists) {
      //           //       //   districtfileContent =
      //           //       //       await json.decode(await districtjsonFile!.readAsString());
      //           //       // } else {}
      //           //       // if (stoolfileExists) {
      //           //       //   stoolfileContent =
      //           //       //       await json.decode(await stooljsonFile!.readAsString());
      //           //       // } else {}
      //           //     },
      //           //   );
      //           // });
      //         } else if (_downChoice == Constants.saveskip) {
      //           regSP?.setBool("farmdetskipped", true);
      //           // if (_establishment.isEmpty) {
      //           //   overlayNotification(
      //           //       'Please select type of establishment', "negative");
      //           // } else {
      //           setSSR6ValuesT();
      //           Navigator.of(context).push(
      //             CupertinoPageRoute(
      //               builder: (BuildContext context) => FarmCordinates(),
      //             ),
      //           );

      //           // debugPrint("Selected types are $_establishment");
      //           // }
      //         } else if (_downChoice == Constants.saveclose) {
      //           // regSP?.setBool("closed", true);
      //           // setFDValuesT();
      //           // Navigator.of(context).push(
      //           //   CupertinoPageRoute(
      //           //     builder: (BuildContext context) => FarmCordinates(),
      //           //   ),
      //           // );
      //         }
      //       },
      //       itemBuilder: (BuildContext context) {
      //         return Constants.downChoices.map((String _downChoice) {
      //           return PopupMenuItem<String>(
      //             value: _downChoice,
      //             child: Container(
      //               margin: const EdgeInsets.only(right: 0),
      //               child: Text(
      //                 _downChoice,
      //                 style: const TextStyle(color: Color(0xFFFFFFFF)),
      //               ),
      //             ),
      //           );
      //         }).toList();
      //       },
      //     ),
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
                PopupMenuButton<String>(
                  offset: const Offset(2.00, 3.00),
                  color: Colors.black,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: primaryWhite,
                    size: 40.0,
                  ),
                  onSelected: (String _downChoice) {
                    if (_downChoice == Constants.home) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const IndexPage(),
                        ),
                      );
                    } else if (_downChoice == Constants.load) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => this.widget));
                      // setState(() {
                      //   getApplicationDocumentsDirectory().then(
                      //     (Directory directory) async {
                      //       dir = directory;
                      //       districtjsonFile =
                      //           new File(dir!.path + "/" + districtfileName);
                      //       districtfileExists = await districtjsonFile.exists();
                      //       forestdistrictjsonFile =
                      //           new File(dir!.path + "/" + forestdistrictfileName);
                      //       forestdistrictfileExists =
                      //           await forestdistrictjsonFile.exists();
                      //       stooljsonFile = new File(dir!.path + "/" + stoolfileName);
                      //       stoolfileExists = await stooljsonFile.exists();

                      //       if (forestdistrictfileExists &&
                      //           districtfileExists &&
                      //           stoolfileExists) {
                      //         forestdistrictfileContent = await json.decode(
                      //             await forestdistrictjsonFile!.readAsString());

                      //         districtfileContent = await json
                      //             .decode(await districtjsonFile!.readAsString());

                      //         stoolfileContent = await json
                      //             .decode(await stooljsonFile!.readAsString());
                      //       }
                      //       //else {}
                      //       // if (districtfileExists) {
                      //       //   districtfileContent =
                      //       //       await json.decode(await districtjsonFile!.readAsString());
                      //       // } else {}
                      //       // if (stoolfileExists) {
                      //       //   stoolfileContent =
                      //       //       await json.decode(await stooljsonFile!.readAsString());
                      //       // } else {}
                      //     },
                      //   );
                      // });
                    } else if (_downChoice == Constants.saveskip) {
                      regSP?.setBool("farmdetskipped", true);
                      // if (_establishment.isEmpty) {
                      //   overlayNotification(
                      //       'Please select type of establishment', "negative");
                      // } else {
                      setSSR6ValuesT();
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => FarmCordinates(),
                        ),
                      );

                      // debugPrint("Selected types are $_establishment");
                      // }
                    } else if (_downChoice == Constants.saveclose) {
                      // regSP?.setBool("closed", true);
                      // setFDValuesT();
                      // Navigator.of(context).push(
                      //   CupertinoPageRoute(
                      //     builder: (BuildContext context) => FarmCordinates(),
                      //   ),
                      // );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return Constants.downChoices.map((String _downChoice) {
                      return PopupMenuItem<String>(
                        value: _downChoice,
                        child: Container(
                          margin: const EdgeInsets.only(right: 0),
                          child: Text(
                            _downChoice,
                            style: const TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: fDefaultPadding),
                            //   child: Center(
                            //     child: Text(
                            //       "Environment Conditions",
                            //       style: TextStyle(
                            //           fontSize: 20.0, fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            Center(child: titleOne("Environment Conditions")),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // Row(
                                  //   children: <Widget>[
                                  //     Container(
                                  //       margin: const EdgeInsets.only(
                                  //         bottom: 14.0,
                                  //       ),
                                  //       child: const Row(
                                  //         children: <Widget>[
                                  //           Text(
                                  //             "Source of water",
                                  //             style: TextStyle(
                                  //                 fontSize: 17,
                                  //                 fontWeight: FontWeight.w500),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  formFieldLabel(width: size.width * .9, "Source of water"),
                                  CheckboxListTile(
                                    title: const Text(
                                      "Rain fed",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    value: _isRFchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onRfChanged(value!);
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: const Text(
                                      "Manual watering",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    value: _isMWchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onMWChanged(value!);
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: const Text(
                                      "Irrigation with pumps",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    value: _isIPchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onIPChanged(value!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // const Row(
                                  //   children: <Widget>[
                                  //     Padding(
                                  //       padding: EdgeInsets.all(0.0),
                                  //       child: Text(
                                  //         "Average watering frequency",
                                  //         style: TextStyle(
                                  //             fontSize: 17,
                                  //             fontWeight: FontWeight.w500),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  formFieldLabel(width: size.width * .9, "Average watering frequency"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 1,
                                            group: selectedFarmerRadioGender,
                                            selected: (val) {
                                              // debugPrint(val);
                                              setState(() {
                                                selectedFarmerRadioGender = val;
                                                // debugPrint(val);
                                                _waterFrequency = "Daily";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Daily",
                                            // style: TextStyle(
                                            //     color: Color(0xFFf9f9f9)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 2,
                                            group: selectedFarmerRadioGender,
                                            selected: (val) {
                                              // debugPrint(val);
                                              setState(() {
                                                selectedFarmerRadioGender = val;
                                                _waterFrequency = "Weekly";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Weekly",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 3,
                                            group: selectedFarmerRadioGender,
                                            selected: (val) {
                                              // debugPrint(val);
                                              setState(() {
                                                selectedFarmerRadioGender = val;
                                                _waterFrequency = "Monthly";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Monthly",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 4,
                                            group: selectedFarmerRadioGender,
                                            selected: (val) {
                                              // debugPrint(val);
                                              setState(() {
                                                selectedFarmerRadioGender = val;
                                                _waterFrequency = "Rarely_Never";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Rarely/ Never",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //   children: <Widget>[
                                      //     GenderRadioButton(
                                      //       value: 2,
                                      //       group: selectedFarmerRadioGender,
                                      //       selected: (val) {
                                      //         // debugPrint(val);
                                      //         setState(() {
                                      //           selectedFarmerRadioGender = val;
                                      //           _waterFrequency = "others";
                                      //         });
                                      //       },
                                      //     ),
                                      //     Text(
                                      //       "Others",
                                      //       // style: TextStyle(
                                      //       //     color:
                                      //       //         Color(0xFFf9f9f9))
                                      //     ),
                                      //   ],
                                      // ),
                                      // Container(
                                      //   margin: EdgeInsets.only(
                                      //       left: 10.0, right: 10.0, bottom: 8.0),
                                      //   child: TextFieldWidget(
                                      //     readOnly:
                                      //         _isOchecked == true ? false : true,
                                      //     decoration: InputDecoration(
                                      //       hintText: "(Specify)",
                                      //       hintStyle: TextStyle(
                                      //           fontStyle: FontStyle.italic),
                                      //     ),
                                      //     // controller: _usernameController,
                                      //     validator: (input) => _establishment
                                      //             .contains("Other")
                                      //         ? input!.trim().isEmpty
                                      //             ? 'Please specify type of establishment'
                                      //             : null
                                      //         : null,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                              child: Divider(
                                color: Colors.transparent,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: const Text(
                                            "Have there been any extreme weather events since the seedlings were planted?",
                                            softWrap: true,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // formFieldLabel(width: size.width * .9, 
                                  //     "Have there been any extreme weather events since the seedlings were planted?"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 1,
                                            group: yesNoRadio,
                                            selected: (val) {
                                              // // debugPrint(val);
                                              setState(() {
                                                yesNoRadio = val;
                                                // // debugPrint(val);
                                                _yesNoValue = "Yes";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Yes",
                                            // style: TextStyle(
                                            //     color: Color(0xFFf9f9f9)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 2,
                                            group: yesNoRadio,
                                            selected: (val) {
                                              // debugPrint(val);
                                              setState(() {
                                                yesNoRadio = val;
                                                _yesNoValue = "No";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "No",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                              child: Divider(
                                color: Colors.transparent,
                              ),
                            ),
                            _yesNoValue == "Yes"
                                ? Container(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 14.0,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: const Text(
                                                      "What type of extreme weather events occured since the seedlings were planted",
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        CheckboxListTile(
                                          title: const Text(
                                            "Drought",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: _isDrchecked,
                                          activeColor: fPrimaryColour,
                                          onChanged: (bool? value) {
                                            _onDrChanged(value!);
                                          },
                                        ),
                                        CheckboxListTile(
                                          title: const Text(
                                            "Flooding",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: _isFlchecked,
                                          activeColor: fPrimaryColour,
                                          onChanged: (bool? value) {
                                            _onFlChanged(value!);
                                          },
                                        ),
                                        CheckboxListTile(
                                          title: const Text(
                                            "Fire",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: _isFichecked,
                                          activeColor: fPrimaryColour,
                                          onChanged: (bool? value) {
                                            _onFiChanged(value!);
                                          },
                                        ),
                                        CheckboxListTile(
                                          title: const Text(
                                            "Others",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: _isOtchecked,
                                          activeColor: fPrimaryColour,
                                          onChanged: (bool? value) {
                                            _onOtChanged(value!);
                                          },
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              bottom: 8.0),
                                          child: TextFieldWidget(
                                            readonly: _isOtchecked == true
                                                ? false
                                                : true,
                                            decoration: const InputDecoration(
                                              hintText: "(Specify Other)",
                                              hintStyle: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            labelText: "(Specify Other)",
                                            controller: TextEditingController(),
                                            validator: (input) => _extremeWeathers
                                                    .contains("Other")
                                                ? input!.trim().isEmpty
                                                    ? 'Please specify other extreme weather'
                                                    : null
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: const Color(0xFFFFFFFF),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
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
                                                      BorderRadius.circular(
                                                          10.0),
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
                                                if (_sourceOfWater.isEmpty) {
                                                  overlayNotification(
                                                      'Please select source of water',
                                                      "negative");
                                                } else if (_waterFrequency ==
                                                    null) {
                                                  overlayNotification(
                                                      'Please select average watering frequency',
                                                      "negative");
                                                } else if (_yesNoValue ==
                                                    null) {
                                                  overlayNotification(
                                                      'Any extreme weathers? Select yes or no',
                                                      "negative");
                                                } else if (_yesNoValue ==
                                                        "Yes" &&
                                                    _extremeWeathers.isEmpty) {
                                                  overlayNotification(
                                                      'Please select extreme weathers',
                                                      "negative");
                                                } else if (_formKey
                                                    .currentState!
                                                    .validate()) {
                                                  regSP?.setBool(
                                                      "ssr6_skipped", false);
                                                  setSSR6ValuesT();
                                                  Navigator.of(context).push(
                                                    CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          SeedlingMonitoringFinalPage(),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
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
                                                      BorderRadius.circular(
                                                          10.0),
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
                                                    "ssr6_skipped", true);
                                                // if (_establishment.isEmpty) {
                                                //   overlayNotification(
                                                //       'Please select type of establishment',
                                                //       "negative");
                                                // } else {
                                                setSSR6ValuesT();
                                                Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        SeedlingMonitoringFinalPage(),
                                                  ),
                                                );

                                                // debugPrint(
                                                //     "Selected types are $_establishment");
                                                // }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}
