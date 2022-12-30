// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
//
// class ConnectionUtil {
//   //This creates the single instance by calling the `_internal` constructor specified below
//   static final ConnectionUtil _singleton =  ConnectionUtil._internal();
//   ConnectionUtil._internal();
//   //This is what's used to retrieve the instance through the app
//   static ConnectionUtil getInstance() => _singleton;
//   //This tracks the current connection status
//   bool hasConnection = false;
//   //This is how we'll allow subscribing to connection changes
//   StreamController connectionChangeController = StreamController();
//   //flutter_connectivity
//   final Connectivity _connectivity = Connectivity();
//   void initialize() {
//     _connectivity.onConnectivityChanged.listen(_connectionChange);
//   }
//
//   //flutter_connectivity's listener
//   void _connectionChange(ConnectivityResult result) {
//     hasInternetInternetConnection();
//   }
//
//   Stream get connectionChange => connectionChangeController.stream;
//   Future<bool> hasInternetInternetConnection() async {
//     bool previousConnection = hasConnection;
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     //Check if device is just connect with mobile network or wifi
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       //Check there is actual internet connection with a mobile network or wifi
//       if (await DataConnectionChecker().hasConnection) {
//         // Network data detected & internet connection confirmed.
//         hasConnection = true;
//       } else {
//         // Network data detected but no internet connection found.
//         hasConnection = false;
//       }
//     }
//     // device has no mobile network and wifi connection at all
//     else {
//       hasConnection = false;
//     }
//     // The connection status changed send out an update to all listeners
//     if (previousConnection != hasConnection) {
//       connectionChangeController.add(hasConnection);
//     }
//     return hasConnection;
//   }
// }
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
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
    // showDialogBox();
    notifyListeners();
  }else{
    deviceConnected=true;
    notifyListeners();
    return;


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