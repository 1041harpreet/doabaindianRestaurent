import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/auth_provider.dart';
import 'package:restaurent.app/provider/home_provider.dart';
import 'package:restaurent.app/screens/auth/login_screen.dart';
import 'package:restaurent.app/screens/navBar/profille_page/buffet_page.dart';
import 'package:restaurent.app/screens/navBar/profille_page/gallery.dart';
import 'package:restaurent.app/screens/navBar/profille_page/setting/main_setting_page.dart';
import 'package:restaurent.app/widgets/login_dialogue.dart';

import '../../../config/const.dart';
import '../../../provider/nav_bar_provider.dart';
import 'aboutus_page.dart';
import 'my_Profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authprovider = ref.watch(authProvider);
    final navprovider = ref.watch(NavBarProvider);
    final homeprovider = ref.watch(homeProvider);
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        navprovider.changeindex(0);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppConfig.secmainColor,
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            orderHeader(wsize, hsize),
            optionListView(authprovider, context, homeprovider, navprovider)
          ]),
        ),
      ),
    ));
  }
}

Widget optionListView(authprovider, context, homeprovider, navprovider) {
  return Container(
    child: ListView(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      shrinkWrap: true,
      primary: false,
      children: [
        _listItem(
            onClick: () {
              if (Const.anonymous) {
                loginBox(context, 'Profile', navprovider);
              } else {
                authprovider.myProfile.patchValue({
                  "username": Const.username,
                  "email": Const.email,
                  "phone": Const.phone,
                  "img": Const.img
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfile(),
                    ));
              }
            },
            text: 'My Profile',
            icon: const Icon(Icons.ballot_outlined),
            showArrow: true),
        _separator(),
        _listItem(
            onClick: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsPage(),
                  ));
            },
            text: "About Us",
            icon: const Icon(
              Icons.contact_page_outlined,
              color: Colors.black,
            )),
        _separator(),
        _listItem(
            onClick: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuffetPage(),
                  ));
            },
            text: 'Buffet',
            icon: const Icon(
              Icons.food_bank,
            ),
            showArrow: true),
        _separator(),
        _listItem(
            onClick: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryPage(),
                  ));
            },
            text: 'Gallery',
            icon: const Iconify(Bx.image),
            showArrow: true),
        _separator(),
        _listItem(
            onClick: () {
              if (Const.anonymous) {
                loginBox(context, 'Setting', navprovider);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ));
              }
            },
            text: 'Settings',
            icon: const Icon(Icons.settings)),
        _separator(),
        _listItem(
            onClick: () {
              homeprovider.terms(context);
            },
            text: 'Terms & Conditions',
            icon: const Icon(Icons.assignment)),
        _separator(),
        Const.anonymous
            ? ListTile(
                leading: const Icon(Icons.logout),
                iconColor: AppConfig.blackColor,
                title: Text(
                  'LogOut',
                  style: AppConfig.blackTitle,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppConfig.blackColor,
                  size: 15.0,
                ),
                onTap: () async {
                  navprovider.changeindex(0);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false);
                },
              )
            : logoutbutton(authprovider, context, navprovider),
        _separator(),
      ],
    ),
  );
}

Widget _separator() {
  return const Padding(
    padding: EdgeInsets.only(left: 16.0),
    child: Divider(),
  );
}

Widget _listItem({icon, text, onClick, showArrow = true}) {
  return ListTile(
    leading: icon,
    iconColor: AppConfig.blackColor,
    title: Text(
      text,
      style: AppConfig.blackTitle,
    ),
    trailing: showArrow
        ? Icon(
            Icons.arrow_forward_ios,
            color: AppConfig.blackColor,
            size: 15.0,
          )
        : const SizedBox(),
    onTap: onClick ?? () {},
  );
}

Widget logoutbutton(authprovider, context, navprovider) {
  return ListTile(
    leading: const Icon(Icons.logout),
    iconColor: AppConfig.blackColor,
    title: Text(
      'LogOut',
      style: AppConfig.blackTitle,
    ),
    trailing: Icon(
      Icons.arrow_forward_ios,
      color: AppConfig.blackColor,
      size: 15.0,
    ),
    onTap: () async {
      logoutdialogBox(context, authprovider, navprovider);
    },
  );
}

Widget orderHeader(wsize, hsize) {
  return Padding(
    padding:
        EdgeInsets.symmetric(vertical: hsize * 0.02, horizontal: wsize * 0.04),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: AppConfig.primaryColor,
                ),
                Text(
                  "${Const.adminMail}",
                  style: AppConfig.blackTitle,
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: AppConfig.primaryColor,
                ),
                Text(
                  " ${Const.adminPhone}",
                  style: AppConfig.blackTitle,
                )
              ],
            )
          ],
        ),
        Image.asset(
          'assets/images/logo-web.jpg',
          width: wsize * 0.2,
        )
      ],
    ),
  );
}

logoutdialogBox(context, authprovider, navprovider) {
  return showDialog(
    context: context,
    builder: (context) => Theme(
      data: ThemeData(backgroundColor: Colors.white),
      child: AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to Log out'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await authprovider.signOut(context);
              navprovider.changeindex(0);
              print('log');
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    ),
  );
}
