import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/models/firebase/pushnotifmodel.dart';
import 'package:hcms_revived2/providers/notifications/newsandarticlesprovider.dart';
import 'package:hcms_revived2/providers/notifications/trainingsandworkshops.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/sync/sync_page.dart';
import 'package:hcms_revived2/splash/intros/newintros.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hcms_revived2/screens/home/auth/usersingin/signin.dart';
import 'package:hcms_revived2/splash/intros/intros.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  static int counto = 0;
  static int? countos;
  static int? countoa;

  bool? logStatus;

  Future<dynamic> getLogStatus() async {
    final cacheService = await CacheService.getInstance();
    logStatus = cacheService.getLoginStatus();
    debugPrint("Log status is $logStatus");
    return logStatus;
  }

  Future<void> _initializeApp() async {
    await getLogStatus();
    if (logStatus == true) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => const SyncPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => UserSignIn()),
      );
    }
    // if (mounted) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     getLogStatus();
    //     if (mounted) {
    //
    //     }
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        // color: Color(0xFFf7f7f7),
        padding: const EdgeInsets.all(0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0.0),
          child: Image.asset(
            "lib/libassets/logos/hcmssplash.png",
            // fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
