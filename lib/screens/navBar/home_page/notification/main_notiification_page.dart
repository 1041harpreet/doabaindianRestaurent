import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.secmainColor,
      body: Center(child: Text("no Notification ",style: AppConfig.blackTitle,)),);
  }
}
