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

File? forestdistrictjsonFile;
Directory? dir;
String forestdistrictfileName = "forestdistrict.json";
bool forestdistrictfileExists = false;
var forestdistrictfileContent;

void createForestdistrictFile(var content, Directory dir, String fileName) {
  debugPrint("Creating Forestdistrict file!");
  File file = File("${dir.path}/$fileName");
  file.createSync();
  forestdistrictfileExists = true;
  file.writeAsString(json.encode(content));
}

void deleteForestdistrictListFile(Directory dir, String fileName) {
  debugPrint("deleting forestdistrict file!");
  File file = File("${dir.path}/$fileName");
  file.deleteSync();
  forestdistrictfileExists = false;
  // file.deleteAsString(json.encode(content));
}

Future forestdistrictFileInit() async {
  await getApplicationDocumentsDirectory().then((Directory directory) async {
    dir = directory;
    forestdistrictjsonFile = File("${dir!.path}/$forestdistrictfileName");
    forestdistrictfileExists = forestdistrictjsonFile!.existsSync();
    if (forestdistrictfileExists) {
      forestdistrictfileContent =
          await json.decode(await forestdistrictjsonFile!.readAsString());
    }
  });

  return forestdistrictfileContent;
}

class ForestDistrictListHttp {
// forestdistrict list service
  Future getForestdistrictListService(BuildContext ctx) async {
    await getEnumeratorValue();

    await forestdistrictFileInit();

    String url = "$stageBaseUrl/forestdistapi/";

    final Uri getforestdistricturl = Uri.parse(url);

    var header = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    try {
      Map body = {"userid": enumeratorvalue};

      // var sendbody = jsonEncode(body);
      var res = await http.get(
        getforestdistricturl,
        headers: header,
      );

      debugPrint(body.toString());
      debugPrint(res.body);

      try {
        if (res.statusCode == 200) {
          debugPrint("Report Res is 200");

          final itemss = json.decode(res.body);

          if (forestdistrictfileExists) {
            var forestdistrictjsonFileContent =
                await json.decode(await forestdistrictjsonFile!.readAsString());
            itemss != null ? forestdistrictjsonFileContent.clear() : null;
            itemss != null ? forestdistrictjsonFileContent.addAll(itemss) : null;
            forestdistrictjsonFile!
                .writeAsString(json.encode(forestdistrictjsonFileContent));

            debugPrint("File Forestdistrict content $forestdistrictfileContent");
          } else {
            debugPrint("File Forestdistrict else content $forestdistrictfileContent");

            createForestdistrictFile(itemss, dir!, forestdistrictfileName);

            await forestdistrictFileInit();

            forestdistrictfileContent =
                await json.decode(await forestdistrictjsonFile!.readAsString());
          }
          return forestdistrictfileContent;
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
          if (forestdistrictfileExists) {
            forestdistrictfileContent =
                await json.decode(await forestdistrictjsonFile!.readAsString());
          }

          return forestdistrictfileContent;
        }
      } on SocketException catch (e) {
        // Navigator.pop(ctx);
        overlayNotification(e, "negative");
        debugPrint("Socket exception non-200");

        // return "failed internet";
        if (forestdistrictfileExists) {
          forestdistrictfileContent =
              await json.decode(await forestdistrictjsonFile!.readAsString());
        }
        return forestdistrictfileContent;
      }
    } on SocketException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Error! Please check internet connection.",
        "negative",
      );
      debugPrint("Internet error");

      // return "failed internet";
      if (forestdistrictfileExists) {
        forestdistrictfileContent =
            await json.decode(await forestdistrictjsonFile!.readAsString());
      }
      return forestdistrictfileContent;
    } on HandshakeException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Something went wrong. Please wait a while a try again",
        "negative",
      );
      // return "failed";
      if (forestdistrictfileExists) {
        forestdistrictfileContent =
            await json.decode(await forestdistrictjsonFile!.readAsString());
      }
      return forestdistrictfileContent;
    } catch (e) {
      // Navigator.pop(ctx);
      overlayNotification(
        e.toString(),
        "negative",
      );
      debugPrint("Last catch ${e.toString()}");

      // return "failed catch";
      if (forestdistrictfileExists) {
        forestdistrictfileContent =
            await json.decode(await forestdistrictjsonFile!.readAsString());
      }

      // deleteforestdistrictFile(dir!, forestdistrictfileName);
      return forestdistrictfileContent;
    }
  }
}
