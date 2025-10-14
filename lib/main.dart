import 'dart:async';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
// import 'package:hcms_revived2/models/firebase/pushnotifmodel.dart';
import 'package:hcms_revived2/providers/deforestationprovider.dart';
import 'package:hcms_revived2/providers/monitoring/alternativelivelihoodprovider.dart';
import 'package:hcms_revived2/providers/monitoring/lmbmonitoringprovider.dart';
import 'package:hcms_revived2/providers/monitoring/registeredfarmerApiAlternativeprovider.dart';
import 'package:hcms_revived2/providers/monitoring/registeredfarmerApiSeedlingprovider.dart';
import 'package:hcms_revived2/providers/monitoring/registeredfarmerprovider.dart';
import 'package:hcms_revived2/providers/monitoring/seedlingmonitoring2provider.dart';
import 'package:hcms_revived2/providers/monitoring/seedlingmonitoringprovider.dart';
import 'package:hcms_revived2/providers/monitoring/traininglogprovider.dart';
import 'package:hcms_revived2/providers/notifications/newsandarticlesprovider.dart';
import 'package:hcms_revived2/providers/notifications/trainingsandworkshops.dart';
import 'package:hcms_revived2/providers/personalfarmerprovider.dart';
import 'package:hcms_revived2/providers/personalfarmerprovideroffline.dart';
import 'package:hcms_revived2/screens/Deforestation/viewdetailsdef.dart';
import 'package:hcms_revived2/screens/home/index.dart';
import 'package:hcms_revived2/screens/home/index_data_loader.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewalternatelivelihooddetails.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewlmbmonitoring.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewseedlingmonitoringdetails.dart';
import 'package:hcms_revived2/screens/treemonitoring/view/viewdetails/viewtraininglogdetails.dart';
import 'package:hcms_revived2/screens/viewsubmissions/viewincompletedetails.dart';
import 'package:hcms_revived2/screens/viewsubmissions/viewpage.dart';
// import 'package:hcms_revived2/services/http/firebasetoken.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:hcms_revived2/splash/intros/newintros.dart';
import 'package:hcms_revived2/splash/splashscreen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Firebase imports commented out
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

SharedPreferences? regSP;

// FirebaseTokenService firebaseTokenService = FirebaseTokenService();
// final FirebaseMessaging _firebaseNotif = FirebaseMessaging.instance;

// Firebase Messaging background handler commented out
/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  PushNotification notification = PushNotification(
    title: message.notification?.title,
    body: message.notification?.body,
    dataTitle: message.data['title'],
    dataBody: message.data['body'],
  );

  print("Notif in main ${notification.dataTitle ?? notification.title}");

  List<String> naPushNotifTitles = [];
  List<String> naPushNotifBodies = [];

  List<String> wsPushNotifTitles = [];
  List<String> wsPushNotifBodies = [];

  if (notification.dataTitle == "News/Articles" || notification.title == "News/Articles") {
    print("Doing here");
    naPushNotifTitles.add(notification.dataTitle ?? notification.title!);
    naPushNotifBodies.add(notification.dataBody ?? notification.body!);
  } else {
    print("Doing there");
    wsPushNotifTitles.add(notification.dataTitle ?? notification.title!);
    wsPushNotifBodies.add(notification.dataBody ?? notification.body!);
  }

  regSP?.setStringList("natifNATitle", naPushNotifTitles);
  regSP?.setStringList("natifNABody", naPushNotifBodies);
  regSP?.setStringList("wstifWSTitle", wsPushNotifTitles);
  regSP?.setStringList("wstifWSBody", wsPushNotifBodies);

  Timer(const Duration(seconds: 3), () {
    print("Background list $naPushNotifTitles");
    print("Background ${regSP?.getStringList("natifNATitle")}");
  });
}
*/

// Firebase initial message check commented out
/*
checkForInitialMessage() async {
  await Firebase.initializeApp();
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    PushNotification notification = PushNotification(
      title: initialMessage.notification?.title,
      body: initialMessage.notification?.body,
    );
  }
}
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  changeBaseUrlValue();

  // Firebase initialization commented out
  // await Firebase.initializeApp();
  // checkForInitialMessage();

  regSP = await SharedPreferences.getInstance();

  // Firebase background message handler commented out
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Firebase token retrieval commented out
  /*
  await _firebaseNotif.getToken().then((value) async {
    print("Firebase device token $value");
    await firebaseTokenService.saveFirebaseTokenService(firebasetoken: value);
  });
  */

  // Firebase message opened app listener commented out
  /*
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    await Firebase.initializeApp();
    print('A new onMessageOpenedApp event was published!');

    PushNotification notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      dataTitle: message.data['title'],
      dataBody: message.data['body'],
    );

    print("Notif in main title ${notification.dataTitle ?? notification.title}");
    print("Notif in main body ${notification.dataBody ?? notification.body}");
  });
  */

  // Firebase on message listener commented out
  /*
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await Firebase.initializeApp();
    print('A new onMessage event was published!');

    PushNotification notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      dataTitle: message.data['title'],
      dataBody: message.data['body'],
    );

    print("Notif in main ${notification.dataTitle ?? notification.title}");
    print("Notif in main body ${notification.dataBody ?? notification.body}");
  });
  */

  // Firebase notification presentation options commented out
  /*
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
  );
  */

  // Firebase messaging permission request commented out
  /*
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  */

  runApp(MyApp());

  // Request permissions (keeping this as it's not Firebase-specific)
  final status = await Permission.storage.status;
  final loc = await Permission.location.status;

  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if (!loc.isGranted) {
    await Permission.location.request();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => PersonalFarmerProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => SeedlingMonitoringProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => SeedlingMonitoring2Provider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => LMBMonitoringProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => AlternativeLivelihoodProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => TrainingLogProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => RegisteredFarmerProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => RegisteredFarmerListApiSeedlingApiProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => RegisteredFarmerListApiAlternativeApiProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => NewsAndArticlesProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => TrainingWorkShopsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => PersonalFarmerProviderApiList(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => PersonalFarmerProviderOffline(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => DeforestationProvider(),
          ),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HCMS',
          color: Colors.white,
          theme: ThemeData(
            primaryColor: fPrimaryColour,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
            fontFamily: "Roboto",
          ),
          home: Splash(),
          routes: {
            IndexPage.routeName: (ctx) => IndexPage(),
            ViewReport.routeName: (ctx) => ViewReport(),
            DetailDisplayIncomplete.routeName: (ctx) => DetailDisplayIncomplete(),
            ViewSeedlingMonitoringDetails.routeName: (ctx) => ViewSeedlingMonitoringDetails(),
            ViewAlternativeLivelihoodDetails.routeName: (ctx) => ViewAlternativeLivelihoodDetails(),
            ViewLMBMonitoringDetails.routeName: (ctx) => ViewLMBMonitoringDetails(),
            ViewTrainingLogDetails.routeName: (ctx) => ViewTrainingLogDetails(),
            ViewDeforestationReportDetails.routeName: (ctx) => ViewDeforestationReportDetails(),
          },
        ),
      ),
    );
  }
}