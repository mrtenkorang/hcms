import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hcms_revived2/controller/cache_service/cache_service.dart';
import 'package:hcms_revived2/controller/constants/urls.dart';
import 'package:hcms_revived2/controller/models/user_model.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _sendTokenToBackend();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Handle when app is opened from terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logNotificationTap(message);
    });

    // Handle initial message when app is opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _logNotificationTap(initialMessage);
    }
  }

  /// Send token to backend (once per device)
  Future<void> _sendTokenToBackend() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      debugPrint("FCM Token: $token");
      final cache = await CacheService.getInstance();
      UserModel? userInfo = await cache.getUserInfo();
      debugPrint("User ID: ${userInfo!.id}");

      final response = await http.post(
        Uri.parse('${URLS.baseUrl}${URLS.fcmTokenURL}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userid': userInfo.id,
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("Token successfully sent to backend");
      } else {
        debugPrint("Failed to send token. Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error sending token to backend: $e");
    }
  }

  String _getPlatform() {
    return 'android';
  }

  /// Handle incoming messages
  Future<void> _handleMessage(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final data = message.data;

      final driverName = data['driver_name'] ?? 'Unknown Driver';
      final truckNumber = data['truck_number'] ?? 'Unknown Truck';
      final arrivalTime = data['arrival_date_time'] ?? 'Unknown Time';

      // Save to DB
      // await NotificationsQueries().insertNotification(
      //   LocalNotificationModel(
      //     title: notification?.title ?? 'New Notification',
      //     body: notification?.body ?? '',
      //     driverName: driverName,
      //     truckNumber: truckNumber,
      //     arrivalDateTime: arrivalTime,
      //     createdAt: DateTime.now(),
      //   ),
      // );

      // Firebase will automatically show the notification on Android
      // For iOS, make sure to include the notification payload
      debugPrint('Notification received: ${notification?.title}');
    } catch (e) {
      debugPrint('Error handling message: $e');
    }
  }

  void _logNotificationTap(RemoteMessage message) {
    debugPrint('📲 Notification tapped: ${message.data}');
    // add navigation logic here based on the message data
  }

  /// Subscribe to topics
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  /// Unsubscribe from topics
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }
}