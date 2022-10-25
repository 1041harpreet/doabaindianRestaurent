import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/screens/navBar/category_page.dart';

import '../screens/navBar/add_to_cart.dart';
import '../screens/navBar/home_page.dart';
import '../screens/navBar/profile_page.dart';


class NavServices extends ChangeNotifier{

  List screens = [
    HomePage(),
    CategoryPage(),
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