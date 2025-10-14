import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/main.dart';

class KinGender extends StatefulWidget {
  const KinGender({Key? key}) : super(key: key);

  @override
  _KinGenderState createState() => _KinGenderState();
}

class _KinGenderState extends State<KinGender> {
  int? selectedKinRadioGender;
  String? _kinGender;

  @override
  void initState() {
    super.initState();
    _kinGender = regSP?.getString("kgender");

    if (_kinGender == "male") {
      selectedKinRadioGender = 1;
    } else if (_kinGender == "female") {
      selectedKinRadioGender = 2;
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
                child: Text("Gender"),
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
                    group: selectedKinRadioGender,
                    selected: (val) {
                      print(val);
                      // setState(() {
                      changegender(val);
                      // });
                    },
                  ),
                  Text("Male", style: TextStyle(color: Color(0xFFfc1d20))),
                ],
              ),
              Row(
                children: <Widget>[
                  GenderRadioButton(
                    value: 2,
                    group: selectedKinRadioGender,
                    selected: (val) {
                      print(val);
                      // setState(() {
                      changegenderr(val);
                      // });
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

  changegender(vv) {
    setState(() {
      selectedKinRadioGender = vv;
      // _kinGender = "male";
      regSP?.setString('kinGenderR', "male");
    });
  }

  changegenderr(vv) {
    setState(() {
      selectedKinRadioGender = vv;
      // _kinGender = "female";
      regSP?.setString('kinGenderR', "female");
    });
  }
}
