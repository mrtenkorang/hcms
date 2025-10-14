import 'package:hcms_revived2/screens/seedlingmonitoring/3plantation_planted_details.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmcordinates.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import '../../../main.dart';

class SeedlingMonitoringPlantingDetails extends StatefulWidget {
  @override
  _SeedlingMonitoringPlantingDetailsState createState() =>
      _SeedlingMonitoringPlantingDetailsState();
}

class _SeedlingMonitoringPlantingDetailsState
    extends State<SeedlingMonitoringPlantingDetails> {
  final _formKey = GlobalKey<FormState>();

  final _totalSizeAcres = TextEditingController();
  String? _typeOfPlantation;
  int? selectedPlantationType;

  List<String> _speciesProvidedPlanted = [];

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

  void setSSF2ValuesT() {
    regSP?.setString("ssr_typeOfPlantation", _typeOfPlantation ?? "");
    regSP?.setString("ssr_totalSizeAcres", _totalSizeAcres.text);
    regSP?.setStringList("ssr_speciesProvidedPlanted", _speciesProvidedPlanted);

    print("Tree Information values gotten!");
  }

  onSelectedRow(bool selected, String selectedEst) async {
    setState(() {
      if (selected) {
        _speciesProvidedPlanted.add(selectedEst);
      } else {
        _speciesProvidedPlanted.remove(selectedEst);
      }
    });
  }

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

  @override
  void initState() {
    super.initState();
    selectedPlantationType = 0;

    _speciesProvidedPlanted = [];
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
      //         } else if (_downChoice == Constants.saveskip) {
      //           regSP?.setBool("farmdetskipped", true);
      //           if (_speciesProvidedPlanted.isEmpty) {
      //             overlayNotification(
      //                 'Please select type of establishment', "negative");
      //           } else {
      //             setSSF2ValuesT();
      //             Navigator.of(context).push(
      //               CupertinoPageRoute(
      //                 builder: (BuildContext context) => FarmCordinates(),
      //               ),
      //             );

      //             print("Selected types are $_speciesProvidedPlanted");
      //           }
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
                  icon: Icon(
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
                    } else if (_downChoice == Constants.saveskip) {
                      regSP?.setBool("farmdetskipped", true);
                      if (_speciesProvidedPlanted.isEmpty) {
                        overlayNotification(
                            'Please select type of establishment', "negative");
                      } else {
                        setSSF2ValuesT();
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (BuildContext context) => FarmCordinates(),
                          ),
                        );

                        print("Selected types are $_speciesProvidedPlanted");
                      }
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
                margin: const EdgeInsets.all(0.0),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: fDefaultPadding),
                            //   child: Center(
                            //     child: Text(
                            //       "Plantation and Planting Details",
                            //       style: TextStyle(
                            //           fontSize: 20.0, fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            titleOne("Plantation and Planting Details"),
                            Container(
                              // margin: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // Row(
                                  //   children: <Widget>[
                                  //     Padding(
                                  //       padding: const EdgeInsets.all(0.0),
                                  //       child: Text(
                                  //         "Type of plantation",
                                  //         style: TextStyle(
                                  //           fontSize: 17,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  formFieldLabel(width: size.width * .9, "Type of plantation"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 1,
                                            group: selectedPlantationType,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                selectedPlantationType = val;
                                                print(val);
                                                _typeOfPlantation =
                                                    "cocoa_farm";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Cocoa farm",
                                            // style: TextStyle(
                                            //     color: Color(0xFFf9f9f9)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 2,
                                            group: selectedPlantationType,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                selectedPlantationType = val;
                                                _typeOfPlantation = "woodlot";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Woodlot",
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
                                            group: selectedPlantationType,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                selectedPlantationType = val;
                                                _typeOfPlantation =
                                                    "degraded_area";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Degraded area (off-farm)",
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
                                            group: selectedPlantationType,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                selectedPlantationType = val;
                                                _typeOfPlantation = "riparian";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Riparian",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          GenderRadioButton(
                                            value: 5,
                                            group: selectedPlantationType,
                                            selected: (val) {
                                              print(val);
                                              setState(() {
                                                selectedPlantationType = val;
                                                _typeOfPlantation = "others";
                                              });
                                            },
                                          ),
                                          const Text(
                                            "Others",
                                            // style: TextStyle(
                                            //     color:
                                            //         Color(0xFFf9f9f9))
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 8.0),
                                        child: TextFieldWidget(
                                          readonly:
                                              _typeOfPlantation == "others"
                                                  ? false
                                                  : true,
                                          decoration: const InputDecoration(
                                            hintText: "(Specify other)",
                                            hintStyle: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                          labelText: "(Specify other)",
                                          controller: TextEditingController(),
                                          validator: (input) =>
                                              _speciesProvidedPlanted
                                                      .contains("Other")
                                                  ? input!.trim().isEmpty
                                                      ? 'Please specify type of plantation'
                                                      : null
                                                  : null,
                                        ),
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
                            formFieldLabel(width: size.width * .9, "Total size in acres"),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: .0, right: .0),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, bottom: 8.0),
                                child: TextFieldWidget(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: "Total size in acres"),
                                  controller: _totalSizeAcres,
                                  onChanged: (value) {},
                                  validator: (input) {
                                    if (input!.trim().isEmpty) {
                                      return 'Please enter total size';
                                    } else {
                                      setState(() {
                                        // farmerfirstName.text = input;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                              child: Divider(
                                color: Colors.transparent,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              // color: const Color(0xFFFFFFFF),
                              decoration: const BoxDecoration(
                                color: primaryWhite,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  formFieldLabel(width: size.width * .9, 
                                      "Species type provided and planted"),
                                  CheckboxListTile(
                                    // contentPadding:
                                    //     const EdgeInsets.symmetric(
                                    //         horizontal: 8),
                                    // title: Text(
                                    //   "Prekese",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Prekese"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isPrchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onPrChanged(value!);
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Kokrodua/ Afromosia",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title:
                                        formFieldLabel(width: size.width * .9, "Kokrodua/ Afromosia"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isKAchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onKAChanged(value!);
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Dahoma",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Dahoma"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isDachecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onDahanged(value!);
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Edinam",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Edinam"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isEdchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onEdChanged(value!);
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Emire",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Emire"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isEmchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onEmChanged(value!);
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Ofram",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Ofram"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isOfchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onOfChanged(value!);
                                      print("Val be $value");
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Mahogany/ Dubini",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Mahogany/ Dubini"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isMDchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onMDChanged(value!);
                                      // print("Val be $value");
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Mansonia/ Oprono",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Mansonia/ Oprono"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isMOchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onMOChanged(value!);
                                      // print("Val be $value");
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Okoro",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Okoro"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isOkchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onOkChanged(value!);
                                      // print("Val be $value");
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Efoobodedwo/ Utile",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Efoobodedwo/ Utile"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isEUchecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onEUChanged(value!);
                                      // print("Val be $value");
                                    },
                                  ),
                                  CheckboxListTile(
                                    // title: Text(
                                    //   "Bako",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    title: formFieldLabel(width: size.width * .9, "Bako"),
                                    selectedTileColor: secondaryColour2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    value: _isBachecked,
                                    activeColor: fPrimaryColour,
                                    onChanged: (bool? value) {
                                      _onBaChanged(value!);
                                      // print("Val be $value");
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                                fontWeight: FontWeight.normal),
                                          ),
                                          onPressed: () async {
                                            if (_speciesProvidedPlanted
                                                .isEmpty) {
                                              overlayNotification(
                                                  'Please select species type',
                                                  "negative");
                                            } else if (_typeOfPlantation ==
                                                null) {
                                              overlayNotification(
                                                  'Please select type of plantation',
                                                  "negative");
                                            } else if (_formKey.currentState!
                                                .validate()) {
                                              regSP?.setBool(
                                                  "ssr2_skipped", false);
                                              setSSF2ValuesT();
                                              Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      SeedlingMonitoringPlantedDetails(
                                                    selectedSpeciesPlanted:
                                                        _speciesProvidedPlanted,
                                                  ),
                                                ),
                                              );
                                              print(
                                                  "Selected types are $_speciesProvidedPlanted");
                                            }
                                          },
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                                fontWeight: FontWeight.normal),
                                          ),
                                          onPressed: () async {
                                            regSP?.setBool(
                                                "ssr2_skipped", true);
                                            // if (_speciesProvidedPlanted.isEmpty) {
                                            //   overlayNotification(
                                            //       'Please select type of establishment',
                                            //       "negative");
                                            // } else {
                                            setSSF2ValuesT();
                                            Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    SeedlingMonitoringPlantedDetails(
                                                  selectedSpeciesPlanted:
                                                      _speciesProvidedPlanted,
                                                ),
                                              ),
                                            );

                                            print(
                                                "Selected types are $_speciesProvidedPlanted");
                                            // }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
