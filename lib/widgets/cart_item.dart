import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent.app/config/config.dart';

import 'category_item.dart';

// import 'category_item.dart';

Widget CartItem(wsize, hsize, context, item, cartprovider) {
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
                          left: wsize * 0.04, top: wsize * 0.035),
                      child: AutoSizeText(
                          item.title.toString().length > 25
                              ? '${item.title.toString().substring(0, 20)}...'
                              : item.title.toString(),
                          maxLines: 1,
                          style: GoogleFonts.mulish(
                              fontWeight: FontWeight.w500,
                              fontSize: wsize * 0.045,
                              color: Colors.black87)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wsize * 0.035),
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
                        left: wsize * 0.04,
                      ),
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
                                AutoSizeText(
                                    "\$${item.price.toStringAsFixed(2)}",
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
                    Row(
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
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: wsize * 0.07),
                          child: InkWell(
                            onTap: () async {
                              await cartprovider.removeFromCart(item, context);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: .5,
                                      ),
                                    ]),
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                  size: 25,
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ]),
      ));
}

Widget noItemWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('You don\'t have any item yet!!', style: AppConfig.blackTitle),
      ],
    ),
  );
}
