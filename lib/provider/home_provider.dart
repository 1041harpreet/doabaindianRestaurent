import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:restaurent.app/config/const.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/toast_service.dart';

class HomeService extends ChangeNotifier {
  bool show = true;

  changeshow(value) {
    show = value;
    notifyListeners();
  }

  final url = 'https://doabaindianrestaurantohio.com/terms-conditions/';

  terms(context) async {
    try {
      await launchUrl(
        Uri.parse(url),
      );
    } catch (e) {
      showErrorToast(
          context: context, message: "Failed to launch terms and condition");
      print('failed' + e.toString());
    }
  }

  openMap() async {
    double lat = 40.158867;
    double lng = -83.082340;
    try {
      MapsLauncher.launchCoordinates(lat, lng, 'Doaba Indian Restaurent ');
    } catch (e) {
      print(e.toString());
    }
  }

  openwhatsapp(context) async {
    var contact = "+16142822341";
    var androidUrl =
        "whatsapp://send?phone=${Const.adminPhone}&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/${Const.adminPhone}?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } catch (e) {
      showErrorToast(context: context, message: "Failed to open whatsapp");
      print('WhatsApp is not installed.' + e.toString());
    }
  }
}

final homeProvider = ChangeNotifierProvider((ref) {
  var state = HomeService();
  return state;
});
