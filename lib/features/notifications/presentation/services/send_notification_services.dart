import 'dart:convert';
import 'package:alfa_dashboard/features/notifications/presentation/services/product_details_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<String> getAccessToken() async {
  final jsonString = await rootBundle.loadString(
    'assets/notifications/alfa7-fddee-ecbce92685c6.json',
  );

  final accountCredentials =
  auth.ServiceAccountCredentials.fromJson(jsonString);

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final client = await auth.clientViaServiceAccount(accountCredentials, scopes);

  return client.credentials.accessToken.data;
}

Future<void> sendNotification(
    {required String token,
      required String title,
      required String body,
      required Map<String, dynamic> data}) async {
  final String accessToken = await getAccessToken();
  final String fcmUrl =
      'https://fcm.googleapis.com/v1/projects/alfa7-fddee/messages:send';

  final response = await http.post(
    Uri.parse(fcmUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(<String, dynamic>{
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': data, // Add custom data here

        'android': {
          'notification': {
            "sound": "custom_sound",
            'click_action':
            'FLUTTER_NOTIFICATION_CLICK', // Required for tapping to trigger response
            'channel_id': 'high_importance_channel'
          },
        },
        'apns': {
          'payload': {
            'aps': {"sound": "custom_sound.caf", 'content-available': 1},
          },
        },
      },
    }),
  );

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print('Notification sent successfully');
    }
  } else {
    if (kDebugMode) {
      print('Failed to send notification: ${response.body}');
    }
  }
}

Future<void> sendNotificationToAll({
  required String title,
  required String body,
  Map<String, dynamic>? data,
}) async {
  try {
    final String accessToken = await getAccessToken();
    const String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/alfa7-fddee/messages:send';

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{
        'message': {
          'topic': 'all',
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
          'android': {
            'notification': {
              "sound": "custom_sound",
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'channel_id': 'high_importance_channel',
            },
          },
          'apns': {
            'payload': {
              'aps': {"sound": "custom_sound.caf", 'content-available': 1},
            },
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('✅ Notification sent to all users successfully');
      }
    } else {
      if (kDebugMode) {
        print('❌ Failed to send notification: ${response.body}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Error sending notification to all: $e');
    }
  }
}


void handleNotification(BuildContext context, Map<String, dynamic> data) {
  String route = data['route'];
  String id = data['id'];

  if (route == '/main') {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(productId: id)),
    );
  }
}