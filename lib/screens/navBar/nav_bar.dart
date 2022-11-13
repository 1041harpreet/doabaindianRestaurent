import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:restaurent_app/config/config.dart';

import '../../provider/nav_bar_provider.dart';

class NavBar extends ConsumerStatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  @override

  @override
  Widget build(BuildContext context) {
    final navbarprovider = ref.watch(NavBarProvider);
    return Scaffold(
      body: navbarprovider.screens[navbarprovider.selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: navbarprovider.selectedindex,
        elevation: 15.0,
        iconSize: 35.0,
        selectedItemColor: AppConfig.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          navbarprovider.changeindex(value);
        },
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,size: 30.0), label: "Home",tooltip: "Home Page"),
          BottomNavigationBarItem(
            icon: Iconify(Carbon.order_details,color:navbarprovider.selectedindex==1 ? AppConfig.primaryColor :Colors.grey,size: 30.0),label: "Order"),
          const BottomNavigationBarItem(
              icon:
              Icon(Icons.shopping_cart,size: 30.0),
              label: "Cart"),
          const BottomNavigationBarItem(icon: Icon(Icons.person,size: 30.0), label: "My Profile",)
        ],
      ),
    );
  }
}
