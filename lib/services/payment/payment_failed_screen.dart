import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent.app/config/config.dart';

class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wsize=MediaQuery.of(context).size.width;
    final hsize=MediaQuery.of(context).size.height;
    return Scaffold(
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
                  height: hsize*0.6,

                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Payment Failed',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'ID : 2345678',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppConfig.primaryColor),
                      onPressed: (){

                      },
                      child: Text("Transaction details",style: AppConfig.blacktext,),)
                ),
              ],
            ),
          ),
        ));
  }
}
