import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent.app/config/config.dart';

import 'notification_setting_provider.dart';

class NotificationSetting extends ConsumerWidget {
  const NotificationSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationprovider = ref.watch(notificationSettingProvider);
    return Scaffold(
        backgroundColor: AppConfig.secmainColor,
        appBar: AppBar(
          backgroundColor: AppConfig.primaryColor,
          title: Text("Notification Setting"),
        ),
        body: ReactiveForm(
          formGroup: notificationprovider.notificationForm,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Updates from DOABA INDIAN RESTAURANT",
                      style: AppConfig.blacktext),
                  ReactiveSwitch(
                    activeColor: MaterialStateColor.resolveWith(
                        (states) => Colors.green),
                    formControlName: 'updates',
                    inactiveThumbColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black26),
                    inactiveTrackColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.shade500),
                    onChanged: (control) {
                      print(control);
                    },
                  )
                ],
              ),
            ]),
          ),
        ));
  }
}
