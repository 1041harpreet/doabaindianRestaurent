import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import '../services/connection_service.dart';
import '../widgets/toast_service.dart';

class HomeService extends ChangeNotifier {

   openMap() async {
    double lat = 30.3589;
    double lng = 76.4497;
    try{
      MapsLauncher.launchCoordinates(
          lat, lng, 'Doaba Indian Restaurent ');
    }catch(e){
      print(e.toString());
    }

  }


  changeconn(value) {
    hasInterNetConnection = value;
    notifyListeners();
  }

  bool hasInterNetConnection = false;

  void connectionChanged(dynamic hasConnection) {
    changeconn(hasConnection);
    print("connection is $hasInterNetConnection");
    if(hasInterNetConnection==false){
      print('no conn found');
      // showErrorToast(message: "no internet connection",context: context);
    }
    notifyListeners();
  }
}

final homeProvider = ChangeNotifierProvider((ref) {
  var state = HomeService();
  return state;
});
