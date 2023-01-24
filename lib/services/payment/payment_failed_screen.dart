import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent.app/config/config.dart';

import '../../screens/auth/sign_up_screen.dart';
import '../../screens/navBar/nav_bar.dart';

class PaymentFailedScreen extends StatelessWidget {
  String orderID;
   PaymentFailedScreen({super.key,required this.orderID});

  @override
  Widget build(BuildContext context) {
    final wsize=MediaQuery.of(context).size.width;
    final hsize=MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async{
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
        appBar: AppBar(leading: IconButton(onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const NavBar(),
              ),
                  (route) => false);
        },
            icon: Icon(Icons.arrow_back)),),
          backgroundColor: AppConfig.secmainColor,
          body:SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/images/fail.json',
                    width: wsize*1,
                    height: hsize*0.5,

                  ),
                  Text(
                    'Payment Failed',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'ID : $orderID',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Button(MediaQuery.of(context).size,'Retry',Colors.white,AppConfig.primaryColor,(){
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
          )),
    );
  }
}
