import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidChannel = AndroidNotificationChannel(
      'jci_referrals',
      'JCI Referrals',
      importance: Importance.max,
      playSound: true,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"),
            iOS: DarwinInitializationSettings(
              // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            ));
    _notificationsPlugin.initialize(
      initializationSettings,

      // onSelectNotification: onSelectNotification,
    );
  }

  // static Future<dynamic> onDidReceiveLocalNotification(
  //     int id, title, body, payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  // }

  static void display({var message, var progress = 0, var name}) async {
    try {
      if (message != null) {
        final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "JciMetro", //id
            "JciMetro channel",

            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
        );

        var firebaseNotification = message.notification;
        if (firebaseNotification != null) {
          await _notificationsPlugin.show(
            message.hashCode,
            firebaseNotification.title,
            firebaseNotification.body,
            notificationDetails,
          );
        }
      } else {
        final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "JciMetro", //id
            "JciMetro channel",

            importance: Importance.max,
            priority: Priority.high,
            showProgress: true,
            maxProgress: 100,
            progress: progress,
            playSound: true,
          ),
        );

        await _notificationsPlugin.show(0, "Download Complete",
            "File downloaded in download folder", notificationDetails,
            payload: name);
      }
    } on Exception {
      // print(e);
    }
  }

  static Future<void> onSelectNotification(String? name) async {
    OpenFile.open("/storage/emulated/0/Download/$name");
  }
}
