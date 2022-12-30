import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restaurent_app/config/const.dart';
import 'package:restaurent_app/services/payment/payment_failed_screen.dart';
import 'package:restaurent_app/services/payment/payment_success_screen.dart';
import 'package:restaurent_app/widgets/toast_service.dart';

import '../mail_services.dart';
import '../round_off.dart';

Widget makePayment(checkoutprovider,parentcontext, double total, tax, itemlist) {
  var sub = total - tax;
  double subtotal = roundDouble(sub, 2);
  print(subtotal);
  return UsePaypal(
      sandboxMode: true,
      clientId: Const().clientID,
      secretKey: Const().secret,
      returnURL: "https://samplesite.com/return",
      cancelURL: "https://samplesite.com/cancel",
      transactions: [
        {
          "amount": {
            "total": total,
            "currency": "USD",
            "details": {
              "subtotal": subtotal,
              "tax": tax,
              "shipping_discount": 0
            }
          },
          "description": "The payment transaction description.",
          "item_list": itemlist
        }
      ],
      note: "Contact us for any questions on your order.",
      onSuccess: (params) async {
        // showSuccessToast(
        //     context: parentcontext, message: "Payment Successfully Completed");
        if(params['status']=="success"){
          print('success');
          MailService().userMail(
              checkoutprovider.checkoutForm
                  .control('email')
                  .value,
              checkoutprovider.checkoutForm
                  .control('fullname')
                  .value,
              params['paymentId'],
              '\$20');
          // Navigator.push(
          //     parentcontext,
          //     MaterialPageRoute(
          //       builder: (parentcontext) => const SuccessPage(
          //           transactionId: 'transactionId',
          //           amount: 'amount',
          //           currency: 'currency',email: "email"),
          //     ));
        }


        print("onSuccess: ${params}");
      },
      onError: (error) {
        print("onError: $error");
      },
      onCancel: (params) {
        // Navigator.push(parentcontext, MaterialPageRoute(builder: (parentcontext) => const PaymentFailedScreen(),));
        print('cancelled: $params');
      });
}
