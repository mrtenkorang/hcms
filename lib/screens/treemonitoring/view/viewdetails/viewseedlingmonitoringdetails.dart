import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/providers/monitoring/seedlingmonitoringprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import 'package:provider/provider.dart';

class ViewSeedlingMonitoringDetails extends StatefulWidget {
  static const routeName = '/view_seedling_details';
  final Function()? notifyParent;

  const ViewSeedlingMonitoringDetails({Key? key, this.notifyParent})
      : super(key: key);

  @override
  _DetailDisplayState createState() => _DetailDisplayState();
}

class _DetailDisplayState extends State<ViewSeedlingMonitoringDetails> {
  final _formKey = GlobalKey<FormState>();
  bool buildC = false;

  // Future<bool> reload() {
  //   if (buildC == !buildC)
  //     setState(() {
  //       buildC = !buildC;
  //     });

  //   throw "reload error";
  // }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace =
        Provider.of<SeedlingMonitoringProvider>(context, listen: false)
            .findById(id.toString());

    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
        backgroundColor: fPrimaryColour,
        title: Text("Tree Seedling Monitoring Details",
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
                                  //       text: selectedPlace.smVisitNumber),
                                  //   // suffixIconData: Icons.edit,
                                  // ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Date of visit (Y-M-D)",
                                    controller: TextEditingController(
                                        text: selectedPlace.smVisitDate),
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
                                    labelText: "Farmer Name",
                                    controller: TextEditingController(
                                        text: selectedPlace.smFarmerName),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  // NewBoilerTextFieldWidget(
                                  //   labelText: "Gender",
                                  //   controller: TextEditingController(
                                  //       text: selectedPlace.smFarmerGender),
                                  //   // suffixIconData: Icons.edit,
                                  // ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Contact",
                                    controller: TextEditingController(
                                        text: selectedPlace.smFarmerContact),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  // NewBoilerTextFieldWidget(
                                  //   labelText: "Community name",
                                  //   controller: TextEditingController(
                                  //       text: selectedPlace.smCommunityName),
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
                                          "Tree Details",
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
                                    labelText: "Species received",
                                    controller: TextEditingController(
                                        text: selectedPlace.smSpecies),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Date received",
                                    controller: TextEditingController(
                                        text: selectedPlace.smReceivedDate),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Date planted",
                                    controller: TextEditingController(
                                        text: selectedPlace.smPlantedDate),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Quantity received",
                                    controller: TextEditingController(
                                        text: selectedPlace.smQuantityReceived),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Quantity planted",
                                    controller: TextEditingController(
                                        text: selectedPlace.smQuantityPlanted),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Quantity survived",
                                    controller: TextEditingController(
                                        text: selectedPlace.smQuantitySurvived),
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
                                          "Planting Area",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Planting area type",
                                    controller: TextEditingController(
                                        text: selectedPlace.smPlantingArea),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Location of the farm",
                                    controller: TextEditingController(
                                        text: selectedPlace.smFarmLocation),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Area size or farm size (Acre)",
                                    controller: TextEditingController(
                                        text: selectedPlace.smAreaSize),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText:
                                        "How many trees have been registered?",
                                    controller: TextEditingController(
                                        text: selectedPlace.smRegisteredTrees),
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
