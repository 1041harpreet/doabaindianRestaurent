import 'package:flutter/material.dart';

class Const {
//  final String clientID="AV_19mRnmAp7FA-Rz6-WNt24v0UtHZ_tQ6IteKmaSA06448NPi5qaRdCMHSMLMSVIqOxwqI_rC9IznWt";
//  final String secret="AV_19mRnmAp7FA-Rz6-WNt24v0UtHZ_tQ6IteKmaSA06448NPi5qaRdCMHSMLMSVIqOxwqI_rC9IznWt";
  final String token = "sandbox_w3q96pkh_cs7spj4bw7s5t3ts";

  final String clientID =
      "AZbHMGz0SUcWEehZTTWQHkXbboJsK6yZ3BcG2BwAlk0zZhtgvrgfsA8SF6L1aZT5fNaLBeBU6CfL8s9z";
  final String secret =
      "EPN4MdZaYRZiTd-Fn-c3SXvHt9BAo0MmiLtFG4OY_dZWZWE3Xw_S0QtNy6M5ntZLmyzJU9i9mTogsrxk";

  var key =
      "AAAAD0_2908:APA91bGdGFnWuTIGHdukayVhDlcnmAASN2terfMf0SGaT-cmCEPqyWPqPdx2GnWqSDQgaLpduEAgRdZL-s1W8LA9CGXti-CIuF4bizvNwiwEoqGymG3WJVb6a_rjcvyYnONhnIsiVEBv";

  size(context) {
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
  }

  static String adminMail = '';
  static String devMail = '';
  static String adminPhone = '';
  static String phone = '';
  static String username = '';
  static String role = 'user';
  static String img = '';
  static String email = '';
}
