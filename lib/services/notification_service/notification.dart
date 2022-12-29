
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/config/const.dart';
import 'package:restaurent_app/widgets/toast_service.dart';

import '../../main.dart';

class NotificationController extends ChangeNotifier {

  static final NotificationController _instance =
  NotificationController._internal();
  factory NotificationController() {
    print('notification working');
    print(AwesomeNotifications().getGlobalBadgeCounter());
    return _instance;
  }

  NotificationController._internal();
  final String _firebaseToken = '';
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
              children: const [

                SizedBox(height: 20),
                Text(
                    'Allow Doaba Indian Restaurant to send you notifications!'),
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


  static Future<void> resetBadge() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  //  REMOTE TOKEN REQUESTS
  String token='';
   Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      print('fcm available');
      try {
        await AwesomeNotificationsFcm().subscribeToTopic('all');
        token=await AwesomeNotificationsFcm().requestFirebaseAppToken();
        print('token is '+token);
        return token;

      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return '';
  }
  var postUrl = "https://fcm.googleapis.com/fcm/send";
  Future<void> createNewNotification(title,body,String token) async {


    final data ={
      "to" : token,
      "mutable_content": true,
      "priority": "high",
      "notification": {
        "badge": 50,
        "title": title,
        "body": body
      },
      "data" : {
        "content": {
          "id": uniqueId(),
          "badge": 50,
          "channelKey": "doaba channel",
          "displayOnForeground": true,
          "notificationLayout": "BigPicture",
          "largeIcon": "https://firebasestorage.googleapis.com/v0/b/doabaindianrestaurent.appspot.com/o/logo%2Flogo-web.png?alt=media&token=32047992-37d9-40e7-8100-b25b02790d69",
          "bigPicture": "https://firebasestorage.googleapis.com/v0/b/doabaindianrestaurent.appspot.com/o/logo%2Flogo-web.png?alt=media&token=32047992-37d9-40e7-8100-b25b02790d69",
          "showWhen": true,
          "autoDismissible": true,
          "privacy": "Private",
          "payload": {
            "secret": "Awesome Notifications Rocks!"
          }
        },
        "actionButtons": [
          {
            "key": "DISMISS",
            "label": "Dismiss",
            "actionType": "DismissAction",
            "isDangerousOption": true,
            "autoDismissible": true
          }
        ]
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=${Const().key}'
    };

    BaseOptions options = BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 5000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);
      print(response.data);
      if (response.statusCode == 200) {
      } else {
        print('notification sending failed');
      }
    } catch (e) {
      print('exception $e');
    }
  }

}
int uniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}
