import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingService extends ChangeNotifier {
  FormGroup notificationForm = FormGroup({
    "updates": FormControl<bool>(validators: [Validators.required]),
  });

  FormGroup deleteAccountForm = FormGroup({
    "current": FormControl(validators: [Validators.required]),
  });

  //updates notification setting
  subscribeNotification() async {
    try {
      await AwesomeNotificationsFcm().subscribeToTopic('all');
    } catch (e) {
      print(e);
    }
  }

  unSubscribeNotification() async {
    try {
      await AwesomeNotificationsFcm().unsubscribeToTopic('all');
    } catch (e) {
      print(e);
    }
  }

  //set value of update in local

  writeValue(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('update', value);
  }

  readValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = await prefs.getBool('update');
    return value;
  }
}

final notificationSettingProvider = ChangeNotifierProvider((ref) {
  var state = NotificationSettingService();
  return state;
});
