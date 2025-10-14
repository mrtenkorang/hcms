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

File? stooljsonFile;
Directory? dir;
String stoolfileName = "stool.json";
bool stoolfileExists = false;
var stoolfileContent;

void createStoolFile(var content, Directory dir, String fileName) {
  debugPrint("Creating Stool file!");
  File file = File("${dir.path}/$fileName");
  file.createSync();
  stoolfileExists = true;
  file.writeAsString(json.encode(content));
}

void deleteStoolListFile(Directory dir, String fileName) {
  debugPrint("deleting stool file!");
  File file = File("${dir.path}/$fileName");
  file.deleteSync();
  stoolfileExists = false;
  // file.deleteAsString(json.encode(content));
}

Future stoolFileInit() async {
  await getApplicationDocumentsDirectory().then((Directory directory) async {
    dir = directory;
    stooljsonFile = File("${dir!.path}/$stoolfileName");
    stoolfileExists = stooljsonFile!.existsSync();
    if (stoolfileExists) {
      stoolfileContent =
          await json.decode(await stooljsonFile!.readAsString());
    }
  });

  return stoolfileContent;
}

class StoolListHttp {
// stool list service
  Future getStoolListService(BuildContext ctx) async {
    await getEnumeratorValue();

    await stoolFileInit();

    String url = "$stageBaseUrl/stoolapi/";

    final Uri getstoolurl = Uri.parse(url);

    var header = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    try {
      Map body = {"userid": enumeratorvalue};

      // var sendbody = jsonEncode(body);
      var res = await http.get(
        getstoolurl,
        headers: header,
      );

      debugPrint(body.toString());
      debugPrint(res.body);

      try {
        if (res.statusCode == 200) {
          debugPrint("Report Res is 200");

          final itemss = json.decode(res.body);

          if (stoolfileExists) {
            var stooljsonFileContent =
                await json.decode(await stooljsonFile!.readAsString());
            itemss != null ? stooljsonFileContent.clear() : null;
            itemss != null ? stooljsonFileContent.addAll(itemss) : null;
            stooljsonFile!
                .writeAsString(json.encode(stooljsonFileContent));

            debugPrint("File Stool content $stoolfileContent");
          } else {
            debugPrint("File Stool else content $stoolfileContent");

            createStoolFile(itemss, dir!, stoolfileName);

            await stoolFileInit();

            stoolfileContent =
                await json.decode(await stooljsonFile!.readAsString());
          }
          return stoolfileContent;
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
          if (stoolfileExists) {
            stoolfileContent =
                await json.decode(await stooljsonFile!.readAsString());
          }

          return stoolfileContent;
        }
      } on SocketException catch (e) {
        // Navigator.pop(ctx);
        overlayNotification(e, "negative");
        debugPrint("Socket exception non-200");

        // return "failed internet";
        if (stoolfileExists) {
          stoolfileContent =
              await json.decode(await stooljsonFile!.readAsString());
        }
        return stoolfileContent;
      }
    } on SocketException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Error! Please check internet connection.",
        "negative",
      );
      debugPrint("Internet error");

      // return "failed internet";
      if (stoolfileExists) {
        stoolfileContent =
            await json.decode(await stooljsonFile!.readAsString());
      }
      return stoolfileContent;
    } on HandshakeException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Something went wrong. Please wait a while a try again",
        "negative",
      );
      // return "failed";
      if (stoolfileExists) {
        stoolfileContent =
            await json.decode(await stooljsonFile!.readAsString());
      }
      return stoolfileContent;
    } catch (e) {
      // Navigator.pop(ctx);
      overlayNotification(
        e.toString(),
        "negative",
      );
      debugPrint("Last catch ${e.toString()}");

      // return "failed catch";
      if (stoolfileExists) {
        stoolfileContent =
            await json.decode(await stooljsonFile!.readAsString());
      }

      // deletestoolFile(dir!, stoolfileName);
      return stoolfileContent;
    }
  }
}
