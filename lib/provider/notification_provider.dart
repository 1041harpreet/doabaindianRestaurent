import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent.app/provider/auth_provider.dart';

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
      var ref=_firestore.collection('notifications').doc(email).collection(email).doc().set({
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
  getNotification()async{
    changeloading(true);
    try{
      var ref=await _firestore.collection('notifications').doc(email).collection(email).orderBy('date',descending: true).limit(10).get();
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