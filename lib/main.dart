
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:restaurent_app/screens/auth/splash_screen.dart';
import 'package:restaurent_app/services/notification_service/notification.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationController.initializeLocalNotifications(debug: true);
  await NotificationController.getInitialNotificationAction();

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.dark,
    ));
    return
      GetMaterialApp(
      title: "DOABA INDIAN RESTAURANT",
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home:  const SplashScreen(),
    );
  }
}
