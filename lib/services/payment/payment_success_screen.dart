import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent.app/config/config.dart';

import '../../screens/auth/sign_up_screen.dart';
import '../../screens/navBar/nav_bar.dart';

class SuccessPage extends StatelessWidget {
  final String transactionId;
  final String amount;
  final String currency;
  final String payby;
  final String date;

  const SuccessPage(
      {Key? key,
      required this.payby,
      required this.amount,
      required this.currency,
      required this.transactionId,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const NavBar(),
            ),
            (route) => false);
        return false;
        // final shouldPop = await dialogBox(context);
        // return shouldPop!;
      },
      child: Scaffold(
        backgroundColor: AppConfig.secmainColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/images/success.json',
                  width: wsize * 0.8,
                  // height: hsize * 0.5,
                ),
                Text("Payment Successful",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppConfig.primaryColor,
                      fontSize: hsize * 0.03,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(wsize * 0.02),
                      child: Text(
                        'ORDER ID: ',
                        style: TextStyle(
                            fontSize: wsize * 0.05,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      transactionId,
                      style: TextStyle(
                        fontSize: wsize * 0.035,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: hsize * 0.025,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL AMOUNT PAID :',
                        style: TextStyle(
                            fontSize: wsize * 0.04,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '\$$amount ',
                        style: TextStyle(
                            fontSize: wsize * 0.05,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PAYED BY :',
                        style: TextStyle(
                            fontSize: wsize * 0.04,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '$payby ',
                        style: TextStyle(
                            fontSize: wsize * 0.05,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TRANSACTION DATE :',
                        style: TextStyle(
                            fontSize: wsize * 0.04,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '$date ',
                        style: TextStyle(
                            fontSize: wsize * 0.05,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Button(MediaQuery.of(context).size, 'Back To home',
                      Colors.white, AppConfig.primaryColor, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const NavBar(),
                        ),
                        (route) => false);
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
