import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/auth_provider.dart';
import 'package:restaurent.app/provider/cart_provider.dart';
import 'package:restaurent.app/provider/category_provider.dart';

import '../../../provider/check_out_provider.dart';
import '../../../provider/nav_bar_provider.dart';
import '../home_page/categories/builder.dart';

class AddToCart extends ConsumerStatefulWidget {
  const AddToCart({Key? key}) : super(key: key);

  @override
  ConsumerState<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends ConsumerState<AddToCart> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(cartProvider).getorderItem();
      ref.watch(cartProvider).getTotal();
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final cartprovider = ref.watch(cartProvider);
    final authprovider = ref.watch(authProvider);
    final navprovider = ref.watch(NavBarProvider);
    final checkoutprovider = ref.watch(checkOutProvider);
    final categoryprovider = ref.watch(categoryProvider);
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
            header(wsize),
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
                  child: Column(children: [
                    Expanded(
                        child: CartlistBuilder()),
                  ]),
                ),
              ),
            ),
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
