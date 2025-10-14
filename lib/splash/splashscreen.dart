import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/models/firebase/pushnotifmodel.dart';
import 'package:hcms_revived2/providers/notifications/newsandarticlesprovider.dart';
import 'package:hcms_revived2/providers/notifications/trainingsandworkshops.dart';
import 'package:hcms_revived2/screens/home/index.dart';
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

  String? logStatus;

  static getNumber() async {
    final db = await DBHelper.database();
    counto = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) FROM first_time_user'))!;
    print("Counto counted was $counto");
    return counto;
  }

  static getFarmerApiListSeedlingNumber() async {
    final db = await DBHelper.database();
    countos = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) FROM farmer_api_list_seedling'));
    print("Countos counted was $countos");
    return countos;
  }

  static getFarmerApiListAlternativeNumber() async {
    final db = await DBHelper.database();
    countoa = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) FROM farmer_api_list_alternative'));
    print("Countoa counted was $countoa");
    return countoa;
  }

  Future<dynamic> getLogStatus() async {
    final db = await DBHelper.database();
    var count = await db.rawQuery('SELECT log FROM first_time_user');

    var list = count.toList();

    mounted
        ? setState(() {
            logStatus = (list.isNotEmpty ? list[0]['log'] : "") as String?;
          })
        : null;
  }

  @override
  void initState() {
    super.initState();
    getNumber();
    getLogStatus();
    getFarmerApiListSeedlingNumber();
    getFarmerApiListAlternativeNumber();

    Timer(
      Duration(seconds: 3),
      () {
        if (counto < 1) {
          print("first one doing");
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => NewIntros(),
          ));
        } else {
          print("second one doing");
          if (logStatus == "in") {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (context) => IndexPage(),
            ));
          } else {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (context) => UserSignIn(),
            ));
          }
        }
      },
    );
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
