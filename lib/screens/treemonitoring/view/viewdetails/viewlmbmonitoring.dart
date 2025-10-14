import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';

import 'package:provider/provider.dart';

class ViewLMBMonitoringDetails extends StatefulWidget {
  static const routeName = '/view_lmb_monitoring_details';
  final Function()? notifyParent;

  const ViewLMBMonitoringDetails({Key? key, this.notifyParent})
      : super(key: key);

  @override
  _DetailDisplayState createState() => _DetailDisplayState();
}

class _DetailDisplayState extends State<ViewLMBMonitoringDetails> {
  final _formKey = GlobalKey<FormState>();
  bool buildC = false;

  Future<bool> reload() {
    if (buildC == !buildC)
      setState(() {
        buildC = !buildC;
      });

    throw "here wrong here";
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace =
        Provider.of<LMBMonitoringProvider>(context, listen: false)
            .findById(id.toString());

    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
        backgroundColor: fPrimaryColour,
        title: Text("LMB Monitoring Details",
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
            future: reload(),
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
                                          "Engagement Type",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "LMB name",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbName),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Engagement type",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbSector),
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
                                          "Engagement Details (Private)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Name of private sector",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbPrivateName),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Date of first engagement",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbFirstEngagement),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Type of partnership",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbPartnershipType),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Duration of partnership",
                                    controller: TextEditingController(
                                        text: selectedPlace
                                            .lmbPartnershipDuration),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Any MoU signed?",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbMou),
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
                                          "Engagement Details (Financial)",
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
                                    labelText: "Name of financial sector",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbFinancialName),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Date of first engagement",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbFirstEngagement),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText:
                                        "Type of loan/ financial service",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbTypeLoanService),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Duration of loans (in years)",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbLoanDuration),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Interest rate on the loan",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbLoanInterest +
                                            "%"),
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
                                          "Number of farmers benefitting",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Male",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbMaleBenefit),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Female",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbFemaleBenefit),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Youth",
                                    controller: TextEditingController(
                                        text: selectedPlace.lmbYouthBenefit),
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
