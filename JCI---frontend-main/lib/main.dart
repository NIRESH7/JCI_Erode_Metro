import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:jci/firebase_options.dart';
import 'package:jci/services/local_notification_service.dart';
import 'package:jci/referral/services/auth_service.dart';
import 'package:jci/utils/app_navigation.dart';
import 'package:jci/utils/routes.dart';
import 'package:jci/widgets/drawer.dart';

import 'utils/screens.dart';

class _SmoothScrollBehavior extends MaterialScrollBehavior {
  const _SmoothScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}

@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print("Handling a background message: ${message.data}");
    print("Handling a background message: ${message.notification}");
  } // LocalNotificationService.display(message);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runApp(
    GetMaterialApp(
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
      getPages: Routes.list,
      defaultTransition: AppNavigation.defaultTransition,
      transitionDuration: AppNavigation.duration,
      scrollBehavior: const _SmoothScrollBehavior(),
      theme: ThemeData(
        fontFamily: "pop-reg",
        useMaterial3: false,
      ),
    ),
  );

  unawaited(_initServices());
}

Future<void> _initServices() async {
  try {
    await dotenv.load(fileName: kReleaseMode ? '.env.production' : '.env');
  } catch (e) {
    if (kReleaseMode) {
      debugPrint('FATAL: Could not load production environment: $e');
    }
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize();

    _initFirebaseMessaging();

    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("Handling a background message: ${message.messageId}");
        print("Handling a background message: ${message.data}");
        print("Handling a background message: ${message.notification}");
      } //
      var firebaseNotification = message.notification;
      if (firebaseNotification != null) {
        LocalNotificationService.display(message: message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationNav(message);
    });
  }

  Future<void> _initFirebaseMessaging() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    try {
      final message = await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) _handleNotificationNav(message);
    } catch (e) {
      if (kDebugMode) print('FCM getInitialMessage failed: $e');
    }

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await AuthService.registerFcmToken(token);
    } catch (e) {
      if (kDebugMode) print('FCM getToken failed: $e');
    }

    try {
      await FirebaseMessaging.instance.subscribeToTopic('events');
    } catch (e) {
      if (kDebugMode) print('FCM subscribeToTopic failed: $e');
    }
  }

  void _handleNotificationNav(RemoteMessage message) {
    var route = message.data['route'];
    var event_id = message.data['event_id'];
    var referral_id = message.data['referral_id'];
    if (route == "referral" && referral_id != null) {
      Get.toNamed("/referral-detail", arguments: referral_id);
    } else if (route == "events") {
      Get.toNamed("/eventsdetails", arguments: ["$event_id"]);
    } else if (route == "birthday") {
      Get.toNamed("/birthday");
    } else if (route != null) {
      Get.toNamed('/$route');
    }
  }

  // void initDynamicLink() async {
  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   var deepLink = data!.link;
  //   print('$deepLink');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
      drawer: MyDrawer(),
    );
  }
}
