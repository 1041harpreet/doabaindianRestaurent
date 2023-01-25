import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent.app/provider/auth_provider.dart';
import 'package:restaurent.app/widgets/toast_service.dart';

import '../config/const.dart';
import '../model/notification_model.dart';

class NotificationService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // String email;

  NotificationService();

  bool loading = false;

  changeloading(value) {
    loading = value;
    notifyListeners();
  }

  //add to user notification page
  addToNotification(
      String orderid, String email, bool status, tax, total, date)async {
    try {
      var ref = await _firestore
          .collection('notifications')
          .doc(email)
          .collection(email)
          .doc(orderid)
          .set({
        'orderID': orderid,
        "email": email,
        "status": status,
        "tax": tax,
        "total": total,
        "date": date
      }).then((value) {
        print('added');
      });
    } catch (e) {
      print(e);
    }
  }

  //get notification of user
  List notificationList = [];

  getFirstNotification() async {
    changeloading(true);
    try {
      var ref = await _firestore
          .collection('notifications')
          .doc(Const.email)
          .collection(Const.email)
          .orderBy('date', descending: true)
          .limit(12)
          .get();
      notificationList =
          ref.docs.map((e) => NotificationItem.fromJson(e.data())).toList();
    } catch (e) {
      print(e);
    } finally {
      changeloading(false);
    }
  }

  fetchNextNotifications(context) async {
    try {
      var ref = await _firestore
          .collection('notifications')
          .doc(Const.email)
          .collection(Const.email)
          .orderBy('date', descending: true)
          .startAt(notificationList[notificationList.length - 1])
          .limit(10)
          .get();
      notificationList =
          ref.docs.map((e) => NotificationItem.fromJson(e.data())).toList();
    } on SocketException {
      showErrorToast(message: "No Internet Connection", context: context);
    } catch (e) {
      print(e.toString());
      showErrorToast(message: "Something wrong", context: context);
    }
  }

  deleteToken() async {
    try {
      await _firestore.collection('token').doc(Const.email).delete();
    } catch (e) {
      print(e);
    }
  }
}

final notificationProvider = ChangeNotifierProvider((ref) {
  // final authprovider = ref.watch(authProvider);
  return NotificationService();
});
