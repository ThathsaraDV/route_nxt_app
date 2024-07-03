import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:route_nxt/core/utility/service_locator.dart';

class NotificationPlugin {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late InitializationSettings initializationSettings;

  NotificationPlugin._() {
    init();
  }

  static Future init() async {
    flutterLocalNotificationsPlugin = sl.get<FlutterLocalNotificationsPlugin>();
    initializePlatformSpecifics();
  }

  static initializePlatformSpecifics() {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static void onNotificationTap(NotificationResponse response) {}
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class NotificationTemplate {
  final int id;
  final String title;
  final String body;
  final String payload;

  NotificationTemplate(this.id, this.title, this.body, this.payload);
}
