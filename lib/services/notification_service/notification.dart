// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
// class NotificationService{
//   static Future<void> initializeLocalNotifications(
//       {required bool debug}) async {
//     await AwesomeNotifications().initialize(
//         'resource://drawable/res_app_icon',
//         [
//           NotificationChannel(
//               channelKey: 'doaba channel',
//               channelName: 'doaba channel',
//               channelDescription: 'Notification for doaba',
//               playSound: true,
//               importance: NotificationImportance.High,
//               defaultPrivacy: NotificationPrivacy.Private,
//               defaultColor: Colors.deepPurple,
//               ledColor: Colors.deepPurple)
//         ],
//         debug: debug);
//
//     // Get initial notification action is optional
//     _instance.initialAction = await AwesomeNotifications()
//         .getInitialNotificationAction(removeFromActionEvents: false);
//   }
//   // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   //   print("Handling a background message: ${message.notification?.body}");
//   //   // var mess = message.data;
//   //   // NotificationService().showNotification(mess['title'], mess['bill']);
//   // }
//   // init() async{
//   //   await FirebaseMessaging.instance
//   //       .setForegroundNotificationPresentationOptions(
//   //     alert: true,
//   //     badge: true,
//   //     sound: true,
//   //   );
//   //   AwesomeNotifications().initialize(
//   //     // set the icon to null if you want to use the default app icon
//   //       'resource://drawable/res_app_icon',
//   //       [
//   //         NotificationChannel(
//   //             channelGroupKey: 'basic_channel_group',
//   //             channelKey: 'doaba channel',
//   //             channelName: 'doaba channel',
//   //             channelDescription: 'Notification channel for basic tests',
//   //             // defaultColor: Constant.primaryColor,
//   //             ledColor: Colors.white,
//   //             importance: NotificationImportance.Max,
//   //             channelShowBadge: true,
//   //             criticalAlerts: true,
//   //             onlyAlertOnce: true)
//   //       ],
//   //       // Channel groups are only visual and are not required
//   //       channelGroups: [
//   //         NotificationChannelGroup(
//   //             channelGroupKey: 'basic_channel_group',
//   //             channelGroupName: 'Basic group')
//   //       ],
//   //       debug: true);
//   //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   //   FirebaseMessaging.onMessage.listen((event) {
//   //     print("onmessage");
//   //     var mess = event.data;
//   //   });
//   // }
//   // request(context){
//   //   AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//   //     if (!isAllowed) {
//   //       showDialog(
//   //         context: context,
//   //         builder: (context) => AlertDialog(
//   //           title: const Text('Allow Notifications'),
//   //           content: const Text('Our app would like to send you notifications'),
//   //           actions: [
//   //             TextButton(
//   //               onPressed: () {
//   //                 Navigator.pop(context);
//   //               },
//   //               child: const Text(
//   //                 'Don\'t Allow',
//   //                 style: TextStyle(
//   //                   color: Colors.grey,
//   //                   fontSize: 18,
//   //                 ),
//   //               ),
//   //             ),
//   //             TextButton(
//   //                 onPressed: () => AwesomeNotifications()
//   //                     .requestPermissionToSendNotifications()
//   //                     .then((_) => Navigator.pop(context)),
//   //                 child: const Text(
//   //                   'Allow',
//   //                   style: TextStyle(
//   //                     color: Colors.teal,
//   //                     fontSize: 18,
//   //                     fontWeight: FontWeight.bold,
//   //                   ),
//   //                 ))
//   //           ],
//   //         ),
//   //       );
//   //     }
//   //   });
//   // }
//
//   var firebasetoken;
//
//   // gettoken( ) async {
//   //   await FirebaseMessaging.instance
//   //       .getToken()
//   //       .then((value) => firebasetoken = value).then((value) {
//   //     FirebaseMessaging.instance.subscribeToTopic("alluser");
//   //   });
//   //   print("Firebase token is $firebasetoken");
//   //   // addtoken(email);
//   // }
//   addtoken(email)async{
//     print("token is$firebasetoken");
//     await FirebaseFirestore.instance
//         .collection("tokens")
//         .doc(email)
//         .set({"token": firebasetoken});
//   }
//
//
// }

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/widgets/toast_service.dart';

import '../../main.dart';

class NotificationController extends ChangeNotifier {
  //   SINGLETON PATTERN


  static final NotificationController _instance =
  NotificationController._internal();

  factory NotificationController() {
    print('gettingbcounter');
    print(AwesomeNotifications().getGlobalBadgeCounter());
    return _instance;
  }

  NotificationController._internal();
  String _firebaseToken = '';
  String get firebaseToken => _firebaseToken;


  ReceivedAction? initialAction;

  //  INITIALIZATION METHODS

  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
        'resource://drawable/res_app_icon',
        [
          NotificationChannel(
              channelKey: 'doaba channel',
              channelName: 'doaba channel',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: AppConfig.primaryColor,
              ledColor: AppConfig.primaryColor)
        ],
        debug: debug);

    // Get initial notification action is optional
    _instance.initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  //    LOCAL NOTIFICATION EVENTS

  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction == null) return;

    print('Notification action launched app: $receivedAction');
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('on action recieved ');
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //     '/notification-page',
    //         (route) =>
    //     (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }

  //   REMOTE NOTIFICATION EVENTS
  /// Use this method to detect when a new fcm token is received
  static Future<void> myFcmTokenHandle(String token) async {
    debugPrint('Firebase Token:"$token"');
    _instance._firebaseToken = token;
    _instance.notifyListeners();
  }
  //    REQUEST NOTIFICATION PERMISSIONS
  static Future<bool> displayNotificationRationale(context) async {
    bool userAuthorized = false;
    // BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // LOCAL NOTIFICATION CREATION METHODS

  static Future<void> createNewNotification(context) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      isAllowed = await displayNotificationRationale(context);
    }

    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1, // -1 is replaced by a random number
            channelKey: 'doaba channel',
            title: 'Huston! The eagle has landed!',
            body:
            "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect',),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction
          ),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  static Future<void> resetBadge() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  //  REMOTE TOKEN REQUESTS

  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      print('fcm available');
      try {
        return await AwesomeNotificationsFcm().requestFirebaseAppToken();

      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return '';
  }
}