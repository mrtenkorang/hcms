import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/farmdetails.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/alternativeLivelihood/investmentdetails.dart';
import 'package:hcms_revived2/utils/widgets/textFields/generic_text_field.dart';
import 'package:hcms_revived2/utils/widgets/textFormats/text_formats.dart';

class AlternateActivityDetails extends StatefulWidget {
  const AlternateActivityDetails({Key? key}) : super(key: key);

  @override
  _AlternateActivityDetailsState createState() =>
      _AlternateActivityDetailsState();
}

class _AlternateActivityDetailsState extends State<AlternateActivityDetails> {
  final _formKey = GlobalKey<FormState>();

  String? _operationsStartDate;
  String? _additionalActivity;

  bool isVisitDate = false;
  String? visitDateYearInString;

  bool errorMessage = false;

  int? selectedVisitRadio;

  final _trainerorganisation = TextEditingController();

  void setAAValuesT() {
    regSP?.setString('aLtrainerorganisation', _trainerorganisation.text);
    regSP?.setString('aLadditionalActivity', _additionalActivity!);
    regSP?.setString('aLoperationsStartDate', _operationsStartDate!);

    print("done setting");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
        automaticallyImplyLeading: false,
        backgroundColor: fPrimaryColour,
        title: Text(
          "Alternative Livelihood",
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
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Activity Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      "Type of additional livelihood activity",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 1,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        print(val);
                                                        _additionalActivity =
                                                            "Snail_Rearing";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Snail rearing",
                                                    // style: TextStyle(
                                                    //     color: Color(0xFFf9f9f9)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 2,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        _additionalActivity =
                                                            "Vegetable_Farming";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Vegetable farming",
                                                    // style: TextStyle(
                                                    //     color:
                                                    //         Color(0xFFf9f9f9))
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 3,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        _additionalActivity =
                                                            "Food_Processing_And_Value_Addition";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Food processing and value addition",
                                                    // style: TextStyle(
                                                    //     color:
                                                    //         Color(0xFFf9f9f9))
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 4,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        _additionalActivity =
                                                            "Pig_Sty";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Pig sty",
                                                    // style: TextStyle(
                                                    //     color:
                                                    //         Color(0xFFf9f9f9))
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 5,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        _additionalActivity =
                                                            "Bee_Keeping";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Bee keeping",
                                                    // style: TextStyle(
                                                    //     color:
                                                    //         Color(0xFFf9f9f9))
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GenderRadioButton(
                                                    value: 6,
                                                    group: selectedVisitRadio,
                                                    selected: (val) {
                                                      print(val);
                                                      setState(() {
                                                        selectedVisitRadio =
                                                            val;
                                                        _additionalActivity =
                                                            "Soap_Making";
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Soap making",
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
                                    formFieldLabel(width: size.width * .9, "Trainer organisation"),
                                    TextFieldWidget(
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          labelText: "Trainer organisation"),
                                      controller: _trainerorganisation,
                                      validator: (input) =>
                                          input!.trim().isEmpty
                                              ? 'Please fill this space'
                                              : null,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Text(
                                                  "Date livelihood operations started",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black54),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  child: isVisitDate == true
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Icon(
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
                                                                  child: Text(
                                                                    visitDateYearInString ??
                                                                        "visit date",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFFf9f9f9),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : Row(
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
                                                        theme: DatePickerTheme(
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
                                                        minTime: DateTime(1800),
                                                        maxTime: DateTime.now(),
                                                        onConfirm: (date) {
                                                      print('confirm $date');
                                                      isVisitDate = true;
                                                      visitDateYearInString =
                                                          '${date.year}-${date.month}-${date.day}';
                                                      setState(() {
                                                        _operationsStartDate =
                                                            '${date.year}-${date.month}-${date.day}';
                                                        print(
                                                            "DOOB ${date.year}-${date.month}-${date.day}");
                                                      });
                                                    },
                                                        // currentTime: DateTime.now(),
                                                        locale: LocaleType.en);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10.0,
                                              backgroundColor: fPrimaryColour,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              textStyle: const TextStyle(
                                                  color: fPrimaryWhite),
                                              // shadowColor: fPrimaryColour,
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
                                              if (_additionalActivity == null) {
                                                overlayNotification(
                                                    'Please select an activity',
                                                    "negative");
                                              } else if (_operationsStartDate ==
                                                  null) {
                                                overlayNotification(
                                                    'Please select date',
                                                    "negative");
                                              } else if (_formKey.currentState!
                                                  .validate()) {
                                                setAAValuesT();
                                                // regSP.setBool(
                                                //     "farmerskipped", false);
                                                Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        InvestmentDetails(),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
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
                // Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
