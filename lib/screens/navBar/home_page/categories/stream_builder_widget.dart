import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/widgets/category_item.dart';
import 'package:restaurent_app/screens/navBar/home_page/product_details_view.dart';

import '../../../../widgets/cart_item.dart';
import '../../../../widgets/home_item.dart';
import '../../../../widgets/shimmer.dart';
import 'category_items.dart';
Widget cartlistBuilder(wsize, hsize, cartprovider, context) {
  return Padding(
    padding: EdgeInsets.all(wsize * .03),
    child: SizedBox(
      height: hsize * .3,
      width: MediaQuery.of(context).size.width * 1,
      child: cartprovider.checkoutloading
          ? ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return categoryShimmer(wsize, hsize, context);
        },
      )
          : cartprovider.orderItem.isEmpty
          ? Center(
        child: Text("No item here ", style: AppConfig.blackTitle),
      )
          : Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ListView.builder(
          itemCount: cartprovider.orderItem.length,
          itemBuilder: (context, index) {
            var item = cartprovider.orderItem[index];
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ProductDetailsView(
                            item: item, catname: item.category),
                      ));
                },
                child: CartItem(wsize, hsize,context, item, cartprovider));
          },
        ),),),
  );
}
Widget listBuilder(wsize, hsize, cprovider, catname, context) {
  return Padding(
    padding: EdgeInsets.all(wsize * .03),
    child: SizedBox(
        height: hsize * .3,
        width: MediaQuery.of(context).size.width * 1,
        child: cprovider.subloading
            ? ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return categoryShimmer(wsize, hsize, context);
                },
              )
            : cprovider.subcategory.isEmpty
                ? Center(
                    child: Text("No item here ", style: AppConfig.blackTitle),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: ListView.builder(
                      itemCount: cprovider.subcategory.length,
                      itemBuilder: (context, index) {
                        var item = cprovider.subcategory[index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ProductDetailsView(
                                        item: item, catname: catname),
                                  ));
                            },
                            child:
                                Item(wsize, hsize, item, cprovider, context));
                      },
                    ),),),
  );
}

const options = LiveOptions(
  // Start animation after (default zero)
  delay: Duration(seconds: 0),
  // Show each item through (default 250)
  showItemInterval: Duration(milliseconds: 0),
  // Animation duration (default 250)
  showItemDuration: Duration(microseconds: 0),
  // Animations starts at 0.05 visible
  // item fraction in sight (default 0.025)
  visibleFraction: 0.001,
  // Repeat the animation of the appearance
  // when scrolling in the opposite direction (default false)
  // To get the effect as in a showcase for ListView, set true
  reAnimateOnVisibility: false,
);

Widget listview(hsize, wsize, context, categoryprovider) {
  return Padding(
    padding: EdgeInsets.all(wsize * .03),
    child: SizedBox(
        height: hsize * .3,
        width: MediaQuery.of(context).size.width * 1,
        child: categoryprovider.loading
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  return homePageShimmer(context, wsize, hsize);
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: LiveList.options(
                    options: options,
                    itemCount: categoryprovider.category.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index, animation) {
                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        // And slide transition
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, -0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          // Paste you Widget
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategoryItems(
                                            name: categoryprovider
                                                .category[index].title,
                                            index: index,
                                          )));
                            },
                            child: homeItem(
                                wsize, hsize, categoryprovider.category[index]),
                          ),
                        ),
                      );
                    }),
              )),
  );
}

Widget madeforulist(hsize, wsize, context, categoryprovider) {
  return Padding(
    padding: EdgeInsets.all(wsize * .03),
    child: SizedBox(
        height: hsize * .3,
        width: MediaQuery.of(context).size.width * 1,
        child: categoryprovider.mfuload
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  return homePageShimmer(context, wsize, hsize);
                },
              )

            : categoryprovider.madefulist.length == 0
                ? Center(
                    child: Text(" No item Today ", style: AppConfig.blackTitle),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: LiveList.options(
                        options: options,
                        itemCount: categoryprovider.madefulist.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index, animation) {
                          return FadeTransition(
                            opacity: Tween<double>(
                              begin: 0,
                              end: 1,
                            ).animate(animation),
                            // And slide transition
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, -0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              // Paste you Widget
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>ProductDetailsView(item:categoryprovider.madefulist[index], catname: categoryprovider.madefulist[index].category)
                                    ),
                                  );
                                },
                                child: largeItem(wsize, hsize,
                                    categoryprovider.madefulist[index]),
                              ),
                            ),
                          );
                        }),
                  )),
  );
}

Widget largeItem(wsize, hsize, item) {
  return Container(
      margin: EdgeInsets.all(wsize * 0.02),
      width: wsize * 0.8,
      // height: hsize / 5,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(wsize * 0.01),
        boxShadow: [
          BoxShadow(
              offset: const Offset(2.0, 2.0),
              color: Colors.black26,
              blurRadius: wsize * .01)
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              // height: hsize*0.21,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: item.img,
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.black),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: wsize,
              color: Colors.grey.shade300,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 3.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wsize * 0.02),
                      child: Text(
                        item.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: wsize * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        item.category.toString().length > 35
                            ? Padding(
                                padding: EdgeInsets.only(left: wsize * 0.02),
                                child: Text(
                                  "${item.category.toString().substring(0, 30)}...",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(left: wsize * 0.02),
                                child: Text(
                                  "${item.category}",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wsize * 0.02),
                      child: Text(
                        "\$${item.price}",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: wsize * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                  ]),
            ),
          )
        ],
      )
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //
      //
      //   ],
      // )
      );
}
