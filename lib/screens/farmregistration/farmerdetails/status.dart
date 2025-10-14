import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/components/existingusercheck.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/farmerdetails.dart';
import 'package:hcms_revived2/screens/farmregistration/farmerdetails/groupdetails.dart';

import '../../../main.dart';

class BeneficiaryStatus extends StatelessWidget {
  static String? _beneficiaryType;

  void setBTValuesT() {
    regSP?.setString('_beneficiaryType', _beneficiaryType!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "Please select what best describes you: ".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                // height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      // width: MediaQuery.of(context).size.width / 3,
                      height: 50.00,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: fPrimaryColour,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          textStyle: const TextStyle(color: Colors.white),
                          // shadowColor: fPrimaryColour,
                          side: const BorderSide(
                              width: 1.0, color: fPrimaryColour),
                        ),
                        child: Text(
                          "Farmer / Developer / Individual",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.normal, color: Colors.white),
                        ),
                        onPressed: () async {
                          _beneficiaryType = "Individual";
                          setBTValuesT();
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  ExistingUserCheck(
                                beneficiaryType: _beneficiaryType,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width / 3,
                      height: 50.00,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10.0,
                          backgroundColor: Color(0xFFffffff),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          textStyle: const TextStyle(color: fPrimaryColour),
                          // shadowColor: fPrimaryColour,
                        ),
                        child: Text(
                          "Group / Company",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.normal,
                              color: fPrimaryColour),
                        ),
                        onPressed: () async {
                          _beneficiaryType = "Group";
                          setBTValuesT();
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  ExistingUserCheck(
                                beneficiaryType: _beneficiaryType,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
