import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/main.dart';

class FarmerDate extends StatefulWidget {
  const FarmerDate({Key? key}) : super(key: key);

  @override
  _FarmerDateState createState() => _FarmerDateState();
}

class _FarmerDateState extends State<FarmerDate> {
  String? _farmerdOB;
  String? initFarmerValue = "Select your Birth Date";
  bool isFarmerDateSelected = false;
  DateTime? farmerBirthDate;
  String? farmerBirthDateInString;
  bool? hasFarmerBeenClicked;

  var timechecker = DateTime.now().year - 18;

  @override
  void initState() {
    super.initState();
    _farmerdOB = regSP?.getString("fdob");
    farmerBirthDateInString = _farmerdOB;

    if (_farmerdOB!.isNotEmpty) {
      isFarmerDateSelected = true;
    } else {}
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text("Date of Birth"
                    // style:
                    //     TextStyle(fontSize: 17),
                    ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              child: isFarmerDateSelected == true
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
                                farmerBirthDateInString ?? "farmer date",
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
                    minTime: DateTime(1800, 1, 1),
                    maxTime: DateTime(timechecker), onConfirm: (date) {
                  print('confirm $date');
                  isFarmerDateSelected = true;
                  farmerBirthDateInString =
                      '${date.day}/${date.month}/${date.year}';
                  setState(() {
                    regSP?.setString(
                        'farmerDoBR', '${date.year}-${date.month}-${date.day}');
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
