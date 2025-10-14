import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/utils/methods/enumerator_value.dart';
// import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
// import 'package:overlay_support/overlay_support.dart';
// import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

File? districtjsonFile;
Directory? dir;
String districtfileName = "districts.json";
bool districtfileExists = false;
var districtfileContent;

void createDistrictFile(var content, Directory dir, String fileName) {
  debugPrint("Creating District file!");
  File file = File("${dir.path}/$fileName");
  file.createSync();
  districtfileExists = true;
  file.writeAsString(json.encode(content));
}

void deleteDistrictListFile(Directory dir, String fileName) {
  debugPrint("deleting district file!");
  File file = File("${dir.path}/$fileName");
  file.deleteSync();
  districtfileExists = false;
  // file.deleteAsString(json.encode(content));
}

Future districtFileInit() async {
  await getApplicationDocumentsDirectory().then((Directory directory) async {
    dir = directory;
    districtjsonFile = File("${dir!.path}/$districtfileName");
    districtfileExists = districtjsonFile!.existsSync();
    if (districtfileExists) {
      districtfileContent =
          await json.decode(await districtjsonFile!.readAsString());
    }
  });

  return districtfileContent;
}

class DistrictListHttp {
// district list service
  Future getDistrictListService(BuildContext ctx) async {
    await getEnumeratorValue();

    await districtFileInit();

    String url = "$stageBaseUrl/districtapi/";

    final Uri getdistricturl = Uri.parse(url);

    var header = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    try {
      Map body = {"userid": enumeratorvalue};

      // var sendbody = jsonEncode(body);
      var res = await http.get(
        getdistricturl,
        headers: header,
      );

      debugPrint(body.toString());
      debugPrint(res.body);

      try {
        if (res.statusCode == 200) {
          debugPrint("Report Res is 200");

          final itemss = json.decode(res.body);

          if (districtfileExists) {
            var districtjsonFileContent =
                await json.decode(await districtjsonFile!.readAsString());
            itemss != null ? districtjsonFileContent.clear() : null;
            itemss != null ? districtjsonFileContent.addAll(itemss) : null;
            districtjsonFile!
                .writeAsString(json.encode(districtjsonFileContent));

            debugPrint("File District content $districtfileContent");
          } else {
            debugPrint("File District else content $districtfileContent");

            createDistrictFile(itemss, dir!, districtfileName);

            await districtFileInit();

            districtfileContent =
                await json.decode(await districtjsonFile!.readAsString());
          }
          return districtfileContent;
        } else {
          // final itemss = json.decode(res.body);
          // var error = itemss["errors"]
          //     .toString()
          //     .replaceAll("{", "")
          //     .replaceAll("}", "")
          //     .replaceAll("[", "")
          //     .replaceAll("]", " ");

          // Navigator.pop(ctx);
          // var message = itemss["msg"];
          debugPrint("Errors is not not");

          overlayNotification(
            "Something went wrong. Please try again later.",
            "negative",
          );
          if (districtfileExists) {
            districtfileContent =
                await json.decode(await districtjsonFile!.readAsString());
          }

          return districtfileContent;
        }
      } on SocketException catch (e) {
        // Navigator.pop(ctx);
        overlayNotification(e, "negative");
        debugPrint("Socket exception non-200");

        // return "failed internet";
        if (districtfileExists) {
          districtfileContent =
              await json.decode(await districtjsonFile!.readAsString());
        }
        return districtfileContent;
      }
    } on SocketException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Error! Please check internet connection.",
        "negative",
      );
      debugPrint("Internet error");

      // return "failed internet";
      if (districtfileExists) {
        districtfileContent =
            await json.decode(await districtjsonFile!.readAsString());
      }
      return districtfileContent;
    } on HandshakeException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Something went wrong. Please wait a while a try again",
        "negative",
      );
      // return "failed";
      if (districtfileExists) {
        districtfileContent =
            await json.decode(await districtjsonFile!.readAsString());
      }
      return districtfileContent;
    } catch (e) {
      // Navigator.pop(ctx);
      overlayNotification(
        e.toString(),
        "negative",
      );
      debugPrint("Last catch ${e.toString()}");

      // return "failed catch";
      if (districtfileExists) {
        districtfileContent =
            await json.decode(await districtjsonFile!.readAsString());
      }

      // deletedistrictFile(dir!, districtfileName);
      return districtfileContent;
    }
  }
}
