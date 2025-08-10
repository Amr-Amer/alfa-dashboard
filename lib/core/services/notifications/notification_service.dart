import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final fcmToken = userDoc.data()?[FirebaseConstants.fcmToken];
        if (fcmToken != null && fcmToken.isNotEmpty) {
          await _sendFcmMessage(
            token: fcmToken,
            title: title,
            body: body,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification: $e');
      }
      throw Exception('Failed to send notification');
    }
  }

  Future<void> _sendFcmMessage({
    required String token,
    required String title,
    required String body,
  }) async {
    const String serverKey = 'AIzaSyAVxlS3v43b1wfFpMPJp8IKiPMdzs4_Fdg';

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(<String, dynamic>{
        'notification': <String, dynamic>{
          'title': title,
          'body': body,
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'withdraw_status_update',
          'id': '4116165',
        },
        'to': token,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('FCM request failed with status: ${response.statusCode}');
    }
  }
}