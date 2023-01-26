import 'package:flutter/material.dart';
import 'package:restaurent.app/config/const.dart';
import 'package:restaurent.app/screens/navBar/profille_page/main_Profile_screen.dart';

import '../../config/config.dart';
import '../completed_order_screen.dart';

Widget drawer(context, authprovider, orderprovider,navprovider) {
  return ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
      UserAccountsDrawerHeader(
        // <-- SEE HERE
        decoration: BoxDecoration(color: AppConfig.primaryColor),
        accountName: Text(Const.username, style: AppConfig.blacktext),

        accountEmail: Text(
          authprovider.user.email,
          style: AppConfig.blacktext,
        ),
        currentAccountPicture: Image.asset('assets/images/avatar.png'),
      ),
      ListTile(
        leading: const Icon(
          Icons.home,
          color: Colors.black,
        ),
        title: Text('Gallery', style: AppConfig.blacktext),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.bookmark_border,
          color: Colors.black,
        ),
        title: Text('Completed Orders', style: AppConfig.blacktext),
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletedOrderScreen(),
              ));
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.logout,
          color: Colors.black,
        ),
        title: Text('Log Out', style: AppConfig.blacktext),
        onTap: () async {
          logoutdialogBox(context, authprovider,navprovider);
          // await authprovider.signOut(context);
        },
      ),
    ],
  );
}
