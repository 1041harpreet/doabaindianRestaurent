import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/navBar/cart_Page/cart_page.dart';
import '../screens/navBar/favouriteScreen/favourite_screen.dart';
import '../screens/navBar/home_page/home_page.dart';
import '../screens/navBar/profille_page/main_Profile_screen.dart';

class NavServices extends ChangeNotifier {
  List screens = const [
    HomePage(),
    FavouriteScreen(),
    AddToCart(),
    ProfileScreen(),
  ];
  bool isObsecure = true;


  changeSecure(value) {
    isObsecure = value;
    print(isObsecure);
    notifyListeners();
  }

  int selectedindex = 0;

  changeindex(int index) {
    selectedindex = index;
    notifyListeners();
  }
}

final NavBarProvider = ChangeNotifierProvider(
  (ref) {
    return NavServices();
  },
);
