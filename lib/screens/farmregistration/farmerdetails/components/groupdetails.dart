import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
// import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkit;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

import '../../../../main.dart';

class GroupDetails extends StatefulWidget {
  final String? retcompanyDirectors;
  final String? retgroupName;
  final String? retgroupPresident;
  final String? retgroupSecretary;
  final String? retgroupPhone;
  final String? retgroupregNumb;
  final String? retgroupEmail;
  final String? retgroupAddress;

  const GroupDetails(
      {Key? key,
      this.retcompanyDirectors,
      this.retgroupName,
      this.retgroupPresident,
      this.retgroupSecretary,
      this.retgroupPhone,
      this.retgroupregNumb,
      this.retgroupEmail,
      this.retgroupAddress})
      : super(key: key);
  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  final _formKey = GlobalKey<FormState>();

  final _companyDirectors = TextEditingController();
  final _groupName = TextEditingController();
  final _groupPresident = TextEditingController();
  final _groupSecretary = TextEditingController();
  final _groupPhone = TextEditingController();
  final _groupregNumb = TextEditingController();
  final _groupEmail = TextEditingController();
  final _groupAddress = TextEditingController();
  bool errorMessage = false;

  void setGDValuesT() {
    regSP?.setString('_beneficiaryType', "Group");
    regSP?.setString('companyDirectors', _companyDirectors.text);
    regSP?.setString('groupName', _groupName.text);
    regSP?.setString('groupPresident', _groupPresident.text);
    regSP?.setString('groupSecretary', _groupSecretary.text);
    regSP?.setString('groupPhone', _groupPhone.text);
    regSP?.setString('groupregNumb', _groupregNumb.text);
    regSP?.setString('groupEmail', _groupEmail.text);
    regSP?.setString('groupAddress', _groupAddress.text);

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

  String selectedFarmerType = "individual";

  @override
  void initState() {
    super.initState();
    // regSP?.clear();

    selectedFarmerType = regSP?.getString("_beneficiaryType") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding:  EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: size.height ,
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
                    Expanded(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Form(
                            key: _formKey,
                            child: Material(
                              elevation: 0,
                              color: primaryWhite,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                child: Container(
                                  height: size.height * .80,
                                  color: primaryWhite,
                                  child: ListView(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: [
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     Text(
                                      //       "Group/ Company Details",
                                      //       style: TextStyle(
                                      //           fontWeight: FontWeight.bold,
                                      //           fontSize: 24.0),
                                      //     ),
                                      //   ],
                                      // ),
                                      formFieldLabel(width: size.width * .9, "Group/ Company Details"),
                                      TextFieldWidget(
                                        keyboardType: TextInputType.text,
                                        decoration:
                                            const InputDecoration(labelText: ""),
                                        controller: widget.retgroupName!.isNotEmpty
                                            ? TextEditingController(
                                                text: widget.retgroupName)
                                            : _groupName,
                                        validator: (input) {
                                          if (input!.trim().isEmpty) {
                                            return 'Please enter company/group name';
                                          } else {
                                            setState(() {
                                              _groupName.text = input;
                                            });
                                          }
                                        },
                                      ),
                                      formFieldLabel(width: size.width * .9, "Group President"),
                                      TextFieldWidget(
                                          keyboardType: TextInputType.text,
                                          decoration:
                                              const InputDecoration(labelText: ""),
                                          controller: widget
                                                  .retgroupPresident!.isNotEmpty
                                              ? TextEditingController(
                                                  text: widget.retgroupPresident)
                                              : _groupPresident,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter a name';
                                            } else {
                                              setState(() {
                                                _groupPresident.text = input;
                                              });
                                            }
                                          }),
                                      formFieldLabel(width: size.width * .9, "Group Secretary"),
                                      TextFieldWidget(
                                          keyboardType: TextInputType.text,
                                          decoration:
                                              const InputDecoration(labelText: ""),
                                          controller: widget
                                                  .retgroupSecretary!.isNotEmpty
                                              ? TextEditingController(
                                                  text: widget.retgroupSecretary)
                                              : _groupSecretary,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter a name';
                                            } else {
                                              setState(() {
                                                _groupSecretary.text = input;
                                              });
                                            }
                                          }),
                                      formFieldLabel(width: size.width * .9, "Company directors"),
                                      TextFieldWidget(
                                          keyboardType: TextInputType.text,
                                          decoration:
                                              const InputDecoration(labelText: ""),
                                          controller: widget
                                                  .retcompanyDirectors!.isNotEmpty
                                              ? TextEditingController(
                                                  text: widget.retcompanyDirectors)
                                              : _companyDirectors,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter a name';
                                            } else {
                                              setState(() {
                                                _companyDirectors.text = input;
                                              });
                                            }
                                          }),
                                      formFieldLabel(width: size.width * .9, "Mobile number"),
                                      TextFieldWidget(
                                          keyboardType: TextInputType.phone,
                                          maxLength: 10,
                                          decoration:
                                              const InputDecoration(labelText: ""),
                                          controller:
                                              widget.retgroupPhone!.isNotEmpty
                                                  ? TextEditingController(
                                                      text: widget.retgroupPhone)
                                                  : _groupPhone,
                                          validator: (input) {
                                            if (input!.trim().length < 10) {
                                              return 'Number must be up to 10 digits';
                                            } else if (input.length > 10) {
                                              return 'Number is more than 10 digits';
                                            } else {
                                              setState(() {
                                                _groupPhone.text = input;
                                              });
                                            }
                                          }),
                                      formFieldLabel(width: size.width * .9, "Email Address"),
                                      TextFieldWidget(
                                          keyboardType: TextInputType.emailAddress,
                                          decoration:
                                              const InputDecoration(labelText: ""),
                                          controller:
                                              widget.retgroupEmail!.isNotEmpty
                                                  ? TextEditingController(
                                                      text: widget.retgroupEmail)
                                                  : _groupEmail,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter an email address';
                                            } else {
                                              setState(() {
                                                _groupEmail.text = input;
                                              });
                                            }
                                          }),
                                      formFieldLabel(width: size.width * .9, "Postal Address"),
                                      TextFieldWidget(
                                          keyboardType: TextInputType.text,
                                          decoration:
                                              const InputDecoration(labelText: ""),
                                          controller:
                                              widget.retgroupAddress!.isNotEmpty
                                                  ? TextEditingController(
                                                      text: widget.retgroupAddress)
                                                  : _groupAddress,
                                          validator: (input) {
                                            if (input!.trim().isEmpty) {
                                              return 'Please enter an address';
                                            } else {
                                              setState(() {
                                                _groupAddress.text = input;
                                              });
                                            }
                                          }),
                                      const SizedBox(height: 30.0),
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
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setGDValuesT();
                                                  regSP?.setBool(
                                                      "farmerskipped", false);
                                                  Navigator.of(context).push(
                                                    CupertinoPageRoute(
                                                      builder:
                                                          (BuildContext context) =>
                                                              FarmDetails(),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.height * .06),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(),
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
