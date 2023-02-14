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
import 'package:sentry_flutter/sentry_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  Future<void> main() async {
    await SentryFlutter.init(
          (options) {
        options.dsn =
        'https://7e129e50e9124fe7a933b0c27100af0a@o4504620160909312.ingest.sentry.io/4504648509161472';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => runApp( ProviderScope(child: MyApp())),
    );

    // or define SENTRY_DSN via Dart environment variable (--dart-define)
  }

  main();
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
