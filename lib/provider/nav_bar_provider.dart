import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/screens/navBar/order_screen/order_page.dart';

import '../screens/navBar/cart_Page/add_to_cart.dart';
import '../screens/navBar/home_page/home_page.dart';
import '../screens/navBar/profille_page/profile_page.dart';


class NavServices extends ChangeNotifier{

  List screens = [
    HomePage(),
    OrderPage(),
    AddToCart(),
    ProfileScreen(),
  ];



  int selectedindex=0;
  changeindex(int index){
    selectedindex=index;
    notifyListeners();
  }

}
final NavBarProvider=ChangeNotifierProvider((ref) {
  // var screenprovider = ref.watch(screenProvider);
  // print(  "phone no is "+screenprovider.userData[0].phone);
  return NavServices(
  );

},);