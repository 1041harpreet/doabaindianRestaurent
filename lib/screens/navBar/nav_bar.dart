import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/config/const.dart';
import 'package:restaurent.app/provider/auth_provider.dart';
import 'package:restaurent.app/provider/cart_provider.dart';
import 'package:restaurent.app/widgets/login_dialogue.dart';

import '../../provider/nav_bar_provider.dart';
import '../../services/notification_service/notification.dart';

class NavBar extends ConsumerStatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        print('not allowed');
        NotificationController().displayNotificationRationale(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navbarprovider = ref.watch(NavBarProvider);
    final cartprovider = ref.watch(cartProvider);
    final authprovider = ref.watch(authProvider);

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
          if (value == 2) {
            if (Const.anonymous == true) {
              loginBox(context, "Cart", navbarprovider, authprovider);
            } else {
              navbarprovider.changeindex(value);
            }
          } else {
            navbarprovider.changeindex(value);
          }
        },
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30.0),
              label: "Home",
              tooltip: "Home Page"),
          BottomNavigationBarItem(
              icon: Iconify(Carbon.favorite_filled,
                  color: navbarprovider.selectedindex == 1
                      ? AppConfig.primaryColor
                      : Colors.grey,
                  size: 30.0),
              label: "Favourite"),
          BottomNavigationBarItem(
              icon: badge.Badge(
                  badgeContent: Text(cartprovider.badgevalue.toString()),
                  child: const Icon(Icons.shopping_cart, size: 30.0)),
              label: "Cart"),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30.0),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
