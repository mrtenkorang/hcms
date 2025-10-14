import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter/services.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:hcms_revived2/providers/monitoring/registeredfarmerApiAlternativeprovider.dart';
import 'package:hcms_revived2/providers/monitoring/registeredfarmerApiSeedlingprovider.dart';
import 'package:hcms_revived2/screens/home/components/options.dart';
import 'package:hcms_revived2/services/http/firebasetoken.dart';
import 'package:hcms_revived2/services/http/updatetreefarmerlist.dart';
import 'package:hcms_revived2/services/http/userrating.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hcms_revived2/models/firebase/pushnotifmodel.dart';
import 'package:hcms_revived2/providers/notifications/newsandarticlesprovider.dart';
import 'package:hcms_revived2/providers/notifications/trainingsandworkshops.dart';
import 'package:hcms_revived2/services/serverurls.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'components/header.dart';

class IndexPage extends StatefulWidget {
  static const routeName = '/index_page';
  final String? userContact;

  const IndexPage({Key? key, this.userContact}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // Services - make final for better performance
  final FirebaseTokenService _firebaseTokenService = FirebaseTokenService();
  final UserRatingService _userRatingService = UserRatingService();
  final UpdateTreeFarmerList _updateTreeFarmerList = UpdateTreeFarmerList();

  // State variables
  String? _displayName;
  String? _userRate;
  bool? _ratingInitRun;
  int? _index;

  // Firebase messaging handlers - optimized as final methods
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    final notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      dataTitle: message.data['title'],
      dataBody: message.data['body'],
    );

    final title = notification.dataTitle ?? notification.title;
    final body = notification.dataBody ?? notification.body;

    Timer(const Duration(seconds: 2), () {
      if (title == "News/Articles") {
        Provider.of<NewsAndArticlesProvider>(context, listen: false)
            .addNewsArticles(title.toString(), body.toString());
      } else {
        Provider.of<TrainingWorkShopsProvider>(context, listen: false)
            .addTrainingsWorkshops(title.toString(), body.toString());
      }
    });
  }

  Future<void> _firebaseMessagingHandler(RemoteMessage message) async {
    await Firebase.initializeApp();

    final notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      dataTitle: message.data['title'],
      dataBody: message.data['body'],
    );

    final title = notification.dataTitle ?? notification.title;
    final body = notification.dataBody ?? notification.body;

    _showNotifDialogue(title, body);

    _addNotificationToProvider(title, body);
  }

  Future<void> _firebaseMessagingHandlerOnAppOpen(RemoteMessage message) async {
    await Firebase.initializeApp();

    final notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      dataTitle: message.data['title'],
      dataBody: message.data['body'],
    );

    final title = notification.dataTitle ?? notification.title;
    final body = notification.dataBody ?? notification.body;

    _showNotifDialogue(title, body);

    _addNotificationToProvider(title, body);
  }

  // Helper method to avoid code duplication
  void _addNotificationToProvider(String? title, String? body) {
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (title == "News/Articles") {
        Provider.of<NewsAndArticlesProvider>(context, listen: false)
            .addNewsArticles(title.toString(), body.toString());
      } else {
        Provider.of<TrainingWorkShopsProvider>(context, listen: false)
            .addTrainingsWorkshops(title.toString(), body.toString());
      }
    });
  }

  // Optimized database operations
  Future<void> _getDisplayName() async {
    final db = await DBHelper.database();
    final result = await db.rawQuery('SELECT * FROM first_time_user LIMIT 1');

    if (mounted) {
      setState(() {
        _displayName = result.isNotEmpty
            ? result[0]['displayName'].toString()
            : "Guest User";
      });
    }
  }

  // Optimized farmer list operations
  Future<void> _saveToLocalDBSeedling(Map<String, dynamic> farmer) async {
    Provider.of<RegisteredFarmerListApiSeedlingApiProvider>(context, listen: false)
        .addRegisteredFarmerListApiSeedling(
      farmer["farmerid"].toString(),
      farmer["farmer_name"],
      farmer["community_name"],
      farmer["community"].toString(),
      farmer["contact"],
      farmer["baseline"].toString(),
    );
  }

  Future<void> _saveToLocalDBAlternative(Map<String, dynamic> farmer) async {
    Provider.of<RegisteredFarmerListApiAlternativeApiProvider>(context, listen: false)
        .addRegisteredFarmerListApiAlternative(
      farmer["farmerid"].toString(),
      farmer["farmer_name"],
      farmer["community_name"],
      farmer["community"].toString(),
      farmer["contact"],
      farmer["baseline"].toString(),
    );
  }

  Future<bool> _farmerExists(String table, String contact) async {
    final db = await DBHelper.database();
    final result = await db.query(table, where: "fal${table == "farmer_api_list_seedling" ? "S" : "A"}Contact = ?", whereArgs: [contact]);
    return result.isNotEmpty;
  }

  Future<void> _processFarmersList(String formType, List<dynamic> farmers) async {
    final table = formType == "seedling"
        ? "farmer_api_list_seedling"
        : "farmer_api_list_alternative";

    for (final farmer in farmers) {
      final exists = await _farmerExists(table, farmer["contact"]);
      if (!exists) {
        if (formType == "seedling") {
          await _saveToLocalDBSeedling(farmer);
        } else {
          await _saveToLocalDBAlternative(farmer);
        }
      }
    }
  }

  Future<void> _getFarmersApiList(String formType, BuildContext ctx) async {
    try {
      final url = '$stageBaseUrl/farmerlist/?form=$formType';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        await _processFarmersList(formType, data);

        if (formType == "alternative") {
          overlayNotification('Data loaded successfully', "positive");
        }
      }
    } on SocketException {
      overlayNotification(
          'Oops! Please connect to the internet to update local data.',
          "negative"
      );
    } catch (e) {
      print('Error loading $formType farmers: $e');
    }
  }

  // Optimized initialization
  Future<void> _initializeData() async {
    await _getDisplayName();

    // Set user contact in shared preferences
    if (widget.userContact != null) {
      regSP?.setString("userContact", widget.userContact!);
    }

    // Initialize rating
    _ratingInitRun = regSP?.getBool("ratinginitrun") ?? false;
    await _initializeUserRating();

    // Load farmer data
    _index = 0;
    await _loadFarmerData();
  }

  Future<void> _initializeUserRating() async {
    final contact = widget.userContact ?? regSP?.getString("userContact");
    final rating = await _userRatingService.userRatingService(context, contact: contact);

    if (mounted) {
      setState(() {
        _userRate = rating.toString();
      });

      if (_ratingInitRun == false) {
        userRatingDialogue(context, rating.toString());
      }
    }
  }

  Future<void> _loadFarmerData() async {
    await _getFarmersApiList("seedling", context);

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _ratingInitRun = true;
        });
        _updateTreeFarmerList.saveTreeFarmerApiList(context);
      }
    });

    await _getFarmersApiList("alternative", context);
  }

  // Firebase initialization
  Future<void> _initializeFirebase() async {
    await checkForInitialMessage();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_firebaseMessagingHandlerOnAppOpen);
    FirebaseMessaging.onMessage.listen(_firebaseMessagingHandler);
  }

  Future<void> checkForInitialMessage() async {
    await Firebase.initializeApp();
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // Initial message handling if needed
  }

  void _showNotifDialogue(String? title, String? body) {
    showSimpleNotification(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title ?? '',
          softWrap: true,
          style: const TextStyle(color: Colors.yellow),
        ),
      ),
      leading: Image.asset("lib/libassets/logos/hcmslogo.png", scale: 12),
      subtitle: Text(
        body ?? '',
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      duration: const Duration(seconds: 6),
      background: fPrimaryColour,
      slideDismissDirection: DismissDirection.horizontal,
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
    );
  }

  @override
  void initState() {
    super.initState();

    // Initialize everything in sequence for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
      _initializeFirebase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 45.0, bottom: 10.0),
                      child: HomePage(
                        size: size,
                        identity: _displayName ?? "Loading...",
                        treeCount: _userRate ?? "0",
                      ),
                    ),
                    Options(),
                  ],
                ),
              ),
            ),
            _buildExitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildExitButton() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10.0,
          backgroundColor: const Color(0xFFd81a60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: _handleExit,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.exit_to_app, color: Colors.white),
            SizedBox(width: 8),
            Text("Exit Application", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExit() async {
    submissionOptions(
      context,
      "Are you sure you want to exit?",
      "Yes",
      "",
      "No",
      approvePress: _exitApp,
      editPress: () {},
      disapprovePress: () {},
    );
  }

  Future<void> _exitApp() async {
    await DBHelper.updateLog("out", "0");

    if (Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 500), () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      });
    } else if (Platform.isIOS) {
      // iOS exit handling
    }
  }
}