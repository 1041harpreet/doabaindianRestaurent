import 'dart:io';

import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent.app/provider/auth_provider.dart';
import 'package:restaurent.app/widgets/toast_service.dart';

import '../model/notification_model.dart';

class NotificationService extends ChangeNotifier{
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  String email;
  NotificationService(this.email);
  bool loading=false;
  changeloading(value){
    loading=value;
    notifyListeners();
  }
  //add to user notification page
  addToNotification(String orderid,String email,bool status,tax,total,date){
    try{
      var ref=_firestore.collection('notifications').doc(email).collection(email).doc(orderid).set({
        'orderID':orderid,
        "email":email,
        "status":status,
        "tax":tax,
        "total":total,
        "date":date
      }).then((value) {
        print('added');
      });
    }catch(e){
      print(e);
    }
  }
  //get notification of user
  List notificationList=[];
  getFirstNotification()async{
    changeloading(true);
    try{
      var ref=await _firestore.collection('notifications').doc(email).collection(email).orderBy('date',descending: true).limit(12).get();
      notificationList=ref.docs.map((e) => NotificationItem.fromJson(e.data())).toList();
    }
    catch(e){
      print(e);
    }
    finally{
    changeloading(false);
    }
  }
  fetchNextNotifications(context) async {

    try {
      var ref=await _firestore.collection('notifications').doc(email).collection(email).orderBy('date',descending: true).startAt(notificationList[notificationList.length - 1])
          .limit(10)
          .get();
      notificationList=ref.docs.map((e) => NotificationItem.fromJson(e.data())).toList();
    } on SocketException {
      showErrorToast(message: "No Internet Connection",context: context);
    } catch (e) {
      print(e.toString());
      showErrorToast(message: "Something wrong",context: context);

    }
  }

  deleteToken()async{
    try{
      await _firestore.collection('token').doc(email).delete();
    }catch(e){
      print(e);
    }
  }

}
final notificationProvider=ChangeNotifierProvider((ref) {
  final authprovider=ref.watch(authProvider);
  return NotificationService(authprovider.user.email);
});