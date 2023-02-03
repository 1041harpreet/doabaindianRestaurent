import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../config/const.dart';

class ShopService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FormGroup shopInfo = FormGroup({
    "status": FormControl<bool>(validators: [Validators.required]),
  });

  changeStatus(bool value) {
    Const.status = value;
    notifyListeners();
  }
  bool loading=false;
  changeload(bool value) {
    loading = value;
    notifyListeners();
  }

  updateStatus(bool status)async{
    try {
      await _firestore.collection('admin').doc('admin').update({
        "status":status
      });
      changeStatus(status);
    } catch (e) {
      print(e);
    }
  }
  getStatus() async {
    // changeload(true);
    try {
      await _firestore.collection('admin').doc('admin').get().then((value) {
        Const.status = value.get('status');
        print(Const.status);
      });
      // changeload(false);
      notifyListeners();
    } catch (e) {
      Const.status = false;
      print(e);
      // changeload(false);
      notifyListeners();
    }
  }
}

final shopProvider = ChangeNotifierProvider((ref) {
  return ShopService();
});
