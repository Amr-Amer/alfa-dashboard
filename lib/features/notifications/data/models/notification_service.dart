import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode and FlutterError.reportError

// Create a FlutterLocalNotificationsPlugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Define a notification channel for Android (required for Android 8.0+)
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background Handler: Started.');
  }
  try {
    await Firebase.initializeApp(); // Initialize Firebase for background messages
    if (kDebugMode) {
      print('Background Handler: Firebase App initialized successfully.');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Background Handler: Error initializing Firebase App: $e');
    }
    if (kDebugMode) {
      FlutterError.reportError(FlutterErrorDetails(exception: e, stack: StackTrace.current));
    }
  }
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
  // For background messages, you might also want to show a local notification
  if (message.notification != null) {
    flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@drawable/part_logo',
        ),
      ),
    );
  }
}

// Top-level function for handling background notification responses
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  if (kDebugMode) {
    print('Background notification tapped: ${notificationResponse.payload}');
  }
  // Handle background navigation here if needed
  // This function runs in its own isolate, so you cannot directly access BuildContext or Cubits.
  // For navigation, you typically use a global navigator key or a dedicated navigation service.
}

Future<void> initializeLocalNotifications() async {
  if (kDebugMode) {
    print('Local Notifications: Initializing...');
  }
  // Use @drawable/logo for Android initialization settings as well if you want it to be the default icon
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/part_logo');

  const DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      // This handler is for when the app is in the foreground/resumed
      if (kDebugMode) {
        print('Notification tapped (Foreground): ${notificationResponse.payload}');
      }
      // Handle navigation here if needed, you have context here
    },
    onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse, // Reference the top-level function
  );
  if (kDebugMode) {
    print('Local Notifications: Initialization complete.');
  }
}

Future<void> setupFirebaseMessaging() async {
  if (kDebugMode) {
    print('FCM Setup: Starting Firebase Messaging setup.');
  }
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (kDebugMode) {
      print('FCM Setup: FirebaseMessaging.instance obtained.');
    }

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('FCM Setup: User granted permission for notifications');
      }
      String? token = await messaging.getToken();
      if (kDebugMode) {
        print('FCM Setup: FCM Token: $token');
      }
      // TODO: Send the Token to the Backend (Firestore) from HomePage after user login
    } else {
      if (kDebugMode) {
        print('FCM Setup: User declined or has not accepted permission');
      }
    }

    // Listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('FCM Setup: Got a message whilst in the foreground!');
        print('FCM Setup: Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print('FCM Setup: Message also contained a notification: ${message.notification!.title} / ${message.notification!.body}');
        }
        // Display the notification using flutter_local_notifications
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@drawable/part_logo',
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: message.data['screen'],
        );
        if (kDebugMode) {
          print('FCM Setup: Local notification shown for foreground message.');
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('FCM Setup: A new onMessageOpenedApp event was published!');
      }
      if (message.data['screen'] != null) {
        // Handle navigation here
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print('FCM Setup: Error during FCM setup: $e');
    }
    if (kDebugMode) {
      FlutterError.reportError(FlutterErrorDetails(exception: e, stack: StackTrace.current));
    }
  }
}
