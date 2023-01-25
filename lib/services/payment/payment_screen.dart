import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:restaurent.app/config/const.dart';
import 'package:restaurent.app/services/payment/payment_failed_screen.dart';
import 'package:restaurent.app/services/payment/payment_success_screen.dart';
import 'package:restaurent.app/widgets/toast_service.dart';

import '../mail_services.dart';
import '../notification_service/notification.dart';
import '../round_off.dart';

Widget makePayment(cartprovider, checkoutprovider, parentcontext, double total,
    tax, itemlist, notificationprovider, context) {
  var sub = total - tax;
  double subtotal = roundDouble(sub, 2);
  print(subtotal);
  print(total);
  return UsePaypal(
      sandboxMode: false,
      clientId: Const().clientID,
      secretKey: Const().secret,
      returnURL: Platform.isAndroid
          ? "com.example.restaurent.app://paypalpay"
          : "com.xstudioz.doaba://paypalpay",
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
        print("onSuccess: ${params}");
        await checkoutprovider.getdate();
        if (params['status'] == 'success') {
          var fullname =
              checkoutprovider.checkoutForm.control('fullname').value;
          var email = checkoutprovider.checkoutForm.control('email').value;
          String usertoken = NotificationController().token;
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => SuccessPage(
                    payby: params['data']['payer']['payment_method'],
                    date: checkoutprovider.date,
                    amount: params['data']['transactions'][0]['amount']
                        ['total'],
                    currency: params['data']['transactions'][0]['amount']
                        ['currency'],
                    transactionId: params['paymentId'],
                  ),
                ),
                (route) => false);
            showSuccessToast(
                context: parentcontext,
                message: "Payment Successfully Completed,Check your email.");
            if (params['status'] == "success") {
              print('success');
              await checkoutprovider.getAdminToken();
              //used to send email to user
              MailService().userMail(email, fullname, checkoutprovider.date,
                  total, params['paymentId']);
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
              //used to send notification to user
              NotificationController().createNewNotification(
                  "Hey ${fullname}! Your order is confirmed",
                  "Your order on ${email} of total ${cartprovider.total} is placed. ",
                  usertoken);
              //used to send notification to admin
              NotificationController().createNewNotification(
                  'Hey ! Order From ${fullname}',
                  "New order on ${email} of total ${cartprovider.total} is Placed.",
                  checkoutprovider.adminToken);

              //add on to notification
              notificationprovider.addToNotification(params['paymentId'], email,
                  true, tax, total, checkoutprovider.date);
            }
          });
        }
      },
      onError: (error) {
        showErrorToast(message: "Something Went Wrong", context: context);
        print("onError: $error");
      },
      onCancel: (params) {
        String usertoken = NotificationController().token;
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      PaymentFailedScreen(orderID: params['token'])),
              (route) => false);
          showErrorToast(context: parentcontext, message: "Payment Failed");
          NotificationController().createNewNotification(
              'Hey ! Your Payment is failed', "Please try Again .!", usertoken);
        });

        print('cancelled: $params');
      });
}
