import 'package:auto_animated/auto_animated.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/config/const.dart';
import 'package:restaurent_app/screens/navBar/home_page/home_item.dart';
import 'package:restaurent_app/screens/navBar/order_screen/order_page.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../provider/category_provider.dart';
import 'categories/category_items.dart';
import 'categories/all_category.dart';

class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);

  var d;
  TextEditingController searchController = TextEditingController();
  final options = const LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 0),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 100),

    // Animation duration (default 250)
    showItemDuration: Duration(seconds: 1),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.05,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // final cprovider=ref.watch(categoryProvider);
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    List carsoullist = ["assets/images/image.png"];
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppConfig.secmainColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(wsize, hsize),
            CarouselSlider(
                options: CarouselOptions(
                  height: 190.0,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: carsoullist.map((e) {
                  return Builder(
                    builder: (context) {
                      return Container(
                        height: 200.0,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage(e),
                            fit: BoxFit.fill,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.all(10.0),
                      );
                    },
                  );
                }).toList()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: wsize * .05),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: wsize * .05,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                  onTap: ()async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoreCategory(
                            index: 0,
                          ),
                        ));
                    print('pressed more');


                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: wsize * .03, top: hsize * .01),
                    child: const Text("More",
                        style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(wsize * .03),
              child: SizedBox(
                height: hsize * .25,
                width: MediaQuery.of(context).size.width * 1,
                child: StreamBuilder<dynamic>(
                    stream: FirebaseFirestore.instance
                        .collection('category')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
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
                      return Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: LiveList.options(
                            options: options,
                            itemCount: snapshot.data.docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index, animation) {
                              DocumentSnapshot item = snapshot.data.docs[index];
                              print(item);
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
                                                builder: (context) =>
                                                    CategoryItems(name: item['title']) ));
                                      },
                                      child: homeItem(wsize, hsize, item),
                                    )),
                              );
                            }),
                      );
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: wsize * .05),
                  child: Text(
                    "Best For U",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: wsize * .05,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoreCategory(
                            index: 0,
                          ),
                        ));
                    print('pressed more');
                    // print(Const();
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: wsize * .03, top: hsize * .01),
                    child: const Text("More",
                        style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(wsize * .03),
              child: SizedBox(
                height: hsize * .25,
                width: MediaQuery.of(context).size.width * 1,
                child: StreamBuilder<dynamic>(
                    stream: FirebaseFirestore.instance
                        .collection('category')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
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
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: LiveList.options(
                            options: options,
                            itemCount: snapshot.data.docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index, animation) {
                              DocumentSnapshot item = snapshot.data.docs[index];
                              print(item);
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
                                                builder: (context) =>
                                                   CategoryItems(name: item['title']) ));
                                      },
                                      child: homeItem(wsize, hsize, item),
                                    )),
                              );
                            }),
                      );
                    }),
              ),
            ),
            const Center(
                child: Text(
              "We provide catering services",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )),
        Padding(padding: EdgeInsets.all(10.0),child:     Image.asset("assets/images/banner.jpg"),)
          ],
        ),
      ),
    ));
  }
}

Widget buildImage(hsize, wsize, img) {
  return Container(
      // height: hsize * .,
      // width: wsize * .3,
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
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network(
          img,
          fit: BoxFit.cover,
        ),
      ));
}

Widget header(wsize, hsize) {
  return Padding(
    padding: EdgeInsets.all(wsize * 0.03),
    child: SizedBox(
      height: hsize * .1,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: EdgeInsets.all(wsize * 0.02),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Doaba Indian Restaurent",
                  style: TextStyle(
                      fontSize: wsize * 0.06,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                     Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: wsize*0.04,
                    ),
                    SizedBox(
                      width: wsize * .4,
                      child:  AutoSizeText(
                        "230 W Olentangy St, Powell, OH 43065, USA",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: wsize*0.03,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                     Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.grey,
                      size: wsize*0.03,
                    )
                  ],
                ),
              ]),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: GestureDetector(
                onTap: () async {
                  print('print');
                  await FirebaseFirestore.instance
                      .collection('category')
                      .doc('Biryani & Rice').collection(' Biryani & Rice').get()
                      .then((QuerySnapshot snapShot) async {
                        print(snapShot.docs);
                    snapShot.docs.forEach((element) async {
                      await FirebaseFirestore.instance
                          .collection('category').doc('Biryani & Rice').collection('Biryani & Rice')
                          .doc(element.id)
                          .set(element.data()as Map<String, dynamic>);
                    });
                  });
                  // print(re);
                },
                child: Icon(
                  Icons.notifications_rounded,
                  color: AppConfig.primaryColor,
                  size: wsize * 0.09,
                ),
              )),
        )
      ]),
    ),
  );
}
