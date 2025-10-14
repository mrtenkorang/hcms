import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/main.dart';

class KinDate extends StatefulWidget {
  const KinDate({Key? key}) : super(key: key);

  @override
  _KinDateState createState() => _KinDateState();
}

class _KinDateState extends State<KinDate> {
  String? _kindOB;
  String initKinValue = "Select your Birth Date";
  bool isKinDateSelected = false;
  DateTime? kinBirthDate;
  String? kinBirthDateInString;
  bool hasKinBeenClicked = false;

  @override
  void initState() {
    super.initState();
    _kindOB = regSP?.getString("kdob");
    kinBirthDateInString = _kindOB;

    if (_kindOB!.isNotEmpty) {
      isKinDateSelected = true;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              // new Icon(
              //   Icons.calendar_today,
              //   size: 18,
              //   // color: Color(0xFFfbfbf3),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text("Date of Birth"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              child: isKinDateSelected == true
                  ? Container(
                      decoration: BoxDecoration(
                        color: fPrimaryColour,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 40.0,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_drop_down_circle,
                              size: 22,
                              color: Color(0xFFffe423),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                kinBirthDateInString ?? "kin date",
                                style: TextStyle(
                                  color: Color(0xFFf9f9f9),
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
                    theme: DatePickerTheme(
                      backgroundColor: fPrimaryColour,
                      itemStyle: TextStyle(color: Color(0xFFf9f9f9)),
                      cancelStyle: TextStyle(color: Color(0xFFffe423)),
                      doneStyle: TextStyle(color: Color(0xFFf9f9f9)),
                      containerHeight: 210.0,
                    ),
                    showTitleActions: true,
                    minTime: DateTime(1800, 01, 01),
                    maxTime: DateTime.now(), onConfirm: (date) {
                  print('confirm $date');
                  isKinDateSelected = true;
                  kinBirthDateInString =
                      '${date.day}/${date.month}/${date.year}';
                  setState(() {
                    regSP?.setString(
                        'kinDoBR', '${date.year}-${date.month}-${date.day}');
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
    );
  }
}
