import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/providers/deforestationprovider.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import 'package:provider/provider.dart';

class ViewDeforestationReportDetails extends StatefulWidget {
  static const routeName = '/view_def_report_details';
  final Function()? notifyParent;

  const ViewDeforestationReportDetails({Key? key, this.notifyParent})
      : super(key: key);

  @override
  _DetailDisplayState createState() => _DetailDisplayState();
}

class _DetailDisplayState extends State<ViewDeforestationReportDetails> {
  final _formKey = GlobalKey<FormState>();
  bool buildC = false;

  // Future<bool> reload() {
  //   if (buildC == !buildC)
  //     setState(() {
  //       buildC = !buildC;
  //     });

  //   throw ("here wrong");
  // }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace =
        Provider.of<DeforestationProvider>(context, listen: false)
            .findById(id.toString());

    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
        backgroundColor: fPrimaryColour,
        title: Text("Report Details",
          style: TextStyle(color: fPrimaryWhite),),
        actions: [
          Tooltip(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: InkWell(
                child: Icon(Icons.home, color: fPrimaryWhite),
                onTap: () => Navigator.of(context).push(
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
        child: FutureBuilder(
            // future: reload(),
            future: null,
            builder: (context, snapshot) {
              return Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.all(0.0),
                child: ListView(children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 20.0),
                              child: Column(
                                children: [
                                  Image.memory(
                                      base64Decode(selectedPlace.image)),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Date of report",
                                    controller: TextEditingController(
                                        text: selectedPlace.timeDisplay),
                                    readonly: true,
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Community",
                                    controller: TextEditingController(
                                        text: selectedPlace.community),
                                    readonly: true,
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText:
                                        "Were you directed to the place by Global Forest Watch (GFW)?",
                                    controller: TextEditingController(
                                        text: selectedPlace.gfwDirected),
                                    readonly: true,
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Do you see deforestation?",
                                    controller: TextEditingController(
                                        text: selectedPlace.seeDeforestation),
                                    readonly: true,
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText:
                                        "If yes, what is the cause of deforestation?",
                                    controller: TextEditingController(
                                        text: selectedPlace.deforestationCause
                                            .replaceAll("[", "")
                                            .replaceAll("]", "")),
                                    readonly: true,
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText:
                                        "Do you think futher action should be taken?",
                                    controller: TextEditingController(
                                        text: selectedPlace.takeAction),
                                    readonly: true,
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Reason for action",
                                    controller: TextEditingController(
                                        text: selectedPlace.actionReason),
                                    readonly: true,
                                    // suffixIconData: Icons.edit,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            }),
      ),
    );
  }
}
