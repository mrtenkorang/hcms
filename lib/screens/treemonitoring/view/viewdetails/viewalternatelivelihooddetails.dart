import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import 'package:provider/provider.dart';

class ViewAlternativeLivelihoodDetails extends StatefulWidget {
  static const routeName = '/view_alternative_details';
  final Function()? notifyParent;

  const ViewAlternativeLivelihoodDetails({Key? key, this.notifyParent})
      : super(key: key);

  @override
  _DetailDisplayState createState() => _DetailDisplayState();
}

class _DetailDisplayState extends State<ViewAlternativeLivelihoodDetails> {
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
        Provider.of<AlternativeLivelihoodProvider>(context, listen: false)
            .findById(id.toString());

    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
        backgroundColor: fPrimaryColour,
        title: Text("Alternative Livelihood Details",
          style: TextStyle(color: fPrimaryWhite),),
        actions: [
          Tooltip(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: InkWell(
                child: Icon(Icons.home,  color: fPrimaryWhite),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Visit Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // NewBoilerTextFieldWidget(
                                  //   labelText: "Visit Number",
                                  //   controller: TextEditingController(
                                  //       text: selectedPlace.alVisitNumber),
                                  //   // suffixIconData: Icons.edit,
                                  // ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Date of visit (Y-M-D)",
                                    controller: TextEditingController(
                                        text: selectedPlace.alVisitDate),
                                    // suffixIconData: Icons.edit,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Farmer Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Farmer First Name",
                                    controller: TextEditingController(
                                        text: selectedPlace.alFarmerName),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  // NewBoilerTextFieldWidget(
                                  //   labelText: "Gender",
                                  //   controller: TextEditingController(
                                  //       text: selectedPlace.alFarmerGender),
                                  //   // suffixIconData: Icons.edit,
                                  // ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Contact",
                                    controller: TextEditingController(
                                        text: selectedPlace.alFarmerContact),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  // NewBoilerTextFieldWidget(
                                  //   labelText: "Community name",
                                  //   controller: TextEditingController(
                                  //       text: selectedPlace.alCommunityName),
                                  //   // suffixIconData: Icons.edit,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Activity Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText:
                                        "Type of additional livelihood activity",
                                    controller: TextEditingController(
                                        text:
                                            selectedPlace.alAdditionalActivity),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Trainer organisation",
                                    controller: TextEditingController(
                                        text: selectedPlace.alTrainerOrg),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText:
                                        "Date livelihood operations started",
                                    controller: TextEditingController(
                                        text: selectedPlace
                                            .alOperationsStartDate),
                                    // suffixIconData: Icons.edit,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Investment Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Initial amount invested",
                                    controller: TextEditingController(
                                        text: selectedPlace.alInitialAmount),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText:
                                        "Amount raised after ${selectedPlace.alAmountType}",
                                    controller: TextEditingController(
                                        text: selectedPlace.alAmount),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  // NewBoilerTextFieldWidget(
                                  //   labelText: "Amount raised after year 1",
                                  //   controller: TextEditingController(
                                  //       text: selectedPlace.alAmountAfterOney),
                                  //   // suffixIconData: Icons.edit,
                                  // ),
                                  // NewBoilerTextFieldWidget(
                                  //   labelText: "Amount raised after year 2",
                                  //   controller: TextEditingController(
                                  //       text: selectedPlace.alAmountAfterTwoy),
                                  //   // suffixIconData: Icons.edit,
                                  // ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Amount contributed to LMB",
                                    controller: TextEditingController(
                                        text: selectedPlace.alAmountToLMB),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Activity that income supports",
                                    controller: TextEditingController(
                                        text:
                                            selectedPlace.alActivitySupported),
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
