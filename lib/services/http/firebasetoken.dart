import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:http/http.dart' as http;

String baseUrl = "$stageBaseUrl/";

class FirebaseTokenService {
  // save firebase token service
  saveFirebaseTokenService({firebasetoken}) async {
    String url = "${baseUrl}savefirebasecode/?token=$firebasetoken";

    final Uri savefirebasetokenurl = Uri.parse(url);

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    try {
      var res = await http.get(savefirebasetokenurl, headers: header);

      print(res.body);
      try {} catch (e) {
        overlayNotification(e.toString(), "negative");
        print("Error on decoding response");
      }

      try {
        if (res.statusCode == 200) {
          print("Firebase 200 ${res.body.toString()}");
        } else {
          print("Firebase error ${res.statusCode} and ${res.body.toString()}");
        }
      } on SocketException catch (e) {
        overlayNotification(e.toString(), "negative");
        print("Socket exception non-200");
      }
    } on SocketException {
      overlayNotification("Please check internet connection.", "negative");
      print("Internet error");
    }
  }
}
