import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/screens/navBar/cart_Page/add_to_cart.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppConfig.secmainColor,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(height: hsize * 0.15, child: orderHeader(wsize, hsize)),
          optionListView()
        ]),
      ),
    ));
  }
}

Widget optionListView() {
  return Container(
    child: ListView(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      shrinkWrap: true,
      primary: false,
      children: [
        _listItem(
            onClick: () {},
            text: 'Your Orders',
            icon: const Icon(Icons.ballot_outlined),
            showArrow: true),
        _separator(),
        _listItem(
            onClick: () {},
            text: "Contact Us",
            icon: const Icon(
              Icons.contact_page_outlined,
              color: Colors.black,
            )),
        _separator(),
        _listItem(
            text: 'Buffet',
            icon: const Icon(Icons.food_bank, color: Colors.black),
            showArrow: true),
        _separator(),
        _listItem(
            text: 'Gallery', icon: const Iconify(Bx.image), showArrow: true),
        _separator(),
        _listItem(
            onClick: () {}, text: 'Settings', icon: const Icon(Icons.settings)),
        _separator(),
        _listItem(
            onClick: () {},
            text: 'Terms & Conditions',
            icon: const Icon(Icons.assignment)),
        _separator(),
        _listItem(text: 'Rate App', icon: const Icon(Icons.star_border)),
        _separator(),
        _listItem(
            onClick: () async {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) =>
              //         new PhoneNumberScreen()),
              //         (Route<dynamic> route) => false);
            },
            text: 'Logout',
            icon: const Icon(Icons.logout)),
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

Widget orderHeader(wsize, hsize) {
  return Padding(
    padding: EdgeInsets.all(wsize * 0.02),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Doaba Indian Restaurant",
          style: TextStyle(fontSize: 25.0, color: Colors.black),
        ),
        SizedBox(
          height: hsize * 0.02,
        ),
        Row(
          children: [
            Icon(
              Icons.email,
              color: Colors.green,
            ),
            Text(
              " doabaindianrestaurant@gmail.com",
              style: AppConfig.blackTitle,
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.phone,
              color: Colors.green,
            ),
            Text(
              " +16143760951",
              style: AppConfig.blackTitle,
            )
          ],
        )
      ],
    ),
  );
}
