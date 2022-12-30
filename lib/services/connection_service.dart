
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../widgets/toast_service.dart';

class NetworkService extends ChangeNotifier{
  late StreamSubscription subscription;
  bool deviceConnected = false;
  bool isAlertSet = false;
checkconnection()async{
  var result =await Connectivity().checkConnectivity();
  if(result ==ConnectivityResult.none){
    deviceConnected=false;
    print('no internet');
    showDialogBox();
    notifyListeners();
  }else{
    var res = await DataConnectionChecker().hasConnection;
    if(res){
      deviceConnected=true;
      notifyListeners();
    }
    else{
      deviceConnected=false;
      print('no internet');
      showDialogBox();

      notifyListeners();
    }

  }
  print(deviceConnected);
}
  stream(context) {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        checkconnection();
        notifyListeners();
      },
    );
  }

  showDialogBox() => Get.dialog(barrierDismissible: false,
    CupertinoAlertDialog(
      title: const Text('No Connection'),
      content: const Text('Please check your internet connectivity'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Get.back();
            checkconnection();
          },
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}

final networkProvider=ChangeNotifierProvider((ref) {
  return NetworkService();
});