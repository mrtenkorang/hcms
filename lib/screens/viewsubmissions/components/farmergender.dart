import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';

class FarmerGender extends StatefulWidget {
  const FarmerGender({Key? key}) : super(key: key);

  @override
  _FarmerGenderState createState() => _FarmerGenderState();
}

class _FarmerGenderState extends State<FarmerGender> {
  int? selectedFarmerRadioGender;
  String? _farmerGender;

  @override
  void initState() {
    super.initState();
    _farmerGender = regSP?.getString("fgender");

    if (_farmerGender == "male") {
      selectedFarmerRadioGender = 1;
    } else if (_farmerGender == "female") {
      selectedFarmerRadioGender = 2;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Gender",
                  style: TextStyle(
                      // fontSize: 17,
                      ),
                ),
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
                    group: selectedFarmerRadioGender,
                    selected: (val) {
                      print(val);
                      setState(() {
                        selectedFarmerRadioGender = val;
                        print(val);
                        regSP?.setString('farmerGenderR', "male");
                      });
                    },
                  ),
                  Text("Male", style: TextStyle(color: Color(0xFFfc1d20))),
                ],
              ),
              Row(
                children: <Widget>[
                  GenderRadioButton(
                    value: 2,
                    group: selectedFarmerRadioGender,
                    selected: (val) {
                      print(val);
                      setState(() {
                        selectedFarmerRadioGender = val;
                        regSP?.setString('farmerGenderR', "female");
                      });
                    },
                  ),
                  Text("Female", style: TextStyle(color: Color(0xFFfc1d20))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
