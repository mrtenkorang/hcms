

//   import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:hcms_revived2/models/firebase/pushnotifmodel.dart';
// import 'package:hcms_revived2/providers/notifications/newsandarticlesprovider.dart';
// import 'package:hcms_revived2/providers/notifications/trainingsandworkshops.dart';
// import 'package:provider/provider.dart';

// Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();

//     PushNotification notification = PushNotification(
//       title: message.notification?.title,
//       body: message.notification?.body,
//       dataTitle: message.data['title'],
//       dataBody: message.data['body'],
//     );

//     print("Notif in splash ${notification.dataTitle ?? notification.title}");
//     String? title = notification.dataTitle ?? notification.title;

//     title == "News/Articles"
//         ? Provider.of<NewsAndArticlesProvider>(context, listen: false)
//             .addNewsArticles(
//                 notification.dataTitle ?? notification.title.toString(),
//                 notification.dataBody ?? notification.body.toString())
//         : Provider.of<TrainingWorkShopsProvider>(this.context, listen: false)
//             .addTrainingsWorkshops(
//                 notification.dataTitle ?? notification.title.toString(),
//                 notification.dataBody ?? notification.body.toString());
//   }

//   checkForInitialMessage() async {
//     await Firebase.initializeApp();
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     if (initialMessage != null) {
//       PushNotification notification = PushNotification(
//         title: initialMessage.notification?.title,
//         body: initialMessage.notification?.body,
//       );
//     }
//   }
// abstract class FirebaseSkeleton{
//     checkForInitialMessage();
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       await Firebase.initializeApp();
//       print('A new onMessageOpenedApp event was published!');

//       PushNotification notification = PushNotification(
//         title: message.notification?.title,
//         body: message.notification?.body,
//         dataTitle: message.data['title'],
//         dataBody: message.data['body'],
//       );

//       print(
//           "Notif in splash title ${notification.dataTitle ?? notification.title}");
//       print(
//           "Notif in splash body ${notification.dataBody ?? notification.body}");
//       String? title = notification.dataTitle ?? notification.title;

//       title == "News/Articles"
//           ? Provider.of<NewsAndArticlesProvider>(this.context, listen: false)
//               .addNewsArticles(
//                   notification.dataTitle ?? notification.title.toString(),
//                   notification.dataBody ?? notification.body.toString())
//           : Provider.of<TrainingWorkShopsProvider>(this.context, listen: false)
//               .addTrainingsWorkshops(
//                   notification.dataTitle ?? notification.title.toString(),
//                   notification.dataBody ?? notification.body.toString());
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       await Firebase.initializeApp();

//       PushNotification notification = PushNotification(
//         title: message.notification?.title,
//         body: message.notification?.body,
//         dataTitle: message.data['title'],
//         dataBody: message.data['body'],
//       );

//       print("Notif in splash ${notification.dataTitle ?? notification.title}");
//       print(
//           "Notif in splash body ${notification.dataBody ?? notification.body}");
//       String? title = notification.dataTitle ?? notification.title;

//       // BuildContext? context;
//       title == "News/Articles"
//           ? Provider.of<NewsAndArticlesProvider>(this.context, listen: false)
//               .addNewsArticles(
//                   notification.dataTitle ?? notification.title.toString(),
//                   notification.dataBody ?? notification.body.toString())
//           : Provider.of<TrainingWorkShopsProvider>(this.context, listen: false)
//               .addTrainingsWorkshops(
//                   notification.dataTitle ?? notification.title.toString(),
//                   notification.dataBody ?? notification.body.toString());
//     });}