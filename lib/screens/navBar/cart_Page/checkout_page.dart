import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/auth_provider.dart';
import 'package:restaurent.app/provider/cart_provider.dart';
import 'package:restaurent.app/services/payment/payment_failed_screen.dart';

import '../../../provider/check_out_provider.dart';
import '../../../provider/notification_provider.dart';
import '../../../services/mail_services.dart';
import '../../../services/notification_service/notification.dart';
import '../../../services/payment/payment_screen.dart';
import '../../../services/payment/payment_success_screen.dart';
import '../../../services/round_off.dart';
import '../../../widgets/toast_service.dart';
import '../../auth/splash_screen.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(cartProvider).getorderItem();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartprovider = ref.watch(cartProvider);
    final authprovider = ref.watch(authProvider);
    final checkoutprovider = ref.watch(checkOutProvider);
    final notificationprovider = ref.watch(notificationProvider);
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
            backgroundColor: AppConfig.secmainColor,
            body: ReactiveForm(
              formGroup: checkoutprovider.checkoutForm,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          //header text
                          Center(
                            child: Text(
                              'Checkout',
                              style: GoogleFonts.inter(
                                fontSize: 24.0,
                                color: const Color(0xFF15224F),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Center(
                            child: Text(
                              'Enter Detail to order now',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: const Color(0xFF969AA8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          //email & password section
                          textfieldbtn(size, 'Full name', 'fullname', {
                            ValidationMessage.required: (error) =>
                                "The name must not be empty",
                          }),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          textfieldbtn(size, 'Email', 'email', {
                            ValidationMessage.required: (error) =>
                                "The email must not be empty",
                            ValidationMessage.email: (error) =>
                                'Please enter a valid email',
                          }),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          textfieldbtn(size, 'Phone', 'phone', {
                            ValidationMessage.required: (error) =>
                                "The phone no must not be empty",
                          }),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Country/Region',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'United States (US)',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: const Color(0xFF969AA8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          textfieldbtn(
                              size, 'Company name(optional)', 'company', {
                            ValidationMessage.required: (error) =>
                                "The Town must not be empty",
                          }),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          textfieldbtn(size, 'Street Address', 'address', {
                            ValidationMessage.required: (error) =>
                                "The Adress must not be empty",
                          }),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          textfieldbtn(size, 'Town/City', 'town', {
                            ValidationMessage.required: (error) =>
                                "The Town must not be empty",
                          }),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'State',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // textfieldbtn(size, 'City', 'city',{
                          //   ValidationMessage.required: (error) => "The City must not be empty",
                          // }),
                          // SizedBox(
                          //   height: size.height * 0.02,
                          // ),
                          textfieldbtn(size, 'Zip Code', 'zipcode', {
                            ValidationMessage.required: (error) =>
                                "The ZipCode must not be empty",
                          }),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Additional Information',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),

                          textfieldbtn(
                              size, 'Notes about your Order', 'additional', {
                            ValidationMessage.required: (error) =>
                                "The phone no must not be empty",
                          }),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Your Order',
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: cartprovider.orderItem.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      cartprovider.orderItem[index].title,
                                      style: AppConfig.blackTitle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'X ${cartprovider.orderItem[index].count}',
                                      style: AppConfig.blackTitle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("\$${cartprovider.orderItem[index].total}",
                                      style: AppConfig.blackTitle,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tax',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    color: const Color(0xFF969AA8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  cartprovider.tax.toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    color: const Color(0xFF969AA8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  cartprovider.total.toStringAsFixed(2),
                                  style: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Button(
                      size,
                      () async {
                        BuildContext parentContext = context;
                        print('checkout start ');

                        if (checkoutprovider.checkoutForm.valid) {
                          print(roundDouble(cartprovider.total, 2));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => makePayment(cartprovider,checkoutprovider,parentContext,
                                    roundDouble(cartprovider.total, 2), cartprovider.tax, {
                                      "items": [
                                        for (var i = 0;
                                        i < cartprovider.orderItem.length;
                                        i++)
                                          {
                                            "name":
                                            cartprovider.orderItem[i].title,
                                            "quantity":
                                            cartprovider.orderItem[i].count,
                                            "price": roundDouble(
                                                cartprovider.orderItem[i].price,
                                                2),
                                            "currency": "USD"
                                          }
                                      ],
                                    },notificationprovider, _scaffoldKey.currentContext),
                              ),);




                        }
                        else {
                          showErrorToast(
                              message: 'fill the detail first',
                              context: context);
                        }
                      },
                      Text(
                        'Order Now',
                        style: GoogleFonts.inter(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget textfieldbtn(Size size, lable, controlname, validation) {
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.07,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: const Color(0xFFEFEFEF),
        ),
      ),
      child: ReactiveTextField(
        formControlName: controlname,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        validationMessages: validation,
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: lable,
            labelStyle: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget Button(size, ontap, child) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
          alignment: Alignment.center,
          height: size.height * 0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: AppConfig.primaryColor,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4C2E84).withOpacity(0.2),
                offset: const Offset(0, 15.0),
                blurRadius: 60.0,
              ),
            ],
          ),
          child: child),
    );
  }
}
