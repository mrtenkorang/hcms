import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:hcms_revived2/providers/monitoring/traininglogprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/components/participantsModel.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewtrainingComponent.dart';

import 'package:provider/provider.dart';

class ViewTrainingLogDetails extends StatefulWidget {
  static const routeName = '/view_training_log_details';
  final Function()? notifyParent;

  const ViewTrainingLogDetails({Key? key, this.notifyParent}) : super(key: key);

  @override
  _DetailDisplayState createState() => _DetailDisplayState();
}

class _DetailDisplayState extends State<ViewTrainingLogDetails> {
  final _formKey = GlobalKey<FormState>();
  bool buildC = false;

  Future<bool> reload() {
    if (buildC == !buildC)
      setState(() {
        buildC = !buildC;
      });

    throw "error here reload";
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace =
        Provider.of<TrainingLogProvider>(context, listen: false)
            .findById(id.toString());

    return Scaffold(
      appBar: AppBar( foregroundColor: fPrimaryWhite,
        backgroundColor: fPrimaryColour,
        title: Text("Training Log",
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
                                          "Event Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Community name",
                                    controller: TextEditingController(
                                        text: selectedPlace.tlCommunityName),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Topic",
                                    controller: TextEditingController(
                                        text: selectedPlace.tlTopic),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Date event began",
                                    controller: TextEditingController(
                                        text: selectedPlace.tlEventDate),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Event duration",
                                    controller: TextEditingController(
                                        text: selectedPlace.tlDuration),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Name of trainer",
                                    controller: TextEditingController(
                                        text: selectedPlace.tlTrainerName),
                                    // suffixIconData: Icons.edit,
                                  ),
                                  NewBoilerTextFieldWidget(
                                    labelText: "Trainer's organisation",
                                    controller: TextEditingController(
                                        text: selectedPlace.tlTrainerOrg),
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
                                          "Participant Information",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ViewTrainingComponent(),
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
