import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/methods.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import '../../../../main.dart';

class PersonalDetails extends StatefulWidget {
  final String retfamerProfilePic;
  final String? retfarmerfirstName;
  final String? retfarmersurName;
  final String? retfarmerotherName;
  final String? retfarmerGender;
  final String? retfarmerDoB;
  final String? retfarmerPostal;
  final String? retfarmerPhoneNum;
  final String? retfarmerMail;
  final String? retkinName;
  final String? retkinPhoneNum;
  final String? retkinGender;
  final String? retkinPostal;
  final String? retkinDoB;
  final String? retkinRelationship;

  const PersonalDetails({
    Key? key,
    this.retfamerProfilePic = "",
    this.retfarmerfirstName,
    this.retfarmersurName,
    this.retfarmerotherName,
    this.retfarmerGender,
    this.retfarmerDoB,
    this.retfarmerPostal,
    this.retfarmerPhoneNum,
    this.retfarmerMail,
    this.retkinName,
    this.retkinPhoneNum,
    this.retkinGender,
    this.retkinPostal,
    this.retkinDoB,
    this.retkinRelationship,
  }) : super(key: key);

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  String _base64Image = "";
  final farmerRegNum = TextEditingController();
  final farmerfirstName = TextEditingController();
  final farmerotherName = TextEditingController();
  final farmersurName = TextEditingController();
  final farmerGender = TextEditingController();
  final farmerPhoneNum = TextEditingController();
  final farmerDoB = TextEditingController();
  final farmerMail = TextEditingController();
  final farmerPostal = TextEditingController();
  final kinName = TextEditingController();
  final kinRelationship = TextEditingController();
  final kinDoB = TextEditingController();
  final kinGender = TextEditingController();
  final kinPhoneNum = TextEditingController();
  final kinPostal = TextEditingController();
  String? _farmerdOB;
  String? _kindOB;
  String? _farmerGender;
  String? _kinGender;
  String _farmerDateError = '';
  String _kinDateError = '';

  String initFarmerValue = "Select your Birth Date";
  bool isFarmerDateSelected = false;
  DateTime? farmerBirthDate;
  String? farmerBirthDateInString;
  bool hasFarmerBeenClicked = false;

  String initKinValue = "Select your Birth Date";
  bool isKinDateSelected = false;
  DateTime? kinBirthDate;
  String? kinBirthDateInString;
  bool hasKinBeenClicked = false;

  var timechecker = DateTime.now().year - 18;

  bool errorMessage = false;

  int? selectedFarmerRadioGender;
  int? selectedKinRadioGender;

  void getbase64Img() async {
    _base64Image = await regSP?.getString('base64Image') ?? "";
  }

  Future setFPValuesT() async {
    getbase64Img();
    await regSP?.setString('_beneficiaryType', "Individual");
    await regSP?.setString('farmerRegNum', farmerRegNum.text);
    await regSP?.setString('farmerfirstName', farmerfirstName.text);
    await regSP?.setString('farmerotherName', farmerotherName.text);
    await regSP?.setString('farmersurName', farmersurName.text);
    await regSP?.setString(
        'farmerGender',
        _farmerGender == "male"
            ? 'male'
            : _farmerGender == "female"
                ? 'female'
                : '');
    await regSP?.setString('farmerPhoneNum', farmerPhoneNum.text);
    await regSP?.setString('farmerDoB', _farmerdOB ?? "");
    await regSP?.setString('farmerMail', farmerMail.text);
    await regSP?.setString('farmerPostal', farmerPostal.text);
    await regSP?.setString('kinName', kinName.text);
    await regSP?.setString('kinRelationship', kinRelationship.text);
    await regSP?.setString('kinDoB', _kindOB ?? "");
    await regSP?.setString(
        'kinGender',
        _kinGender == "male"
            ? 'male'
            : _kinGender == "female"
                ? 'female'
                : '');
    await regSP?.setString('kinPhoneNum', kinPhoneNum.text);
    await regSP?.setString('kinPostal', kinPostal.text);
    await regSP?.setString('farmerPic', _base64Image);

    print("base64 $_base64Image");

    print("done setting");
  }

  // authenticatingLoader() {
  //   showDialog(
  //       barrierColor: Colors.white38,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           child: Center(
  //             child: SpinKitChasingDots(
  //               color: Colors.orange,
  //               size: 80.0,
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  void initState() {
    super.initState();
    selectedFarmerRadioGender = 0;
    selectedKinRadioGender = 0;

    if (widget.retfarmerGender == "male") {
      selectedFarmerRadioGender = 1;
      _farmerGender = "male";
    } else if (widget.retfarmerGender == "female") {
      selectedFarmerRadioGender = 2;
      _farmerGender = "female";
    } else {
      return;
    }

    if (widget.retkinGender == "male") {
      selectedKinRadioGender = 1;
      _kinGender = "male";
    } else if (widget.retkinGender == "female") {
      selectedKinRadioGender = 2;
      _kinGender = "female";
    } else {
      return;
    }

    farmerBirthDateInString = widget.retfarmerDoB;
    _farmerdOB = widget.retfarmerDoB;

    if (widget.retfarmerDoB!.isNotEmpty) {
      isFarmerDateSelected = true;
    }

    kinBirthDateInString = widget.retkinDoB;
    _kindOB = widget.retkinDoB;

    if (widget.retkinDoB!.isNotEmpty) {
      isKinDateSelected = true;
    }

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

  // Tooltip(
  //   message: "Takes you back to homepage",
  //   child: Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //     child: InkWell(
  //       child: const Icon(Icons.home, color: fPrimaryWhite),
  //       onTap: () => Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (BuildContext context) => const IndexPage(),
  //         ),
  //       ),
  //     ),
  //   ),
  // )

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          widget.retfamerProfilePic == "seen"
                              ? const SizedBox()
                              : ProfileImageInput(_selectedImage,
                                  alreadyPic: ""),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     Text(
                                        //       "Beneficiary Details",
                                        //       style: TextStyle(
                                        //           fontWeight: FontWeight.bold,
                                        //           fontSize: 24.0),
                                        //     ),
                                        //   ],
                                        // ),
                                        titleOne("Beneficiary Details"),
                                        // Container(
                                        //   decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(10.0)),
                                        //   child: TextFieldWidget(
                                        //     labelText: "",
                                        //     filled: false,
                                        //     onSubmitted: () {},
                                        //     keyboardType: TextInputType.name,
                                        //     labelStyle: const TextStyle(),
                                        //     controller: widget
                                        //             .retfarmerfirstName!
                                        //             .isNotEmpty
                                        //         ? TextEditingController(
                                        //             text: widget
                                        //                 .retfarmerfirstName)
                                        //         : farmerfirstName,
                                        //     readonly: false,
                                        //     obscuretext: false,
                                        //     onSuffixButtonClicked: () {},
                                        //     onChanged: (p) {},
                                        //     validator: (input) {
                                        //       if (input!.trim().isEmpty) {
                                        //         return 'Please enter your first name';
                                        //       } else {
                                        //         setState(() {
                                        //           farmerfirstName.text = input;
                                        //         });
                                        //       }
                                        //     },
                                        //     onClicked: () {},
                                        //   ),
                                        // ),
                                        formFieldLabel(width: size.width * .9, "Farmer first name"),
                                        TextFieldWidget(
                                          decoration: const InputDecoration(
                                              labelText: "Farmer First Name"),
                                          controller: widget.retfarmerfirstName!
                                                  .isNotEmpty
                                              ? TextEditingController(
                                                  text:
                                                      widget.retfarmerfirstName)
                                              : farmerfirstName,
                                          onChanged: (value) {},
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter your first name';
                                            } else {
                                              setState(() {
                                                farmerfirstName.text = input;
                                              });
                                            }
                                          },
                                        ),
                                        formFieldLabel(width: size.width * .9, "Other names"),
                                        TextFieldWidget(
                                          // decoration: InputDecoration(
                                          //     labelText: "Other Names"),
                                          controller: widget.retfarmerotherName!
                                                  .isNotEmpty
                                              ? TextEditingController(
                                                  text:
                                                      widget.retfarmerotherName)
                                              : farmerotherName,
                                          validator: (input) {
                                            setState(() {
                                              farmerotherName.text = input!;
                                            });

                                            // return input;
                                          },
                                        ),
                                        formFieldLabel(width: size.width * .9, "Surname"),
                                        TextFieldWidget(
                                          decoration: const InputDecoration(
                                              labelText: "Surname Name"),
                                          controller: widget
                                                  .retfarmersurName!.isNotEmpty
                                              ? TextEditingController(
                                                  text: widget.retfarmersurName)
                                              : farmersurName,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter your surname';
                                            } else {
                                              setState(() {
                                                farmersurName.text = input;
                                              });
                                            }
                                          },
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 0.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              const Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    child: Text(
                                                      "Gender",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ButtonBar(
                                                alignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      GenderRadioButton(
                                                        value: 1,
                                                        group:
                                                            selectedFarmerRadioGender,
                                                        selected: (val) {
                                                          print(val);
                                                          setState(() {
                                                            selectedFarmerRadioGender =
                                                                val;
                                                            print(val);
                                                            _farmerGender =
                                                                "male";
                                                          });
                                                        },
                                                      ),
                                                      const Text(
                                                        "Male",
                                                        // style: TextStyle(
                                                        //     color: Color(0xFFf9f9f9)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      GenderRadioButton(
                                                        value: 2,
                                                        group:
                                                            selectedFarmerRadioGender,
                                                        selected: (val) {
                                                          print(val);
                                                          setState(() {
                                                            selectedFarmerRadioGender =
                                                                val;
                                                            _farmerGender =
                                                                "female";
                                                          });
                                                        },
                                                      ),
                                                      const Text(
                                                        "Female",
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
                                        formFieldLabel(width: size.width * .9, "Mobile"),
                                        TextFieldWidget(
                                          keyboardType: TextInputType.phone,
                                          maxLength: 10,
                                          decoration: const InputDecoration(
                                              labelText: "Mobile number"),
                                          controller: widget
                                                  .retfarmerPhoneNum!.isNotEmpty
                                              ? TextEditingController(
                                                  text:
                                                      widget.retfarmerPhoneNum)
                                              : farmerPhoneNum,
                                          validator: (input) {
                                            if (input!.trim().length < 10) {
                                              return 'Number must be up to 10 digits';
                                            } else if (input.length > 10) {
                                              return 'Number is more than 10 digits';
                                            } else {
                                              setState(() {
                                                farmerPhoneNum.text = input;
                                              });
                                            }
                                          },
                                        ),
                                        Container(
                                          // width: MediaQuery.of(context).size.width - 90,

                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              const Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    child: Text(
                                                      "Date of Birth",
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  child:
                                                      isFarmerDateSelected ==
                                                              true
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    fPrimaryColour,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              ),
                                                              height: 40.0,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.5,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    const Icon(
                                                                      Icons
                                                                          .arrow_drop_down_circle,
                                                                      size: 22,
                                                                      color: Color(
                                                                          0xFFffe423),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        farmerBirthDateInString ??
                                                                            "birthdate",
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xFFf9f9f9),
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
                                                                  size: 18,
                                                                  color:
                                                                      fPrimaryColour,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  // size: 34,
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
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
                                                        showTitleActions: true,
                                                        minTime: DateTime(
                                                            1800, 1, 1),
                                                        maxTime: DateTime(
                                                            timechecker),
                                                        onConfirm: (date) {
                                                      if (DateTime.now().year -
                                                              date.year <
                                                          18) {
                                                        overlayNotification(
                                                            'Must be 18 years and above',
                                                            "negative");
                                                      } else {
                                                        print('confirm $date');
                                                        isFarmerDateSelected =
                                                            true;
                                                        farmerBirthDateInString =
                                                            '${date.day}/${date.month}/${date.year}';
                                                        setState(() {
                                                          _farmerdOB =
                                                              '${date.year}-${date.month}-${date.day}';
                                                          print(
                                                              "DOOB $_farmerdOB");
                                                        });
                                                      }
                                                    },
                                                        // currentTime: DateTime.now(),
                                                        locale: LocaleType.en);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // hasFarmerBeenClicked == true
                                        //     ? Text(_farmerDateError,
                                        //         style: TextStyle(color: Colors.red))
                                        //     : SizedBox(),
                                        formFieldLabel(width: size.width * .9, "Email address"),
                                        TextFieldWidget(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                              labelText: "Email Address"),
                                          controller: widget
                                                  .retfarmerMail!.isNotEmpty
                                              ? TextEditingController(
                                                  text: widget.retfarmerMail)
                                              : farmerMail,
                                          validator: (input) {
                                            setState(() {
                                              farmerMail.text = input!;
                                            });
                                            // return input;
                                          },
                                        ),
                                        formFieldLabel(width: size.width * .9, "Postal address"),
                                        TextFieldWidget(
                                          decoration: const InputDecoration(
                                              labelText: "Postal Address"),
                                          controller: widget
                                                  .retfarmerPostal!.isNotEmpty
                                              ? TextEditingController(
                                                  text: widget.retfarmerPostal)
                                              : farmerPostal,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter a postal address';
                                            } else {
                                              setState(() {
                                                farmerPostal.text = input;
                                              });
                                            }
                                            // return input;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 40,
                                          // child: Divider(),
                                        ),
                                        // const Row(
                                        //   children: [
                                        //     Text(
                                        //       "Next of Kin Details",
                                        //       style: TextStyle(
                                        //           fontWeight: FontWeight.bold,
                                        //           fontSize: 24.0),
                                        //     ),
                                        //   ],
                                        // ),
                                        titleOne("Next of Kin Details"),

                                        formFieldLabel(width: size.width * .9, "Next of kin name"),
                                        TextFieldWidget(
                                          decoration: const InputDecoration(
                                              labelText: "Next of Kin"),
                                          controller:
                                              widget.retkinName!.isNotEmpty
                                                  ? TextEditingController(
                                                      text: widget.retkinName)
                                                  : kinName,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'This field cannot be empty';
                                            } else {
                                              setState(() {
                                                kinName.text = input;
                                              });
                                            }
                                            // return input;
                                          },
                                        ),
                                        formFieldLabel(width: size.width * .9, "Relationship"),
                                        TextFieldWidget(
                                          decoration: const InputDecoration(
                                              labelText: "Relationship"),
                                          controller: widget.retkinRelationship!
                                                  .isNotEmpty
                                              ? TextEditingController(
                                                  text:
                                                      widget.retkinRelationship)
                                              : kinRelationship,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'This field cannot be empty';
                                            } else {
                                              setState(() {
                                                kinRelationship.text = input;
                                              });
                                            }
                                            // return input;
                                          },
                                        ),
                                        Container(
                                          // width: MediaQuery.of(context).size.width - 90,

                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              const Row(
                                                children: <Widget>[
                                                  // new Icon(
                                                  //   Icons.calendar_today,
                                                  //   size: 18,
                                                  //   // color: Color(0xFFfbfbf3),
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    child: Text(
                                                      "Date of Birth",
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  child:
                                                      isKinDateSelected == true
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    fPrimaryColour,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                              ),
                                                              height: 40.0,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.5,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    const Icon(
                                                                      Icons
                                                                          .arrow_drop_down_circle,
                                                                      size: 22,
                                                                      color: Color(
                                                                          0xFFffe423),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        kinBirthDateInString ??
                                                                            "birthdate",
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xFFf9f9f9),
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
                                                                  size: 18,
                                                                  color:
                                                                      fPrimaryColour,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  // size: 34,
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
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
                                                        showTitleActions: true,
                                                        minTime: DateTime(
                                                            1800, 01, 01),
                                                        maxTime: DateTime.now(),
                                                        onConfirm: (date) {
                                                      print('confirm $date');
                                                      isKinDateSelected = true;
                                                      kinBirthDateInString =
                                                          '${date.day}/${date.month}/${date.year}';
                                                      setState(() {
                                                        _kindOB =
                                                            '${date.year}-${date.month}-${date.day}';
                                                        print("DOOB $_kindOB");
                                                      });
                                                    },
                                                        // currentTime: DateTime.now(),
                                                        locale: LocaleType.en);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // hasKinBeenClicked == true
                                        //     ? Text(_kinDateError,
                                        //         style:
                                        //             TextStyle(color: Color(0xFFfc1d20)))
                                        //     : SizedBox(),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 0.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              const Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    child: Text(
                                                      "Gender",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ButtonBar(
                                                alignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      GenderRadioButton(
                                                        value: 1,
                                                        group:
                                                            selectedKinRadioGender,
                                                        selected: (val) {
                                                          print(val);
                                                          setState(() {
                                                            selectedKinRadioGender =
                                                                val;
                                                            print(val);
                                                            _kinGender = "male";
                                                          });
                                                        },
                                                      ),
                                                      const Text(
                                                        "Male",
                                                        // style: TextStyle(
                                                        //     color: Color(0xFFf9f9f9)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      GenderRadioButton(
                                                        value: 2,
                                                        group:
                                                            selectedKinRadioGender,
                                                        selected: (val) {
                                                          print(val);
                                                          setState(() {
                                                            selectedKinRadioGender =
                                                                val;
                                                            _kinGender =
                                                                "female";
                                                          });
                                                        },
                                                      ),
                                                      const Text(
                                                        "Female",
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
                                        formFieldLabel(width: size.width * .9, "Phone number"),
                                        TextFieldWidget(
                                          keyboardType: TextInputType.phone,
                                          maxLength: 10,
                                          decoration: const InputDecoration(
                                              labelText: "Phone number"),
                                          controller: widget
                                                  .retkinPhoneNum!.isNotEmpty
                                              ? TextEditingController(
                                                  text: widget.retkinPhoneNum)
                                              : kinPhoneNum,
                                          validator: (input) {
                                            if (input!.trim().length < 10) {
                                              return 'Number must be up to 10 digits';
                                            } else if (input.length > 10) {
                                              return 'Number is more than 10 digits';
                                            } else {
                                              setState(() {
                                                kinPhoneNum.text = input;
                                              });
                                            }

                                            // return input;
                                          },
                                        ),
                                        formFieldLabel(width: size.width * .9, "Postal address"),
                                        TextFieldWidget(
                                          decoration: const InputDecoration(
                                              labelText: "Postal Address"),
                                          controller:
                                              widget.retkinPostal!.isNotEmpty
                                                  ? TextEditingController(
                                                      text: widget.retkinPostal)
                                                  : kinPostal,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter an address';
                                            } else {
                                              setState(() {
                                                kinPostal.text = input;
                                              });
                                            }

                                            // return input;
                                          },
                                        ),
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
                                                  backgroundColor:
                                                      fPrimaryColour,
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
                                                  await setFPValuesT()
                                                      .then((value) {
                                                    debugPrint(
                                                        "Profile base64 $_base64Image");
                                                    if (widget
                                                            .retfamerProfilePic
                                                            .isEmpty &&
                                                        _base64Image.isEmpty) {
                                                      overlayNotification(
                                                          'Please provide an image',
                                                          "negative");
                                                    } else if (_formKey
                                                            .currentState!
                                                            .validate() &&
                                                        farmerBirthDateInString !=
                                                            null &&
                                                        kinBirthDateInString !=
                                                            null) {
                                                      print(
                                                          "Farmer detail ${farmerfirstName.text} and $_farmerdOB and $_kinGender");
                                                      regSP?.setBool(
                                                          "farmerskipped",
                                                          false);
                                                      Navigator.of(context)
                                                          .push(
                                                        CupertinoPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              FarmDetails(),
                                                        ),
                                                      );
                                                    } else if (farmerBirthDateInString ==
                                                        null) {
                                                      overlayNotification(
                                                          'Farmer Date of birth not selected',
                                                          "negative");
                                                    } else if (kinBirthDateInString ==
                                                        null) {
                                                      overlayNotification(
                                                          'Kin Date of birth not selected',
                                                          "negative");
                                                    } else if (_farmerGender !=
                                                            "male" &&
                                                        _farmerGender !=
                                                            "female") {
                                                      overlayNotification(
                                                          'Farmer gender not selected',
                                                          "negative");
                                                    } else if (_kinGender !=
                                                            "male" &&
                                                        _kinGender !=
                                                            "female") {
                                                      overlayNotification(
                                                          'Kin gender not selected',
                                                          "negative");
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                            // Container(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width /
                                            //       3,
                                            //   height: 50.00,
                                            //   child: RaisedButton(
                                            //     elevation: 0,
                                            //     shape: RoundedRectangleBorder(
                                            //       borderRadius:
                                            //           BorderRadius.circular(
                                            //               10.0),
                                            //     ),
                                            //     child: Text(
                                            //       "Skip",
                                            //       style: TextStyle(
                                            //           fontSize: 17.0,
                                            //           fontWeight:
                                            //               FontWeight.normal),
                                            //     ),
                                            //     color: fPrimaryColour,
                                            //     textColor: Colors.white,
                                            //     onPressed: () async {
                                            //       setFPValuesT();
                                            //       regSP?.setBool(
                                            //           "farmerskipped", true);
                                            //       Navigator.of(context).push(
                                            //         CupertinoPageRoute(
                                            //           builder: (BuildContext
                                            //                   context) =>
                                            //               FarmDetails(),
                                            //         ),
                                            //       );
                                            //     },
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
          ],
        ),
      ),
    );
  }
}
