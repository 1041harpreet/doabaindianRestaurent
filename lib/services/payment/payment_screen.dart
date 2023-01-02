import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restaurent_app/config/const.dart';
import 'package:restaurent_app/screens/navBar/profille_page/profile_page.dart';
import 'package:restaurent_app/services/payment/payment_failed_screen.dart';
import 'package:restaurent_app/services/payment/payment_success_screen.dart';
import 'package:restaurent_app/widgets/toast_service.dart';

import '../mail_services.dart';
import '../notification_service/notification.dart';
import '../round_off.dart';

Widget makePayment(cartprovider,checkoutprovider,parentcontext, double total, tax, itemlist) {
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
        showSuccessToast(
            context: parentcontext, message: "Payment Successfully Completed,Check your email.");
        if(params['status']=="success"){
          print('success');
          String admintoken = '';
          MailService().userMail(
              checkoutprovider.checkoutForm
                  .control('email')
                  .value,
              checkoutprovider.checkoutForm
                  .control('fullname')
                  .value,
              params['paymentId'],
              '\$20');
          String usertoken = NotificationController().token;
          await FirebaseFirestore.instance
              .collection('token')
              .doc('1042harpreet@gmail.com')
              .get()
              .then((value) {
            admintoken = value.get('token');
            print('admin token is $admintoken');
          });
          print(checkoutprovider.checkoutForm.value);
          checkoutprovider.sendToAdmin(
              checkoutprovider.checkoutForm
                  .control('email')
                  .value,
              params['paymentId'],
              checkoutprovider,
              roundDouble(cartprovider.total, 2),
              cartprovider.tax,
              cartprovider.orderItem);
          NotificationController().createNewNotification(
              "Hey ${checkoutprovider.checkoutForm.control('fullname').value}! Your order is confirmed",
              "Your order on ${checkoutprovider.checkoutForm.control('email').value} of total ${cartprovider.total} is placed. ",
              usertoken);
          NotificationController().createNewNotification(
              'Hey ! Order From ${checkoutprovider.checkoutForm.control('fullname').value}',
              "New order on ${checkoutprovider.checkoutForm.control('email').value} of total ${cartprovider.total} is Placed.",
              admintoken);
        }


        print("onSuccess: ${params}");
      },
      onError: (error) {
        print("onError: $error");
      },
      onCancel: (params) {
        showErrorToast(
            context: parentcontext, message: "Payment Failed");
        print('cancelled: $params');
      });
}
