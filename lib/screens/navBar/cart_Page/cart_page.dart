import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/cart_provider.dart';
import '../../../provider/nav_bar_provider.dart';
import '../../../widgets/cart_item.dart';
import '../../../widgets/category_item.dart';
import '../../../widgets/shimmer.dart';

class AddToCart extends ConsumerStatefulWidget {
  const AddToCart({Key? key}) : super(key: key);

  @override
  ConsumerState<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends ConsumerState<AddToCart> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(cartProvider).getTotal();
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final cartprovider = ref.watch(cartProvider);
    final navprovider = ref.watch(NavBarProvider);

    print(cartprovider.subtotal.toString());
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          navprovider.changeindex(0);
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppConfig.secmainColor,
          body: Column(children: [
            Padding(padding: const EdgeInsets.all(8.0), child: header(wsize)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0, // soften the shadow
                        spreadRadius: -1.0, //extend the shadow
                        offset: Offset(
                          -2.0, // Move to right 10  horizontally
                          2.0, // Move to bottom 5 Vertically
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child:
                  cartprovider.checkoutloading ? Center(child: CircularProgressIndicator(color: AppConfig.primaryColor,strokeWidth: 2.0),):
                  StreamBuilder<dynamic>(
                    stream: FirebaseFirestore.instance
                        .collection('cart')
                        .doc('6283578905')
                        .collection('6283578905')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      // cartprovider.changeBadge(snapshot.data.docs.length);
                      if (!snapshot.hasData) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppConfig.primaryColor,
                                  )),
                              const SizedBox(height: 16),
                              Text("Loading...",
                                  style:
                                      TextStyle(color: AppConfig.primaryColor)),
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(
                          'error',
                          style: AppConfig.blackTitle,
                        );
                      }
                      if (snapshot.data.docs.length == 0) {
                        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        //   cartprovider.changeBadge(0);
                        // });
                        return noItemWidget();
                      }
                      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      //   cartprovider.changeBadge(snapshot.data.docs.length);
                      // });
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot item = snapshot.data.docs[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, left: 8.0, right: 8.0),
                            child: CartItem(
                                wsize, hsize, context, item, cartprovider),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            cartprovider.checkoutloading
                ? Center(
                    child: CircularProgressIndicator(
                        color: AppConfig.primaryColor, strokeWidth: 2.0),
                  )
                : cartprovider.subtotal == 0.0
                    ? Container()
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                        ),
                        width: wsize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Subtotal",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: hsize * 0.02,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "\$${cartprovider.subtotal.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "taxs",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: hsize * 0.02,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("\$${cartprovider.tax}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text("Total : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppConfig.primaryColor,
                                          fontSize: 18.0)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                      "\$${cartprovider.total.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 16.0)),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppConfig.primaryColor),
                                        onPressed: () async {
                                          print('checkout');
                                          cartprovider.checkout();
                                        },
                                        child: const Text("Checkout")),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
          ]),
        ),
      ),
    );
  }
}

Widget header(wsize) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Iconify(Bx.shopping_bag, color: Colors.black, size: wsize * 0.1),
    Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: AutoSizeText(
        "Your Cart",
        style: TextStyle(color: Colors.black, fontSize: wsize * 0.1),
      ),
    )
  ]);
}
