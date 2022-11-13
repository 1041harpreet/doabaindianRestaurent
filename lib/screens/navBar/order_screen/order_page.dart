import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.secmainColor,
      body: Center(child: Text("No order yet",style: TextStyle(color: Colors.black)),),
    );
  }
}
