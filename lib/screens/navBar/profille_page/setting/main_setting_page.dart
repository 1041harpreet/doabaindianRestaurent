import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/auth_provider.dart';

import '../../../../provider/nav_bar_provider.dart';
import '../../../../provider/notification_provider.dart';
import 'change_password/change_password_screen.dart';
import 'delete_account/delete_account_page.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authprovider = ref.watch(authProvider);
    final navprovider = ref.watch(NavBarProvider);
    final notificationprovider = ref.watch(notificationProvider);
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        backgroundColor: AppConfig.primaryColor,
      ),
      backgroundColor: AppConfig.secmainColor,
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          _listItem(
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ));
              },
              text: 'Change Password',
              icon: Iconify(
                Carbon.password,
                color: Colors.black,
              )),
          _listItem(
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeleteAccount(),
                    ));
              },
              text: 'Delete Account',
              icon: Iconify(
                Carbon.account,
                color: Colors.black,
              )),
          // _listItem(
          //     onClick: () async{
          //       var value=await notificationprovider.readValue();
          //      notificationprovider.notificationForm.control('updates').value= value ?? true ;
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const NotificationSetting(
          //
          //             ),
          //           ));
          //     },
          //     text: 'Notifications', icon:  Iconify(Carbon.notification,color: Colors.black,)),
        ]),
      ),
    ));
  }
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
