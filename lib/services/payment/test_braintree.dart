import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:restaurent.app/services/payment/payment_success_screen.dart';

import '../../config/const.dart';

class BraintreePayment extends StatelessWidget {
  const BraintreePayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        ElevatedButton(
            onPressed: () async {
              final request = BraintreeDropInRequest(
                clientToken: Const().token,
                collectDeviceData: true,
                paypalRequest: BraintreePayPalRequest(
                    amount: '4.9',
                    currencyCode: "USD",
                  displayName: "hello",
                  billingAgreementDescription: 'billing description'
                ),
              );
              BraintreeDropInResult? result = await BraintreeDropIn.start(request);
              if (result != null) {

                print(result.paymentMethodNonce.paypalPayerId);
                print(result.paymentMethodNonce.nonce);
                print(result.paymentMethodNonce.description);
                print(result.paymentMethodNonce.typeLabel);
                // we have no once
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessPage(
                //   payby: "Payby",
                //   amount: "35",
                //   currency: "USD",
                //   date: "Date",
                //   transactionId: "23456234567",

              //   ),
              // ));
                print('success');
              } else {
                print('failed');
                // showErrorToast(message: 'Payment was  canceled.');
              }
            },
            child: Text('LAUNCH NATIVE DROP-IN')

        ),
      ),
    );
  }
}
