import 'dart:convert';

import 'package:http/http.dart';

class FirebaseNotification {
  static final Client client = Client();

  static const String serverKey =
      "AAAAKm20M4M:APA91bGpF0bd2S-uC4JL6wQZ0cHyTgIFQOYmI2aWlGIoU2qwlzS41pHV-HlRldx6FRPFC0PbC0Njx51Auq1EMd0STXl9cvCNoN05vtnJpBwsf8yTvMlgEPYiNNtdJ6YPHouVUL8eaefJ";

  static Future<Response> sendToAll({
    required String title,
    required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic({
    required String title,
    required String body,
    required String topic,
  }) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    required String title,
    required String body,
    required String fcmToken,
  }) =>
      client.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          // 'view': 'create_post',
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key = $serverKey',
        },
      );
}
