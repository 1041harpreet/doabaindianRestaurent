import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/order_model_admin.dart';
import '../../widgets/toast_service.dart';

class OrderService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool orderloading = false;
  bool comOrderLoading = false;

  changeloading(key, value) {
    key = value;
    notifyListeners();
  }

  List orderList = [];
  List compOrderList = [];

  getPendingOrders() async {
    changeloading(orderloading, true);

    try {
      var ref = await _firestore
          .collection('orders')
          .where('status', isEqualTo: false)
          .limit(10)
          .get();
      orderList =
          ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    } finally {
      changeloading(orderloading, false);
      notifyListeners();
    }
  }

//get all pending orders
  getAllPendingOrders() async {
    changeloading(orderloading, true);

    try {
      var ref = await _firestore
          .collection('orders')
          .where('status', isEqualTo: false)
          .get();
      orderList =
          ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    } finally {
      changeloading(orderloading, false);
      notifyListeners();
    }
  }

  //get only 10 completed orders
  getFirstCompOrders() async {
    changeloading(comOrderLoading, true);
    var ref = await _firestore
        .collection('orders')
        .where('status', isEqualTo: true)
        .limit(10)
        .get();
    compOrderList =
        ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
    try {
      notifyListeners();
    } catch (e) {
      print(e.toString());
    } finally {
      changeloading(comOrderLoading, false);
      notifyListeners();
    }
  }

  //get all completed orders
  getAllCompOrders() async {
    changeloading(comOrderLoading, true);
    var ref = await _firestore
        .collection('orders')
        .where('status', isEqualTo: true)
        .get();
    compOrderList =
        ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
    try {
      notifyListeners();
    } catch (e) {
      print(e.toString());
    } finally {
      changeloading(comOrderLoading, false);
      notifyListeners();
    }
  }

  //mark as completed
  bool markloading=false;
  markAsComplete(doc,context)async{
    changeloading(markloading,true);
    try{
      await _firestore.collection('orders').doc(doc).update({
        "status":true
      }).then((value) {
        showSuccessToast(message: "Completed",context: context);
      });
    }catch(e){
      showErrorToast(context: context,message: "Failed");
    }finally{
      changeloading(markloading, false);
    }


  }
  bool detailLoad = false;
//change loading state
  changeDetailLoading(value) {
    detailLoad = value;
    notifyListeners();
  }

  //get list of item
  List orderDetailList = [];

  getorderdetails(doc) async {
    changeDetailLoading(true);
    try {
      var ref =
          await _firestore.collection('orders').doc(doc).collection(doc).get();
      orderDetailList = ref.docs
          .map((e) => AdminOrderItemDetails.fromJson(e.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    } finally {
      changeDetailLoading(false);
      notifyListeners();
    }
  }

  //delete order
  bool deleteloading=false;
  deleteOrder(doc, context) async {
    changeloading(deleteloading, true);
    try {

      await _firestore.collection('orders').doc(doc).delete().then((value) {
        showSuccessToast(
            message: "Order Deleted Successfully", context: context);
      });
    } catch (e) {
      print(e);
      showErrorToast(context: context, message: "Failed");
    }finally{
      changeloading(deleteloading, false);
    }
  }
}

final orderProvider = ChangeNotifierProvider((ref) {
  return OrderService();
});
