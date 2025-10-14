import 'package:flutter/foundation.dart';

// I am feeling lazy to go through all the services files to
// change the stageBaseUrls to productionBaseUrls so I am just
// going to replace the stageBaseUrls with the correct production
// url and comment out the original stageBa

// Using this to set stageBaseUrl depending on the run profile being used
// whether debug or otherwise

String stageBaseUrl = "";
String socketBaseUrl = "";
String socketAddUrl = "";

void changeBaseUrlValue() {
  if (kDebugMode) {
    stageBaseUrl = "http://172.104.147.113";
    // socketBaseUrl = "wss://spark.detosphere.com";
    socketAddUrl = "/";
  } else {
    stageBaseUrl = "http://172.104.147.113";
    // socketBaseUrl = "https://api.52wse.com";
    socketAddUrl = "/";
  }
}
