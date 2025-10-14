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

File? communityjsonFile;
Directory? dir;
String communityfileName = "community.json";
bool communityfileExists = false;
var communityfileContent;

void createCommunityFile(var content, Directory dir, String fileName) {
  debugPrint("Creating Community file!");
  File file = File("${dir.path}/$fileName");
  file.createSync();
  communityfileExists = true;
  file.writeAsString(json.encode(content));
}

void deleteCommunityListFile(Directory dir, String fileName) {
  debugPrint("deleting community file!");
  File file = File("${dir.path}/$fileName");
  file.deleteSync();
  communityfileExists = false;
  // file.deleteAsString(json.encode(content));
}

Future communityFileInit() async {
  await getApplicationDocumentsDirectory().then((Directory directory) async {
    dir = directory;
    communityjsonFile = File("${dir!.path}/$communityfileName");
    communityfileExists = communityjsonFile!.existsSync();
    if (communityfileExists) {
      communityfileContent =
          await json.decode(await communityjsonFile!.readAsString());
    }
  });

  return communityfileContent;
}

class CommunityListHttp {
// community list service
  Future getCommunityListService(BuildContext ctx) async {
    await getEnumeratorValue();

    await communityFileInit();

    String url = "$stageBaseUrl/communityapi/";

    final Uri getcommunityurl = Uri.parse(url);

    var header = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    try {
      Map body = {"userid": enumeratorvalue};

      // var sendbody = jsonEncode(body);
      var res = await http.get(
        getcommunityurl,
        headers: header,
      );

      debugPrint(body.toString());
      debugPrint(res.body);

      try {
        if (res.statusCode == 200) {
          debugPrint("Report Res is 200");

          final itemss = json.decode(res.body);

          if (communityfileExists) {
            var communityjsonFileContent =
                await json.decode(await communityjsonFile!.readAsString());
            itemss != null ? communityjsonFileContent.clear() : null;
            itemss != null ? communityjsonFileContent.addAll(itemss) : null;
            communityjsonFile!
                .writeAsString(json.encode(communityjsonFileContent));

            debugPrint("File Community content $communityfileContent");
          } else {
            debugPrint("File Community else content $communityfileContent");

            createCommunityFile(itemss, dir!, communityfileName);

            await communityFileInit();

            communityfileContent =
                await json.decode(await communityjsonFile!.readAsString());
          }
          return communityfileContent;
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
          if (communityfileExists) {
            communityfileContent =
                await json.decode(await communityjsonFile!.readAsString());
          }

          return communityfileContent;
        }
      } on SocketException catch (e) {
        // Navigator.pop(ctx);
        overlayNotification(e, "negative");
        debugPrint("Socket exception non-200");

        // return "failed internet";
        if (communityfileExists) {
          communityfileContent =
              await json.decode(await communityjsonFile!.readAsString());
        }
        return communityfileContent;
      }
    } on SocketException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Error! Please check internet connection.",
        "negative",
      );
      debugPrint("Internet error");

      // return "failed internet";
      if (communityfileExists) {
        communityfileContent =
            await json.decode(await communityjsonFile!.readAsString());
      }
      return communityfileContent;
    } on HandshakeException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Something went wrong. Please wait a while a try again",
        "negative",
      );
      // return "failed";
      if (communityfileExists) {
        communityfileContent =
            await json.decode(await communityjsonFile!.readAsString());
      }
      return communityfileContent;
    } catch (e) {
      // Navigator.pop(ctx);
      overlayNotification(
        e.toString(),
        "negative",
      );
      debugPrint("Last catch ${e.toString()}");

      // return "failed catch";
      if (communityfileExists) {
        communityfileContent =
            await json.decode(await communityjsonFile!.readAsString());
      }

      // deletecommunityFile(dir!, communityfileName);
      return communityfileContent;
    }
  }
}
