import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/traininglogprovider.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/treemonitoring/components/participantsModel.dart';
import 'package:hcms_revived2/screens/treemonitoring/initialpage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ViewTrainingComponent extends StatefulWidget {
  final String? pageTitle;

  const ViewTrainingComponent({Key? key, this.pageTitle}) : super(key: key);
  @override
  _ViewTrainingComponentState createState() =>
      new _ViewTrainingComponentState();
}

class _ViewTrainingComponentState extends State<ViewTrainingComponent> {
  List<ParticipantsModelArray> items = [];
  List<ParticipantsModelArray> selectedPoints = [];
  String? _encodedKeep;
  bool sort = false;

  @override
  void initState() {
    super.initState();
    _encodedKeep = regSP?.getString("loadPartDet");
    _encodedKeep!.isNotEmpty
        ? selectedPoints = ParticipantsModelArray.decode(_encodedKeep!)
        : selectedPoints = [];
    items = selectedPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortColumnIndex: 1,
                        sortAscending: sort,
                        showCheckboxColumn: true,
                        columnSpacing: 30.0,
                        columns: [
                          DataColumn(
                            label: Text('Farmer Name'),
                          ),
                          DataColumn(
                            label: Text('Community'),
                          ),
                          DataColumn(
                            label: Text('Gender'),
                          ),
                          DataColumn(
                            label: Text('Contact'),
                          ),
                          // DataColumn(
                          //   label: Text('Signature'),
                          // ),
                        ],
                        rows: mapItemToDataRows(items).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    // _priceController.dispose();
    // _itemController.dispose();
  }

  Iterable<DataRow> mapItemToDataRows(List<ParticipantsModelArray> items) {
    Iterable<DataRow> dataRows = items.map((item) {
      return DataRow(selected: selectedPoints.contains(item), cells: [
        DataCell(
          Text(item.farmerName.toString()),
          // onTap: () {
          //   print('Selected ${item.latitude.toString()}');
          // },
        ),
        DataCell(
          Text(
            item.communityName ?? "not found",
          ),
        ),
        DataCell(
          Text(item.gender ?? "not found"),
        ),
        DataCell(
          Text(item.phoneNumber ?? "not found"),
        ),
        // DataCell(
        //   item.sigThumb != null
        //       ? CircleAvatar(
        //           radius: 30.0,
        //           child: Image.memory(
        //             base64.decode(item.sigThumb),
        //             // repeat: ImageRepeat.repeat,
        //             height: 64,
        //             width: 64,
        //             fit: BoxFit.fill,
        //           ),
        //         )
        //       : CircleAvatar(
        //           radius: 30.0,
        //           child: Image.asset(
        //             "lib/libassets/images/newUser.png",
        //             // repeat: ImageRepeat.repeat,
        //             height: 64,
        //             width: 64,
        //             fit: BoxFit.contain,
        //           ),
        //         ),
        // )
      ]);
    });
    return dataRows;
  }
}
