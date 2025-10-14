import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/screens/farmregistration/farmdetails/components/c3treedetail.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import '../../../main.dart';
import 'components/c2treedetail.dart';

class Tree extends StatefulWidget {
  @override
  _TreeState createState() => _TreeState();
}

class _TreeState extends State<Tree> {
  List<String> _establishmentType = [];
  void getETValues() {
    _establishmentType = (regSP?.getStringList("est") ?? "") as List<String>;

    print(
        "Establishment $_establishmentType and type ${_establishmentType.runtimeType}");
  }

  @override
  void initState() {
    super.initState();
    getETValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
        automaticallyImplyLeading: false,
        backgroundColor: fPrimaryColour,
        title: Text(
          "Tree Information",
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
      body: Container(
          // height: size.height,
          margin: EdgeInsets.all(0.0),
          child: _establishmentType.contains("Woodlot")
              ? C2TreeInformation(pageTitle: _establishmentType.toString())
              : _establishmentType.contains("Commercial_Plantation")
                  ? C2TreeInformation(pageTitle: _establishmentType.toString())
                  : _establishmentType.contains("Other")
                      ? C2TreeInformation(
                          pageTitle: _establishmentType.toString())
                      : C3TreeInformation(
                          pageTitle: _establishmentType.toString(),
                        )),
    );
  }
}
