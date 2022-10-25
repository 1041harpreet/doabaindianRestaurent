import 'package:flutter/material.dart';

class AppConfig {
  static Color primaryColor = const Color(0xff12A278);
  static Color greyColor = const Color(0xff9d9ea1);
  static Color lightYellow = const Color(0xffFFFCBF);
  static Color secmainColor = const Color(0xffF5F5F5);


  static ButtonStyle flatButtonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
  static InputDecoration noBorder = InputDecoration(
    border: InputBorder.none,
    labelStyle: const TextStyle(backgroundColor: Colors.transparent),
    label: Column(children: const [Text('Email')]),
  );
  static BoxDecoration greyBorder = BoxDecoration(
      border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(8));
  static RoundedRectangleBorder roundedBottomSheet = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(16),
      topLeft: Radius.circular(16),
    ),
  );
  static ButtonStyle yellowBtn = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(AppConfig.lightYellow),
    elevation: MaterialStateProperty.all(0),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );


  //typography
  static TextStyle textH1 = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle textH2 = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle textSmall = const TextStyle(fontSize: 10);
  static TextStyle greySmallText = TextStyle(fontSize: 10, color: AppConfig.greyColor);
  static TextStyle blackTitle = const TextStyle(color: Colors.black);
  static var t26 = const TextStyle(color: Colors.black, fontSize: 26);
}
