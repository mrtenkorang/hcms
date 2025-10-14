import 'dart:convert';
import 'dart:io';

import 'package:hcms_revived2/screens/seedlingmonitoring/3plantation_planted_details.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/5.1seedling_mapping.dart';
import 'package:hcms_revived2/screens/seedlingmonitoring/6environmental_conditions.dart';
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

class SeedlingMonitoringSeedlingSurvival extends StatefulWidget {
  @override
  _SeedlingMonitoringSeedlingSurvivalState createState() =>
      _SeedlingMonitoringSeedlingSurvivalState();
}

class _SeedlingMonitoringSeedlingSurvivalState
    extends State<SeedlingMonitoringSeedlingSurvival> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _totalSeedlingsAliveController =
      TextEditingController();
  List<String> _speciesAlive = [];
  List<String> _reasonForDeath = [];

// for species alive - bools
  bool _isPrchecked = false;
  bool _isKAchecked = false;
  bool _isDachecked = false;
  bool _isEdchecked = false;
  bool _isEmchecked = false;
  bool _isOfchecked = false;
  bool _isMDchecked = false;
  bool _isMOchecked = false;
  bool _isOkchecked = false;
  bool _isEUchecked = false;
  bool _isBachecked = false;

// for reasons for death - bools
  bool _isDichecked = false;
  bool _isDrchecked = false;
  bool _isPechecked = false;
  bool _isVachecked = false;
  bool _isTSchecked = false;

// saved preference
  void setSSR5ValuesT() {
    regSP?.setString("ssr_totalAlive", _totalSeedlingsAliveController.text);
    regSP?.setStringList("ssr_speciesAlive", _speciesAlive);
    regSP?.setStringList("ssr_reasonsForDeath", _reasonForDeath);

    print("Tree Information values gotten!");
  }

// for selections
  onSelectedRow(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _speciesAlive.add(selectedEst);
      } else {
        _speciesAlive.remove(selectedEst);
      }
    });
  }

  onSelectedReasonForDeaths(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _reasonForDeath.add(selectedEst);
      } else {
        _reasonForDeath.remove(selectedEst);
      }
    });
  }

// for species alive
  void _onPrChanged(bool val) {
    setState(() {
      _isPrchecked = val;
      onSelectedRow(val, "Prekese");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onKAChanged(bool val) {
    setState(() {
      _isKAchecked = val;
      onSelectedRow(val, "Kokrodua_Afromosia");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onDahanged(bool val) {
    setState(() {
      _isDachecked = val;
      onSelectedRow(val, "Dahoma");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onEdChanged(bool val) {
    setState(() {
      _isEdchecked = val;
      onSelectedRow(val, "Edinam");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onEmChanged(bool val) {
    setState(() {
      _isEmchecked = val;
      onSelectedRow(val, "Emire");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onOfChanged(bool val) {
    setState(() {
      _isOfchecked = val;
      onSelectedRow(val, "Ofram");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onMDChanged(bool val) {
    setState(() {
      _isMDchecked = val;
      onSelectedRow(val, "Mahogany_Dubini");
      print("Val be $val");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onMOChanged(bool val) {
    setState(() {
      _isMOchecked = val;
      onSelectedRow(val, "Mansonia_Oprono");
      print("Val be $val");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onOkChanged(bool val) {
    setState(() {
      _isOkchecked = val;
      onSelectedRow(val, "Okoro");
      print("Val be $val");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onEUChanged(bool val) {
    setState(() {
      _isEUchecked = val;
      onSelectedRow(val, "Efoobodedwo_Utile");
      print("Val be $val");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }

  void _onBaChanged(bool val) {
    setState(() {
      _isBachecked = val;
      onSelectedRow(val, "Bako");
      print("Val be $val");

      if (val) {
        _isPrchecked = _isPrchecked;
        _isKAchecked = _isKAchecked;
        _isDachecked = _isDachecked;
        _isEdchecked = _isEdchecked;
        _isEmchecked = _isEmchecked;
        _isOfchecked = _isOfchecked;
        _isMDchecked = _isMDchecked;
        _isMOchecked = _isMOchecked;
        _isOkchecked = _isOkchecked;
        _isEUchecked = _isEUchecked;
        _isBachecked = _isBachecked;
      }
    });
  }
// end of for species alive

// for reasons for death
  void _onDiChanged(bool val) {
    setState(() {
      _isDichecked = val;
      onSelectedReasonForDeaths(val, "Disease");
      print("Val be $val");

      if (val) {
        _isDichecked = _isDichecked;
        _isDrchecked = _isDrchecked;
        _isPechecked = _isPechecked;
        _isVachecked = _isVachecked;
        _isTSchecked = _isTSchecked;
      }
    });
  }

  void _onDrChanged(bool val) {
    setState(() {
      _isDrchecked = val;
      onSelectedReasonForDeaths(val, "Drought");
      print("Val be $val");

      if (val) {
        _isDichecked = _isDichecked;
        _isDrchecked = _isDrchecked;
        _isPechecked = _isPechecked;
        _isVachecked = _isVachecked;
        _isTSchecked = _isTSchecked;
      }
    });
  }

  void _onPeChanged(bool val) {
    setState(() {
      _isPechecked = val;
      onSelectedReasonForDeaths(val, "Pest");
      print("Val be $val");

      if (val) {
        _isDichecked = _isDichecked;
        _isDrchecked = _isDrchecked;
        _isPechecked = _isPechecked;
        _isVachecked = _isVachecked;
        _isTSchecked = _isTSchecked;
      }
    });
  }

  void _onVaChanged(bool val) {
    setState(() {
      _isVachecked = val;
      onSelectedReasonForDeaths(val, "Vandalism");
      print("Val be $val");

      if (val) {
        _isDichecked = _isDichecked;
        _isDrchecked = _isDrchecked;
        _isPechecked = _isPechecked;
        _isVachecked = _isVachecked;
        _isTSchecked = _isTSchecked;
      }
    });
  }

  void _onTSChanged(bool val) {
    setState(() {
      _isTSchecked = val;
      onSelectedReasonForDeaths(val, "Transportation_Shocks");
      print("Val be $val");

      if (val) {
        _isDichecked = _isDichecked;
        _isDrchecked = _isDrchecked;
        _isPechecked = _isPechecked;
        _isVachecked = _isVachecked;
        _isTSchecked = _isTSchecked;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // _speciesAlive = [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: fPrimaryColour,

      // appBar: AppBar(
      //   foregroundColor: fPrimaryWhite,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: fPrimaryColour,
      //   title: Text(
      //     "Seedling Monitoring",
      //     style: TextStyle(color: fPrimaryWhite),
      //   ),
      //   actions: [
      //     PopupMenuButton<String>(
      //       offset: Offset(2.00, 3.00),
      //       color: Colors.black,
      //       onSelected: (String _downChoice) {
      //         if (_downChoice == Constants.home) {
      //           Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => IndexPage(),
      //             ),
      //           );
      //         } else if (_downChoice == Constants.load) {
      //           Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext context) => this.widget));
      //         } else if (_downChoice == Constants.saveskip) {
      //           // regSP?.setBool("farmdetskipped", true);
      //           // if (_speciesAlive.isEmpty) {
      //           //   overlayNotification(
      //           //       'Please select type of establishment', "negative");
      //           // } else {
      //           setSSR5ValuesT();
      //           Navigator.of(context).push(
      //             CupertinoPageRoute(
      //               builder: (BuildContext context) => FarmCordinates(),
      //             ),
      //           );

      //           //   print("Selected types are $_speciesAlive");
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
      //               margin: EdgeInsets.only(right: 0),
      //               child: Text(
      //                 _downChoice,
      //                 style: TextStyle(color: Color(0xFFFFFFFF)),
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
                  offset: Offset(2.00, 3.00),
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
                          builder: (BuildContext context) => IndexPage(),
                        ),
                      );
                    } else if (_downChoice == Constants.load) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => this.widget));
                    } else if (_downChoice == Constants.saveskip) {
                      // regSP?.setBool("farmdetskipped", true);
                      // if (_speciesAlive.isEmpty) {
                      //   overlayNotification(
                      //       'Please select type of establishment', "negative");
                      // } else {
                      setSSR5ValuesT();
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => FarmCordinates(),
                        ),
                      );

                      //   print("Selected types are $_speciesAlive");
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: fDefaultPadding),
                            //   child: Center(
                            //     child: Text(
                            //       "Seedling Survival",
                            //       style: TextStyle(
                            //           fontSize: 20.0,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            Center(child: titleOne("Seedling Survival")),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              color: Color(0xFFFFFFFF),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            formFieldLabel(width: size.width * .9, 
                                                "Total number of seedlings alive at time of survey"),
                                            Container(
                                              // margin: EdgeInsets.only(
                                              // left: 10.0,
                                              // right: 10.0,
                                              // bottom: 8.0),
                                              child: TextFieldWidget(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "Total number of seedlings alive at time of survey",
                                                    labelStyle: TextStyle(
                                                      overflow:
                                                          TextOverflow.clip,
                                                    )),
                                                controller:
                                                    _totalSeedlingsAliveController,
                                                onChanged: (value) {},
                                                validator: (input) {
                                                  if (input!.trim().isEmpty) {
                                                    return 'Please enter total number';
                                                  } else {
                                                    setState(() {
                                                      // farmerfirstName.text = input;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: 14.0,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Species of seedlings alive at the time of survey",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Prekese",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isPrchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onPrChanged(value!);
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Kokrodua/ Afromosia",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isKAchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onKAChanged(value!);
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Dahoma",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isDachecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onDahanged(value!);
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Edinam",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isEdchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onEdChanged(value!);
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Emire",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isEmchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onEmChanged(value!);
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Ofram",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isOfchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onOfChanged(value!);
                                                print("Val be $value");
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Mahogany/ Dubini",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isMDchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onMDChanged(value!);
                                                print("Val be $value");
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Mansonia/ Oprono",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isMOchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onMOChanged(value!);
                                                print("Val be $value");
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Okoro",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isOkchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onOkChanged(value!);
                                                print("Val be $value");
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Efoobodedwo/ Utile",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isEUchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onEUChanged(value!);
                                                print("Val be $value");
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Bako",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isBachecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onBaChanged(value!);
                                                print("Val be $value");
                                              },
                                            ),
                                            // Column(
                                            //   children: [
                                            //     new CheckboxListTile(
                                            //       title: Text(
                                            //         "Others",
                                            //         style: TextStyle(
                                            //           color: Colors.black,
                                            //         ),
                                            //       ),
                                            //       value: _isOchecked,
                                            //       activeColor: fPrimaryColour,
                                            //       onChanged: (bool? value) {
                                            //         _onOChanged(value!);
                                            //       },
                                            //     ),
                                            //     Container(
                                            //       margin: EdgeInsets.only(
                                            //           left: 10.0,
                                            //           right: 10.0,
                                            //           bottom: 8.0),
                                            //       child: TextFieldWidget(
                                            //         readOnly: _isOchecked == true
                                            //             ? false
                                            //             : true,
                                            //         decoration: InputDecoration(
                                            //           hintText: "(Specify)",
                                            //           hintStyle: TextStyle(
                                            //               fontStyle:
                                            //                   FontStyle.italic),
                                            //         ),
                                            //         // controller: _usernameController,
                                            //         validator: (input) => _speciesAlive
                                            //                 .contains("Other")
                                            //             ? input!.trim().isEmpty
                                            //                 ? 'Please specify type of establishment'
                                            //                 : null
                                            //             : null,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: 14.0,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Suspected reason for death of trees",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Disease",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isDichecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onDiChanged(value!);
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
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
                                            new CheckboxListTile(
                                              title: Text(
                                                "Pest",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isPechecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onPeChanged(value!);
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Vandalism",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isVachecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onVaChanged(value!);
                                              },
                                            ),
                                            new CheckboxListTile(
                                              title: Text(
                                                "Transportation shocks",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: _isTSchecked,
                                              activeColor: fPrimaryColour,
                                              onChanged: (bool? value) {
                                                _onTSChanged(value!);
                                                print("Val be $value");
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
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
                                              child: Text(
                                                "Next",
                                                style: TextStyle(
                                                    color: fPrimaryWhite,
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              onPressed: () async {
                                                if (_speciesAlive.isEmpty) {
                                                  overlayNotification(
                                                      'Please select species alive',
                                                      "negative");
                                                } else if (_reasonForDeath
                                                    .isEmpty) {
                                                  overlayNotification(
                                                      'Please select suspected reason for death',
                                                      "negative");
                                                } else if (_formKey
                                                    .currentState!
                                                    .validate()) {
                                                  regSP?.setBool(
                                                      "ssr5_skipped", false);
                                                  setSSR5ValuesT();
                                                  Navigator.of(context).push(
                                                    CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          SeedlingMonitoringSeedlingMapping(
                                                        pickedSeedlingAlive:
                                                            _speciesAlive,
                                                      ),
                                                    ),
                                                  );
                                                  print(
                                                      "Selected types are $_speciesAlive");
                                                }
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
                                              child: Text(
                                                "Skip",
                                                style: TextStyle(
                                                    color: fPrimaryWhite,
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              onPressed: () async {
                                                regSP?.setBool(
                                                    "ssr5_skipped", true);
                                                // if (_speciesAlive.isEmpty) {
                                                //   overlayNotification(
                                                //       'Please select type of establishment',
                                                //       "negative");
                                                // } else {
                                                setSSR5ValuesT();
                                                Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        SeedlingMonitoringSeedlingMapping(
                                                            pickedSeedlingAlive:
                                                                _speciesAlive),
                                                  ),
                                                );

                                                print(
                                                    "Selected types are $_speciesAlive");
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
                            SizedBox(
                              height: 10,
                              child: Divider(
                                color: Colors.transparent,
                              ),
                            ),
                          ],
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
}
