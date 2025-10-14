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

File? regionjsonFile;
Directory? dir;
String regionfileName = "regions.json";
bool regionfileExists = false;
var regionfileContent;

void createRegionFile(var content, Directory dir, String fileName) {
  debugPrint("Creating Region file!");
  File file = File("${dir.path}/$fileName");
  file.createSync();
  regionfileExists = true;
  file.writeAsString(json.encode(content));
}

void deleteRegionListFile(Directory dir, String fileName) {
  debugPrint("deleting region file!");
  File file = File("${dir.path}/$fileName");
  file.deleteSync();
  regionfileExists = false;
  // file.deleteAsString(json.encode(content));
}

Future regionFileInit() async {
  await getApplicationDocumentsDirectory().then((Directory directory) async {
    dir = directory;
    regionjsonFile = File("${dir!.path}/$regionfileName");
    regionfileExists = regionjsonFile!.existsSync();
    if (regionfileExists) {
      regionfileContent =
          await json.decode(await regionjsonFile!.readAsString());
    }
  });

  return regionfileContent;
}

class RegionListHttp {
// region list service
  Future getRegionListService(BuildContext ctx) async {
    await getEnumeratorValue();

    await regionFileInit();

    String url = "$stageBaseUrl/regionapi/";

    final Uri getregionurl = Uri.parse(url);

    var header = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    try {
      Map body = {"userid": enumeratorvalue};

      // var sendbody = jsonEncode(body);
      var res = await http.get(
        getregionurl,
        headers: header,
      );

      debugPrint(body.toString());
      debugPrint(res.body);

      try {
        if (res.statusCode == 200) {
          debugPrint("Report Res is 200");

          final itemss = json.decode(res.body);

          if (regionfileExists) {
            var regionjsonFileContent =
                await json.decode(await regionjsonFile!.readAsString());
            itemss != null ? regionjsonFileContent.clear() : null;
            itemss != null ? regionjsonFileContent.addAll(itemss) : null;
            regionjsonFile!.writeAsString(json.encode(regionjsonFileContent));

            debugPrint("File Region content $regionfileContent");
          } else {
            debugPrint("File Region else content $regionfileContent");

            createRegionFile(itemss, dir!, regionfileName);

            await regionFileInit();

            regionfileContent =
                await json.decode(await regionjsonFile!.readAsString());
          }
          return regionfileContent;
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
          if (regionfileExists) {
            regionfileContent =
                await json.decode(await regionjsonFile!.readAsString());
          }

          return regionfileContent;
        }
      } on SocketException catch (e) {
        // Navigator.pop(ctx);
        overlayNotification(e, "negative");
        debugPrint("Socket exception non-200");

        // return "failed internet";
        if (regionfileExists) {
          regionfileContent =
              await json.decode(await regionjsonFile!.readAsString());
        }
        return regionfileContent;
      }
    } on SocketException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Error! Please check internet connection.",
        "negative",
      );
      debugPrint("Internet error");

      // return "failed internet";
      if (regionfileExists) {
        regionfileContent =
            await json.decode(await regionjsonFile!.readAsString());
      }
      return regionfileContent;
    } on HandshakeException {
      // Navigator.pop(ctx);
      overlayNotification(
        "Something went wrong. Please wait a while a try again",
        "negative",
      );
      // return "failed";
      if (regionfileExists) {
        regionfileContent =
            await json.decode(await regionjsonFile!.readAsString());
      }
      return regionfileContent;
    } catch (e) {
      // Navigator.pop(ctx);
      overlayNotification(
        e.toString(),
        "negative",
      );
      debugPrint("Last catch ${e.toString()}");

      // return "failed catch";
      if (regionfileExists) {
        regionfileContent =
            await json.decode(await regionjsonFile!.readAsString());
      }

      // deleteregionFile(dir!, regionfileName);
      return regionfileContent;
    }
  }
}
