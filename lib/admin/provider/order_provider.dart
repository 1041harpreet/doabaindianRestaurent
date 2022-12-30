import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/order_model_admin.dart';

class OrderService extends ChangeNotifier{
  bool orderloading=false;
  changeloading(value){
    orderloading=value;
    notifyListeners();
  }

 List orderList=[];
  getdetail() async {
    changeloading(true);
    var ref = await FirebaseFirestore.instance.collection('orders').orderBy('date',descending: true).limit(10).get();
    orderList=ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
    try{

      notifyListeners();
    }
    catch(e){
      print(e.toString());
    }finally{
      changeloading(false);
      notifyListeners();
    }
  }
 List orderdetaillist=[];
  bool detailload=false;
  changedetailloading(value){
    detailload=value;
    notifyListeners();
  }

  getorderdetails(doc) async {
    changedetailloading(true);
    try{
      var ref = await FirebaseFirestore.instance.collection('orders').doc(doc).collection(doc).get();
      orderdetaillist=ref.docs.map((e) => AdminOrderItemDetails.fromJson(e.data())).toList();
      notifyListeners();
    }
    catch(e){
      print(e.toString());
    }finally{
      changedetailloading(false);
      notifyListeners();
    }
  }

}
final orderProvider = ChangeNotifierProvider((ref) {
  return OrderService();
});
