import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:lottie/lottie.dart';
class SuccessPage extends StatelessWidget {
  final String transactionId;
  final String amount;
  final String currency;
  final String email;
  const SuccessPage({Key? key,required this.email,required this.amount,required this.currency,required this.transactionId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final wsize=MediaQuery.of(context).size.width;
    final hsize=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppConfig.secmainColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/images/success.json',
                width: wsize*0.8,
                height: hsize*0.5,

              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Transaction ID: $transactionId',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Amount: $amount $currency',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Email: $email',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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
      ),
    );
  }
}
