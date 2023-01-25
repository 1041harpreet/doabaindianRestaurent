import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent.app/config/const.dart';

class CheckOutService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FormGroup checkoutForm = FormGroup({
    "fullname": FormControl(validators: [Validators.required]),
    'address': FormControl(validators: [
      Validators.required,
    ]),
    'company': FormControl(),
    'additional': FormControl(),
    'email': FormControl(validators: [Validators.required, Validators.email]),
    'phone': FormControl(validators: [
      Validators.required,
    ]),
    'town': FormControl(),
    'state': FormControl(validators: []),
    'zipcode': FormControl(validators: [
      Validators.required,
    ]),
  });
  var date = '';

  getdate() {
    var now = DateTime.now();
    date = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  sendToAdmin(email, orderId, checkoutprovider, total, tax, orderItem) {
    var name = date + email;
    print(date);
    _firestore.collection('orders').doc(name).set({
      "date": date,
      "email": email,
      "name": checkoutprovider.checkoutForm.control('fullname').value,
      "total": total,
      "tax": tax,
      "phone": checkoutprovider.checkoutForm.control('phone').value,
      "orderID": orderId,
      "status": false,
      'note': checkoutprovider.checkoutForm.control('additional').value ?? ''
    });
    for (var i = 0; i < orderItem.length; i++) {
      _firestore
          .collection('orders')
          .doc(name)
          .collection(name)
          .doc(orderItem[i].title)
          .set({
        "title": orderItem[i].title,
        "count": orderItem[i].count,
        "total": orderItem[i].total
      }).then((value) {
        print('done');
      });
    }
  }

  String adminToken = '';

  getAdminToken() async {
    await _firestore
        .collection('token')
        .doc(Const.adminMail)
        .get()
        .then((value) {
      adminToken = value.get('token');
      print('admin token is $adminToken');
    });
  }
}

final checkOutProvider = ChangeNotifierProvider((ref) {
  return CheckOutService();
});
