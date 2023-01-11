import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/connection_service.dart';
import '../widgets/toast_service.dart';

class HomeService extends ChangeNotifier {
   bool show=true;
   changeshow( value){
     show=value;
     notifyListeners();
   }
   openMap() async {
    double lat = 40.158867;
    double lng = -83.082340;
    try{
      MapsLauncher.launchCoordinates(
          lat, lng, 'Doaba Indian Restaurent ');
    }catch(e){
      print(e.toString());
    }

  }

  openwhatsapp(context) async {

      var contact = "+1 (614) 282-2341";
      var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
      var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

      try{
        if(Platform.isIOS){
          await launchUrl(Uri.parse(iosUrl));
        }
        else{
          await launchUrl(Uri.parse(androidUrl));
        }
      } catch(e){
        showErrorToast(context: context,message: "Failed to open whatsapp");
        print('WhatsApp is not installed.'+e.toString());
      }
    }
  }



final homeProvider = ChangeNotifierProvider((ref) {
  var state = HomeService();
  return state;
});
