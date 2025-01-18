import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../utils/preference_manager.dart';
import '../../../utils/strings_constant.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future requestFirebasePermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static generateFirebaseToken() {
    _firebaseMessaging.getToken(vapidKey: StringConstants.vapidKey).then((value) {
      print('firebaseToken: $value');
      // Save the token to shared preferences or your backend here
      PreferenceManager.setData(PreferenceManager.firebaseToken, value);
    });
  }

  static Future localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open Notification');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, linux: initializationSettingsLinux);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // You can also request permission for notifications here (if needed for the platform)
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  // Handle Foreground notifications
  static void _handleForegroundMessage(RemoteMessage message) async {
    print("Received a foreground message: ${message.notification?.title} - ${message.notification?.body}");

    // Show local notification in the foreground
    await _showNotification(message);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    // Set up local notifications to show a notification when in foreground
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: 'notification_payload', // You can pass additional data here if needed
    );
  }

  // Set up Firebase messaging listeners for foreground and background notifications
  static Future<void> setUpFirebaseMessaging() async {
    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

    // Handle when the app is in the background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from background: ${message.notification?.title}");
      // Handle navigation or other actions when the app is opened from background
    });
  }

  static Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
    print("Received a background message: ${message.notification?.title} - ${message.notification?.body}");
    // Handle background message (e.g., show a local notification)
    await _showNotification(message);
  }
}
