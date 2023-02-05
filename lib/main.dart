import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/screens/auth/splash_screen.dart';
import 'package:restaurent.app/services/notification_service/notification.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await NotificationController.initializeLocalNotifications(debug: true);
  await NotificationController.getInitialNotificationAction();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    criticalAlert: false,
    announcement: false,
    provisional: false,
    carPlay: false,
    badge: true,
    alert: true,
    sound: true,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerStatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // bool hasInterNetConnection = false;

  @override
  initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: AppConfig.secmainColor,
      statusBarBrightness: Brightness.dark,
    ));
    return GetMaterialApp(
      title: "DOABA INDIAN RESTAURANT",
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
