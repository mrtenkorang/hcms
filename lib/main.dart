import 'dart:async';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/helpers/services/seedling_monitoring_services.dart';
import 'package:hcms_revived2/theme/app_theme.dart';
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

  // changeBaseUrlValue();

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
    Get.put(AlternativeLivelihoodProvider(), permanent: true);

    // Request permissions when app starts
    _requestPermissions();

    return OverlaySupport(
      child: MultiProvider(
        providers: [
          // ADDED: Register LMBMonitoringProvider as a Provider
          ChangeNotifierProvider(
            create: (ctx) => LMBMonitoringProvider(),
          ),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HCMS',
          color: Colors.white,
          theme: AppTheme.lightTheme.copyWith(
            textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
          ),
          home: Splash(),
          routes: {
            IndexPage.routeName: (ctx) => IndexPage(),
            // ViewDeforestationReportDetails.routeName: (ctx) => ViewDeforestationReportDetails(),
          },
        ),
      ),
    );
  }

  // Method to request all necessary permissions
  Future<void> _requestPermissions() async {
    // Request location permission
    final locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      final locationResult = await Permission.location.request();
      _handlePermissionResult('Location', locationResult);
    }

    // Request storage permission (for Android)
    final storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      final storageResult = await Permission.storage.request();
      _handlePermissionResult('Storage', storageResult);
    }
  }

  // Helper method to handle permission results
  void _handlePermissionResult(String permissionName, PermissionStatus result) {
    if (result.isGranted) {
      print('$permissionName permission granted');
    } else if (result.isDenied) {
      print('$permissionName permission denied');
    } else if (result.isPermanentlyDenied) {
      print('$permissionName permission permanently denied');
      // You can show specific dialogs for each permission type
      _showPermissionSettingsDialog(permissionName);
    }
  }

  // Method to show dialog guiding user to app settings
  void _showPermissionSettingsDialog(String permissionName) {
    Future.delayed(Duration(seconds: 1), () {
      // Example using GetX dialog
      Get.dialog(
        AlertDialog(
          title: Text('Permission Required'),
          content: Text('$permissionName permission is required for this app to function properly. Please enable it in app settings.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        ),
      );
    });
  }
}