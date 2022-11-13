import 'package:flutter/material.dart';

class AppConfig {
  static Color primaryColor = const Color(0xffe5623e);
  static Color greyColor = const Color(0xfffafafa);
  static Color lightYellow = const Color(0xffFFFCBF);
  static Color secmainColor = const Color(0xfff3f3f3);
  static Color blackColor = const Color(0xff606060);


  //typography
  static TextStyle textH1 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle textH2 =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle textSmall = const TextStyle(fontSize: 10);
  TextStyle greySmallText = TextStyle(fontSize: 15, color: AppConfig.greyColor);
  static TextStyle blackTitle = const TextStyle(color: Colors.black);
  static var t26 = const TextStyle(color: Colors.black, fontSize: 26);
  static var catItem = const TextStyle(color: Colors.black54, fontSize: 18,fontWeight: FontWeight.bold);
}
