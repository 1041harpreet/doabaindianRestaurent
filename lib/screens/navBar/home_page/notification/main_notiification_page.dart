import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';

import 'detail_notification.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppConfig.primaryColor),
      backgroundColor: AppConfig.secmainColor,
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
        return notificationItem(context);
      },)
    );
  }
}
