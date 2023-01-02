import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/order_model_admin.dart';

class OrderService extends ChangeNotifier{
  bool orderloading=false;
  bool comOrderLoading=false;
  changeloading(key,value){
    key=value;
    notifyListeners();
  }

 List orderList=[];
  List compOrderList=[];
  getPendingOrders() async {
    changeloading(orderloading,true);
    var ref = await FirebaseFirestore.instance.collection('orders').orderBy('date').get();
    orderList=ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
    try{

      notifyListeners();
    }
    catch(e){
      print(e.toString());
    }finally{
      changeloading(orderloading,false);
      notifyListeners();
    }
  }
  getAllCompOrders() async {
    changeloading(comOrderLoading,true);
    var ref = await FirebaseFirestore.instance.collection('allorders').orderBy('date').limit(10).get();
    compOrderList=ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
    try{

      notifyListeners();
    }
    catch(e){
      print(e.toString());
    }finally{
      changeloading(comOrderLoading,false);
      notifyListeners();
    }
  }

  getCompOrders() async {
    changeloading(comOrderLoading,true);
    var ref = await FirebaseFirestore.instance.collection('allorders').orderBy('date').limit(10).get();
    compOrderList=ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
    try{

      notifyListeners();
    }
    catch(e){
      print(e.toString());
    }finally{
      changeloading(comOrderLoading,false);
      notifyListeners();
    }
  }

  List comorderdetaillist=[];
  bool comdetailload=false;
  changecomdetailloading(value){
    comdetailload=value;
    notifyListeners();
  }

  getCompOrderDetails(doc) async {
    changecomdetailloading(true);
    try{
      var ref = await FirebaseFirestore.instance.collection('allorders').doc(doc).collection(doc).get();
      comorderdetaillist=ref.docs.map((e) => AdminOrderItemDetails.fromJson(e.data())).toList();
      notifyListeners();
    }
    catch(e){
      print(e.toString());
    }finally{
      changecomdetailloading(false);
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
