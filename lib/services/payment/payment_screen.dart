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

Widget makePayment(cartprovider, checkoutprovider, parentcontext, double total,
    tax, itemlist, notificationprovider) {
  var sub = total - tax;
  double subtotal = roundDouble(sub, 2);
  print(subtotal);
  print(total);
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
        var fullname = checkoutprovider.checkoutForm.control('fullname').value;
        var email = checkoutprovider.checkoutForm.control('email').value;
        showSuccessToast(
            context: parentcontext,
            message: "Payment Successfully Completed,Check your email.");
        if (params['status'] == "success") {
          print('success');
          String usertoken = NotificationController().token;
          await checkoutprovider.getAdminToken();
          //used to send notification to user
          NotificationController().createNewNotification(
              "Hey ${fullname}! Your order is confirmed",
              "Your order on ${email} of total ${cartprovider.total} is placed. ",
              usertoken);
          //used to send notification to admin
          NotificationController().createNewNotification(
              'Hey ! Order From ${fullname}',
              "New order on ${email} of total ${cartprovider.total} is Placed.",
              checkoutprovider.admintoken);
          //used to send email to user
          MailService().userMail(
              email, fullname, checkoutprovider.date, total, params['paymentId']);
          //used to send mail to admin
          MailService().adminMail(
              fullname, checkoutprovider.date, total, params['paymentId']);
          //used to send data to admin
          checkoutprovider.sendToAdmin(
              email,
              params['paymentId'],
              checkoutprovider,
              roundDouble(cartprovider.total, 2),
              cartprovider.tax,
              cartprovider.orderItem);
          //add on to notification
          notificationprovider.addToNotification(
              params['paymentId'], email, true, tax, total, checkoutprovider.date);
        }

        print("onSuccess: ${params}");
      },
      onError: (error) {
        print("onError: $error");
      },
      onCancel: (params) {
        showErrorToast(context: parentcontext, message: "Payment Failed");
        NotificationController().createNewNotification(
            'Hey ! Your Payment is failed',
            "Please try Again .!",
            checkoutprovider.admintoken);
        print('cancelled: $params');
      });
}
