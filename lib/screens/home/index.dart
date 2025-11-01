import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/constants/urls.dart';
import 'package:hcms_revived2/controller/models/farmer_from_server.dart';
import 'package:hcms_revived2/controller/models/user_model.dart';
import 'package:hcms_revived2/controller/repos/farmer_from_server_repo.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/screens/Treespeciescatalogue/speciesgallery.dart';
import 'package:hcms_revived2/screens/farmregistration/farmer_list/farmer_list_screen.dart';
import 'package:hcms_revived2/screens/home/auth/usersingin/signin.dart';
import 'package:hcms_revived2/screens/home/components/options.dart';
import 'package:hcms_revived2/screens/sync/sync_page.dart';
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

class _IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  // Services
  // final FirebaseTokenService _firebaseTokenService = FirebaseTokenService();
  // final UserRatingService _userRatingService = UserRatingService();
  // final UpdateTreeFarmerList _updateTreeFarmerList = UpdateTreeFarmerList();

  // State variables
  // String? _displayName;
  String? _userRate;
  bool? _ratingInitRun;
  int? _index;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserModel? _user;

  getUserDetails() async {
    final cacheService = await CacheService.getInstance();
    _user = await cacheService.getUserInfo();
  }

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize everything in sequence
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      getUserDetails();
      // _initializeData();
      // _initializeFirebase();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Firebase messaging handlers
  // Future<void> _firebaseMessagingBackgroundHandler(
  //   RemoteMessage message,
  // ) async {
  //   final notification = PushNotification(
  //     title: message.notification?.title,
  //     body: message.notification?.body,
  //     dataTitle: message.data['title'],
  //     dataBody: message.data['body'],
  //   );
  //
  //   final title = notification.dataTitle ?? notification.title;
  //   final body = notification.dataBody ?? notification.body;
  //
  //   Timer(const Duration(seconds: 2), () {
  //     if (title == "News/Articles") {
  //       Provider.of<NewsAndArticlesProvider>(
  //         context,
  //         listen: false,
  //       ).addNewsArticles(title.toString(), body.toString());
  //     } else {
  //       Provider.of<TrainingWorkShopsProvider>(
  //         context,
  //         listen: false,
  //       ).addTrainingsWorkshops(title.toString(), body.toString());
  //     }
  //   });
  // }

  // Future<void> _firebaseMessagingHandler(RemoteMessage message) async {
  //   await Firebase.initializeApp();
  //
  //   final notification = PushNotification(
  //     title: message.notification?.title,
  //     body: message.notification?.body,
  //     dataTitle: message.data['title'],
  //     dataBody: message.data['body'],
  //   );
  //
  //   final title = notification.dataTitle ?? notification.title;
  //   final body = notification.dataBody ?? notification.body;
  //
  //   _showNotifDialogue(title, body);
  //   _addNotificationToProvider(title, body);
  // }
  //
  // Future<void> _firebaseMessagingHandlerOnAppOpen(RemoteMessage message) async {
  //   await Firebase.initializeApp();
  //
  //   final notification = PushNotification(
  //     title: message.notification?.title,
  //     body: message.notification?.body,
  //     dataTitle: message.data['title'],
  //     dataBody: message.data['body'],
  //   );
  //
  //   final title = notification.dataTitle ?? notification.title;
  //   final body = notification.dataBody ?? notification.body;
  //
  //   _showNotifDialogue(title, body);
  //   _addNotificationToProvider(title, body);
  // }

  // void _addNotificationToProvider(String? title, String? body) {
  //   Timer(const Duration(seconds: 2), () {
  //     if (!mounted) return;
  //
  //     if (title == "News/Articles") {
  //       Provider.of<NewsAndArticlesProvider>(
  //         context,
  //         listen: false,
  //       ).addNewsArticles(title.toString(), body.toString());
  //     } else {
  //       Provider.of<TrainingWorkShopsProvider>(
  //         context,
  //         listen: false,
  //       ).addTrainingsWorkshops(title.toString(), body.toString());
  //     }
  //   });
  // }

  // Database operations
  // Future<void> _getDisplayName() async {
  //   final db = await DBHelper.database();
  //   final result = await db.rawQuery('SELECT * FROM first_time_user LIMIT 1');
  //
  //   if (mounted) {
  //     setState(() {
  //       _displayName = result.isNotEmpty
  //           ? result[0]['displayName'].toString()
  //           : "Guest User";
  //     });
  //   }
  // }

  // Future<void> _initializeData() async {
  //   // await _getDisplayName();
  //
  //   if (widget.userContact != null) {
  //     regSP?.setString("userContact", widget.userContact!);
  //   }
  //
  //   _ratingInitRun = regSP?.getBool("ratinginitrun") ?? false;
  //   await _initializeUserRating();
  //
  //   _index = 0;
  //   // await _loadFarmerData();
  // }

  // Future<void> _initializeUserRating() async {
  //   final contact = widget.userContact ?? regSP?.getString("userContact");
  //   final rating = await _userRatingService.userRatingService(
  //     context,
  //     contact: contact,
  //   );
  //
  //   if (mounted) {
  //     setState(() {
  //       _userRate = rating.toString();
  //     });
  //
  //     if (_ratingInitRun == false) {
  //       userRatingDialogue(context, rating.toString());
  //     }
  //   }
  // }

  // Firebase initialization
  // Future<void> _initializeFirebase() async {
  //   await checkForInitialMessage();
  //
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   FirebaseMessaging.onMessageOpenedApp.listen(
  //     _firebaseMessagingHandlerOnAppOpen,
  //   );
  //   FirebaseMessaging.onMessage.listen(_firebaseMessagingHandler);
  // }
  //
  // Future<void> checkForInitialMessage() async {
  //   await Firebase.initializeApp();
  //   final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  //   // Initial message handling if needed
  // }
  //
  // void _showNotifDialogue(String? title, String? body) {
  //   showSimpleNotification(
  //     Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //           colors: [fPrimaryColour, fPrimaryColour.withOpacity(0.8)],
  //         ),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white.withOpacity(0.2),
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: const Icon(
  //                   Icons.notifications_active,
  //                   color: Colors.white,
  //                   size: 20,
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: Text(
  //                   title ?? 'Notification',
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             body ?? '',
  //             style: const TextStyle(color: Colors.white70, fontSize: 14),
  //             maxLines: 3,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ],
  //       ),
  //     ),
  //     duration: const Duration(seconds: 6),
  //     slideDismissDirection: DismissDirection.horizontal,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[50],
        drawer: _buildDrawer(),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header Section
                _buildHeaderSection(size),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Welcome Card
                        // _buildWelcomeCard(),

                        // const SizedBox(height: 24),
                        //
                        // // Options Grid
                        _buildOptionsGrid(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [fPrimaryColour.withOpacity(0.05), Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [fPrimaryColour, fPrimaryColour.withOpacity(0.8)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _user != null ?
                  Text(
                    "${_user!.fname ?? ''} ${_user!.sname ?? ''}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ):const SizedBox(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      _user != null ?
                      Text(
                        _user!.contactNumber ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ):const SizedBox(),
                    ],
                  ),
                  // const SizedBox(height: 12),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //     vertical: 6,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(0.2),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Icon(Icons.sync)
                  // ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // _buildDrawerItem(
                  //   icon: Icons.dashboard,
                  //   title: 'Dashboard',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  _buildDrawerItem(
                    icon: Icons.forest,
                    title: 'View Trees',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SpeciesGallery();
                          },
                        ),
                      );
                    },
                  ),
                  // _buildDrawerItem(
                  //   icon: Icons.campaign,
                  //   title: 'Notice Board',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) {
                  //           return NoticeBoard();
                  //         },
                  //       ),
                  //     );
                  //     // _showNoticeBoard();
                  //   },
                  // ),
                  const Divider(height: 32, indent: 16, endIndent: 16),
                  // _buildDrawerItem(
                  //   icon: Icons.settings,
                  //   title: 'Settings',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigate to Settings
                  //   },
                  // ),
                  // _buildDrawerItem(
                  //   icon: Icons.help_outline,
                  //   title: 'Help & Support',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigate to Help
                  //   },
                  // ),
                  // _buildDrawerItem(
                  //   icon: Icons.info_outline,
                  //   title: 'About',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     _showAboutDialog();
                  //   },
                  // ),

                  _buildDrawerItem(
                    icon: Icons.group,
                    title: 'View Farmers',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FarmerListScreen();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Exit Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFd81a60),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _handleExit();
                  },
                  icon: const Icon(Icons.exit_to_app, size: 20),
                  label: const Text(
                    "Log out",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: fPrimaryColour.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: fPrimaryColour, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildHeaderSection(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [fPrimaryColour, fPrimaryColour.withOpacity(0.9)],
        ),
        boxShadow: [
          BoxShadow(
            color: fPrimaryColour.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HCMS Dashboard',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                _user != null ?
                Text(
                  "${_user!.fname!} ${_user!.sname!}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ):const SizedBox(),
              ],
            ),
          ),
          _buildSyncBadge(),
        ],
      ),
    );
  }

  Widget _buildSyncBadge() {
    return InkWell(
      onTap: (){
        Get.to(() => SyncPage());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        ),
        child: Icon(
          Icons.sync,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 3,
      shadowColor: fPrimaryColour.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              fPrimaryColour.withOpacity(0.1),
              Colors.white,
              fPrimaryColour.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(14),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [fPrimaryColour, fPrimaryColour.withOpacity(0.7)],
                //     ),
                //     borderRadius: BorderRadius.circular(16),
                //     boxShadow: [
                //       BoxShadow(
                //         color: fPrimaryColour.withOpacity(0.3),
                //         blurRadius: 8,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   child: const Icon(
                //     Icons.agriculture,
                //     color: Colors.white,
                //     size: 28,
                //   ),
                // ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Agriculture Monitoring',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: fPrimaryColour,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: fPrimaryColour, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Manage your monitoring activities and access farmer data efficiently.',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 4),
        //   child: Row(
        //     children: [
        //       Container(
        //         width: 4,
        //         height: 24,
        //         decoration: BoxDecoration(
        //           color: fPrimaryColour,
        //           borderRadius: BorderRadius.circular(2),
        //         ),
        //       ),
        //       const SizedBox(width: 12),
        //       const Text(
        //         'Quick Actions',
        //         style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.black87,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 16),
        const Options(),
      ],
    );
  }

  void _showNoticeBoard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [fPrimaryColour, fPrimaryColour.withOpacity(0.8)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.campaign,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Notice Board',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Consumer2<NewsAndArticlesProvider, TrainingWorkShopsProvider>(
            //     builder: (context, newsProvider, trainingProvider, child) {
            //       final newsArticles = newsProvider.newsArticles;
            //       final trainings = trainingProvider.trainingsWorkshops;
            //       final allNotifications = [...newsArticles, ...trainings];
            //
            //       if (allNotifications.isEmpty) {
            //         return Center(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Icon(
            //                 Icons.notifications_off_outlined,
            //                 size: 80,
            //                 color: Colors.grey[300],
            //               ),
            //               const SizedBox(height: 16),
            //               Text(
            //                 'No notifications yet',
            //                 style: TextStyle(
            //                   fontSize: 18,
            //                   color: Colors.grey[600],
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //               const SizedBox(height: 8),
            //               Text(
            //                 'New updates will appear here',
            //                 style: TextStyle(
            //                   fontSize: 14,
            //                   color: Colors.grey[400],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       }
            //
            //       return ListView.builder(
            //         padding: const EdgeInsets.all(16),
            //         itemCount: allNotifications.length,
            //         itemBuilder: (context, index) {
            //           final notification = allNotifications[index];
            //           final isNews = newsArticles.contains(notification);
            //
            //           return Card(
            //             margin: const EdgeInsets.only(bottom: 12),
            //             elevation: 2,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(16),
            //             ),
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(16),
            //                 gradient: LinearGradient(
            //                   begin: Alignment.topLeft,
            //                   end: Alignment.bottomRight,
            //                   colors: isNews
            //                       ? [Colors.blue[50]!, Colors.white]
            //                       : [Colors.orange[50]!, Colors.white],
            //                 ),
            //               ),
            //               child: ListTile(
            //                 contentPadding: const EdgeInsets.all(16),
            //                 leading: Container(
            //                   padding: const EdgeInsets.all(12),
            //                   decoration: BoxDecoration(
            //                     color: isNews
            //                         ? Colors.blue.withOpacity(0.1)
            //                         : Colors.orange.withOpacity(0.1),
            //                     borderRadius: BorderRadius.circular(12),
            //                   ),
            //                   child: Icon(
            //                     isNews ? Icons.article : Icons.school,
            //                     color: isNews ? Colors.blue : Colors.orange,
            //                     size: 28,
            //                   ),
            //                 ),
            //                 title: Text(
            //                   isNews ? 'News/Article' : 'Training/Workshop',
            //                   style: TextStyle(
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 16,
            //                     color: isNews ? Colors.blue[700] : Colors.orange[700],
            //                   ),
            //                 ),
            //                 subtitle: Padding(
            //                   padding: const EdgeInsets.only(top: 8),
            //                   child: Text(
            //                     notification.toString(),
            //                     style: TextStyle(
            //                       color: Colors.grey[700],
            //                       fontSize: 14,
            //                       height: 1.4,
            //                     ),
            //                   ),
            //                 ),
            //                 trailing: Icon(
            //                   Icons.chevron_right,
            //                   color: Colors.grey[400],
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: fPrimaryColour.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.info, color: fPrimaryColour, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('About HCMS'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horticultural Crop Management System',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text('Version 2.0', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            Text(
              'A comprehensive solution for managing agricultural monitoring activities and farmer data.',
              style: TextStyle(color: Colors.grey[700], height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: fPrimaryColour)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExit() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text("Exit Application"),
            ],
          ),
          content: const Text(
            "Are you sure you want to exit the application?",
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFd81a60),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: _exitApp,
              child: const Text("Exit", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exitApp() async {
    // await DBHelper.updateLog("out", "0");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return UserSignIn();
        },
      ),
      (route) => false,
    );

    // if (Platform.isAndroid) {
    //   Future.delayed(const Duration(milliseconds: 500), () {
    //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //   });
    // } else if (Platform.isIOS) {
    //   // iOS exit handling
    // }
  }
}
