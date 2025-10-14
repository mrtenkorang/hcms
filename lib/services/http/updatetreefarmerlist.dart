import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/providers/personalfarmerprovideroffline.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UpdateTreeFarmerList {
  Future saveTreeFarmerApiList(BuildContext context) async {
    overlayNotification('Updating local farmer database', "positive");
    try {
      var url = '$stageBaseUrl/fetchalltreefarmer/';

      var res = await http.get(Uri.parse(url));

      final itemss = json.decode(res.body);

      print("itemss $itemss");

      if (res.statusCode == 200) {
        var farmerdata = itemss as List;
        for (var a in farmerdata) {
          // print("Farmer id ${index + index++}")
          // ;
          Provider.of<PersonalFarmerProviderApiList>(context, listen: false)
              .addPersonalFarmerApiList(
            a["type_beneficiary"].toString(),
            "",
            a["indvi_first_name"].toString(),
            a["indvi_other_names"].toString(),
            a["indvi_surname"].toString(),
            a["indvi_gender"].toString(),
            a["indvi_phone_no"].toString(),
            a["indvi_dob"].toString(),
            a["indvi_email"].toString(),
            a["indvi_address"].toString(),
            a["indvi_next_of_kin"].toString(),
            a["indvi_relationship"].toString(),
            a["indvi_next_of_kin_dob"].toString(),
            a["indvi_next_of_kin_gender"].toString(),
            a["indvi_next_of_kin_phone_no"].toString(),
            a["indvi_next_of_kin_address"].toString(),
            "",
            a["group_name"].toString(),
            a["group_president"].toString(),
            a["group_secretary"].toString(),
            a["group_phone"].toString(),
            a["group_directors"].toString(),
            a["group_email"].toString(),
            a["group_company_add"].toString(),
            "",
            "",
          );
          print("$a -- Tree Farmer id ${a["farmerid"]}");
        }
      } else {
        // overlayNotification('Error occured.', "negative");
        // Navigator.pop(context);
        // print('Error occured.');
        // return res.statusCode;
      }
    } on SocketException catch (e) {
      print("e === $e");
      overlayNotification(
          'Please connect to the internet to update local data.', "negative");
      // Navigator.of(context).pop();
    } catch (i) {
      print("i ===> $i");
      // overlayNotification(i, "negative");
      // Navigator.of(context).pop();
    }
  }
}
