import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/provider/auth_provider.dart';

import '../model/notification_model.dart';

class NotificationService extends ChangeNotifier{
  String email;
  NotificationService(this.email);
  bool loading=false;
  changeloading(value){
    loading=value;
    notifyListeners();
  }
  List notificationList=[];
  getNotification()async{
    changeloading(true);
    try{
      var ref=await FirebaseFirestore.instance.collection('notifications').doc(email).collection(email).orderBy('date',descending: true).limit(10).get();
      notificationList=ref.docs.map((e) => NotificationItem.fromJson(e.data())).toList();
    }
    catch(e){
      print(e);
    }
    finally{
    changeloading(false);
    }
  }
}
final notificationProvider=ChangeNotifierProvider((ref) {
  final authprovider=ref.watch(authProvider);
  return NotificationService(authprovider.user.email);
});