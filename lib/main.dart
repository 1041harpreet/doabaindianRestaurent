import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/screens/auth/login_screen.dart';
import 'package:restaurent_app/screens/auth/splash_screen.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.data}");
  // var mess = message.data;
  // NotificationService().showNotification(mess['title'], mess['bill']);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'doaba channel',
            channelName: 'doaba notifications',
            channelDescription: 'Notification channel for basic tests',
            // defaultColor: Constant.primaryColor,
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            criticalAlerts: true,
            onlyAlertOnce: true)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((event) {
    print("onmessage");
    var mess = event.data;
    // NotificationService().showNotification(mess['title'], mess['bill']);
  });
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>  ProviderScope(
        child: MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            color: AppConfig.primaryColor,
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: MyApp()),
      ), // Wrap your app
    ),

  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  request() async {
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
      request();
    }
  }

  initState() {
    print("connection check");
    // getConnectivity();
    // request();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });
    super.initState();
    // AwesomeNotifications().createdStream.listen((notification) {
    //   print("created");
    // });
    //
    // AwesomeNotifications().actionStream.listen((notification) {
    //   if (notification.channelKey == 'basic_channel' && Platform.isAndroid) {
    //     print('action');
    //   }
    // });

  }

  // late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  // getConnectivity() =>
  //     subscription = Connectivity().onConnectivityChanged.listen(
  //           (ConnectivityResult result) async {
  //         isDeviceConnected = await DataConnectionChecker().hasConnection;
  //         if (!isDeviceConnected && isAlertSet == false) {
  //           showErrorToast(context: context, message: "No Internet Connection");
  //           setState(() => isAlertSet = true);
  //         }
  //       },
  //     );

  @override
  void dispose() {

    // AwesomeNotifications().actionSink.close();
    // AwesomeNotifications().createdSink.close();
    // subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: "DOABA INDIAN RESTAURANT",
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
