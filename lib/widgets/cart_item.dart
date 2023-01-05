import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/screens/navBar/home_page/home_page.dart';

import 'category_item.dart';

// import 'category_item.dart';

Widget CartItem(wsize, hsize, context, item,cartprovider) {
  return Padding(
      padding: EdgeInsets.only(
          left: wsize * 0.02, right: wsize * 0.02, top: wsize * 0.02),
      child: Container(
        // width: wsize * .3,
        height: hsize * .175,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(wsize * 0.025),
          boxShadow: [
            BoxShadow(
                offset: const Offset(2.0, 2.0),
                color: Colors.black26,
                blurRadius: wsize * .025)
          ],
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                    width: wsize * 0.25,
                    child: Center(
                      child: buildImg(hsize, wsize, item.img),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: wsize * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: wsize * 0.03, top: wsize * 0.03),
                      child: AutoSizeText(item.title.toString().length >25 ? '${item.title.toString().substring(0,25)}...' :item.title.toString() ,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: wsize * 0.045,
                              color: Colors.black87)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wsize * 0.04),
                      child: item.category.toString().length > 30
                          ? AutoSizeText(
                          '${item.category.toString().substring(0, 30)}...',
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: wsize * 0.035,
                              color: Colors.black54))
                          : AutoSizeText(item.category,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: wsize * 0.035,
                              color: Colors.black54)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: wsize * 0.04, top: wsize * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const AutoSizeText("Price : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold)),
                                AutoSizeText("\$${item.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: AppConfig.primaryColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ]),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: AutoSizeText("x ${item.count}",
                                style: TextStyle(
                                    color: AppConfig.primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: wsize * 0.00, top: wsize * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                            Padding(
                            padding: EdgeInsets.only(left: wsize * 0.04),
                            child: const Text("SubTotal : ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                            Text(
                              "\$${item.total.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: AppConfig.primaryColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),],),
                          Padding(
                            padding:  EdgeInsets.only(left:wsize*0.07),
                            child:

                            GestureDetector(

                                onTap: () async{
                                  await cartprovider.removeFromCart(item, context);
                                },
                                child: Iconify(AntDesign.delete,color: AppConfig.primaryColor,)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ));
}

Widget addToCardButton(cart, context) {
  return Center(
    child: ElevatedButton(
      onPressed: cart.cartItems.length == 0
          ? null
          : () {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Text('CheckOut', style: AppConfig.blackTitle),
    ),
  );
}
Widget noItemWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('You don\'t have any order yet!!', style: AppConfig.blackTitle),
        const SizedBox(height: 16),
        const Icon(Icons.remove_shopping_cart, size: 40),
      ],
    ),
  );
}

