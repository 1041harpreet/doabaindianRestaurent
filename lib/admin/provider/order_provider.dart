import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/order_model_admin.dart';
import '../../widgets/toast_service.dart';

class OrderService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool pendingloading = false;
  bool firstComLoading = false;

  changeloading(value) {
    pendingloading = value;
    notifyListeners();
  }

  List pendingOrderList = [];
  List compOrderList = [];

  changePmore(value) {
    noPmore = value;
    notifyListeners();
  }

  changePfetching(value) {
    isPfetching = value;
    notifyListeners();
  }

  DocumentSnapshot? lastdocPending;
  bool noPmore = false;
  bool isPfetching = false;

  getFirstPendingOrders() async {
    changeloading(true);

    try {
      var ref = await _firestore
          .collection('orders')
          .where('status', isEqualTo: false)
          .limit(limit)
          .get();
      pendingOrderList =
          ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
      if (ref.docs.isEmpty) {
        print('emtpy');
      } else {
        lastdocPending = ref.docs.last;
      }
    } catch (e) {
      pendingOrderList=pendingOrderList;
      print(e.toString());
    } finally {
      changeloading(false);
    }
  }

  fetchNextPOrder() async {
    changePfetching(true);
    try {
      print(lastdoc?.id);
      var ref = await _firestore
          .collection('orders')
          .where('status', isEqualTo: false)
          // .orderBy('date', descending: true)
          .startAfterDocument(lastdoc!)
          .limit(limit)
          .get();
      print(ref.docs.length);
      if (ref.docs.length < limit) {
        changePmore(true);
      }
      var l =
          await ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
      pendingOrderList.addAll(l);
      print(pendingOrderList.length);
      lastdocPending = ref.docs.last;
    } catch (e) {
      pendingOrderList=pendingOrderList;
      print(e);
    } finally {
      changePfetching(false);
    }
  }

  changefirstloading(value) {
    firstComLoading = value;
    notifyListeners();
  }

  //get only 10 completed orders
  getFirstCompOrders() async {
    changefirstloading(true);
    try {
      var ref = await _firestore
          .collection('orders')
          .where('status', isEqualTo: true)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      compOrderList =
          ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
      if (ref.docs.isEmpty) {
        print('emtpy');
      } else {
        lastdoc = ref.docs.last;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      changefirstloading(false);
    }
  }

  // fetch next complete order item
  DocumentSnapshot? lastdoc;
  int limit = 10;
  bool nomore = false;
  bool isfetching = false;

  changemore(value) {
    nomore = value;
    notifyListeners();
  }

  changefetching(value) {
    isfetching = value;
    notifyListeners();
  }

  fetchNextComOrder() async {
    changefetching(true);
    try {
      print(lastdoc?.id);
      var ref = await _firestore
          .collection('orders')
          .where('status', isEqualTo: true)
          .orderBy('date', descending: true)
          .startAfterDocument(lastdoc!)
          .limit(limit)
          .get();
      print(ref.docs.length);
      if (ref.docs.length < limit) {
        changemore(true);
      }
      var l =
          await ref.docs.map((e) => AdminOrderItem.fromJson(e.data())).toList();
      compOrderList.addAll(l);
      print(compOrderList.length);

      lastdoc = ref.docs.last;
    } catch (e) {
      print(e);
    } finally {
      changefetching(false);
    }
  }

  //mark as completed
  bool markloading = false;
  changemarkloading(value) {
    markloading = value;
    notifyListeners();
  }

  markAsComplete(doc, context) async {
    changemarkloading(true);
    try {
      await _firestore
          .collection('orders')
          .doc(doc)
          .update({"status": true}).then((value) {
        showSuccessToast(message: "Completed", context: context);
      });
    } catch (e) {
      showErrorToast(context: context, message: "Failed");
    } finally {
      changemarkloading(false);
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
    } catch (e) {
      print(e.toString());
    } finally {
      changeDetailLoading(false);
      notifyListeners();
    }
  }

  //delete order
  bool deleteloading = false;
  changedeleteloading(value) {
    deleteloading = value;
    notifyListeners();
  }

  deleteOrder(doc, context) async {
    changedeleteloading(true);
    try {
      await _firestore.collection('orders').doc(doc).delete().then((value) {
        showSuccessToast(
            message: "Order Deleted Successfully", context: context);
      });
    } catch (e) {
      print(e);
      showErrorToast(context: context, message: "Failed");
    } finally {
      changedeleteloading(false);
    }
  }
}

final orderProvider = ChangeNotifierProvider((ref) {
  return OrderService();
});
