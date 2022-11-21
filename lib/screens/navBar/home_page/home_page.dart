import 'package:auto_animated/auto_animated.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/config/const.dart';
import 'package:restaurent_app/provider/auth_provider.dart';
import 'package:restaurent_app/provider/cart_provider.dart';
import 'package:restaurent_app/widgets/home_item.dart';
import 'package:restaurent_app/screens/navBar/order_screen/order_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../provider/category_provider.dart';
import '../../../provider/home_provider.dart';
import '../../../services/notification_service/notification.dart';
import '../../../widgets/shimmer.dart';
import 'categories/category_items.dart';
import 'categories/all_category.dart';
import 'package:maps_launcher/maps_launcher.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  var d;
  TextEditingController searchController = TextEditingController();
  final options = const LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 0),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 30),

    // Animation duration (default 250)
    showItemDuration: Duration(microseconds: 30),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.01,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(categoryProvider).getCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoryprovider = ref.watch(categoryProvider);
    final cartprovider = ref.watch(cartProvider);
    final authprovider = ref.watch(authProvider);

    final homeprovider = ref.watch(homeProvider);

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
            header(wsize, hsize, homeprovider, categoryprovider, authprovider,
                context),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  height: 50.0,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search any food",

                      hintStyle: TextStyle(color: AppConfig.primaryColor),
                      prefixIcon:
                          Icon(Icons.search, color: AppConfig.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: AppConfig.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: AppConfig.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: AppConfig.primaryColor),
                      ),
                      // prefixIcon:
                    ),
                  ),
                )),
            CarouselSlider(
                options: CarouselOptions(
                  height: hsize * 0.25,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
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
                  onTap: () async {
                    // cartprovider.Total();
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
                                // DocumentSnapshot item = snapshot.data.docs[index];
                                // print(item);
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
                                                      CategoryItems(
                                                          name: categoryprovider
                                                              .category[index]
                                                              .title)));
                                        },
                                        child: homeItem(wsize, hsize,
                                            categoryprovider.category[index]),
                                      )),
                                );
                              }),
                        )

                  // StreamBuilder<dynamic>(
                  //           stream: FirebaseFirestore.instance
                  //               .collection('category')
                  //               .snapshots(),
                  //           builder: (context, AsyncSnapshot snapshot) {
                  //             if (!snapshot.hasData) {
                  //               return ListView.builder(
                  //                 scrollDirection: Axis.horizontal,
                  //                 itemCount: 8,
                  //                 itemBuilder: (context, index) {
                  //                   return homePageShimmer(context, wsize, hsize);
                  //                 },
                  //               );
                  //               // return Center(
                  //               //   child: Column(
                  //               //     mainAxisSize: MainAxisSize.min,
                  //               //     children: [
                  //               //       SizedBox(
                  //               //           width: 24,
                  //               //           height: 24,
                  //               //           child: CircularProgressIndicator(
                  //               //             strokeWidth: 2,
                  //               //             color: AppConfig.primaryColor,
                  //               //           )),
                  //               //       const SizedBox(height: 16),
                  //               //       Text("Loading...",
                  //               //           style:
                  //               //               TextStyle(color: AppConfig.primaryColor)),
                  //               //     ],
                  //               //   ),
                  //               // );
                  //             }
                  //             if (snapshot.hasError) {
                  //               return Text(
                  //                 'error',
                  //                 style: AppConfig.blackTitle,
                  //               );
                  //             }
                  //             return Padding(
                  //               padding: const EdgeInsets.only(top: 5.0),
                  //               child: LiveList.options(
                  //                   options: options,
                  //                   itemCount: snapshot.data.docs.length,
                  //                   scrollDirection: Axis.horizontal,
                  //                   itemBuilder: (context, index, animation) {
                  //                     DocumentSnapshot item = snapshot.data.docs[index];
                  //                     print(item);
                  //                     return FadeTransition(
                  //                       opacity: Tween<double>(
                  //                         begin: 0,
                  //                         end: 1,
                  //                       ).animate(animation),
                  //                       // And slide transition
                  //                       child: SlideTransition(
                  //                           position: Tween<Offset>(
                  //                             begin: const Offset(0, -0.1),
                  //                             end: Offset.zero,
                  //                           ).animate(animation),
                  //                           // Paste you Widget
                  //                           child: GestureDetector(
                  //                             onTap: () {
                  //                               Navigator.push(
                  //                                   context,
                  //                                   MaterialPageRoute(
                  //                                       builder: (context) =>
                  //                                           CategoryItems(
                  //                                               name: item['title'])));
                  //                             },
                  //                             child: homeItem(wsize, hsize, item),
                  //                           )),
                  //                     );
                  //                   }),
                  //             );
                  //           }),
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
                  onTap: () async {
                    // cartprovider.Total();
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
                                // DocumentSnapshot item = snapshot.data.docs[index];
                                // print(item);
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
                                                      CategoryItems(
                                                          name: categoryprovider
                                                              .category[index]
                                                              .title)));
                                        },
                                        child: homeItem(wsize, hsize,
                                            categoryprovider.category[index]),
                                      )),
                                );
                              }),
                        )

                  // StreamBuilder<dynamic>(
                  //           stream: FirebaseFirestore.instance
                  //               .collection('category')
                  //               .snapshots(),
                  //           builder: (context, AsyncSnapshot snapshot) {
                  //             if (!snapshot.hasData) {
                  //               return ListView.builder(
                  //                 scrollDirection: Axis.horizontal,
                  //                 itemCount: 8,
                  //                 itemBuilder: (context, index) {
                  //                   return homePageShimmer(context, wsize, hsize);
                  //                 },
                  //               );
                  //               // return Center(
                  //               //   child: Column(
                  //               //     mainAxisSize: MainAxisSize.min,
                  //               //     children: [
                  //               //       SizedBox(
                  //               //           width: 24,
                  //               //           height: 24,
                  //               //           child: CircularProgressIndicator(
                  //               //             strokeWidth: 2,
                  //               //             color: AppConfig.primaryColor,
                  //               //           )),
                  //               //       const SizedBox(height: 16),
                  //               //       Text("Loading...",
                  //               //           style:
                  //               //               TextStyle(color: AppConfig.primaryColor)),
                  //               //     ],
                  //               //   ),
                  //               // );
                  //             }
                  //             if (snapshot.hasError) {
                  //               return Text(
                  //                 'error',
                  //                 style: AppConfig.blackTitle,
                  //               );
                  //             }
                  //             return Padding(
                  //               padding: const EdgeInsets.only(top: 5.0),
                  //               child: LiveList.options(
                  //                   options: options,
                  //                   itemCount: snapshot.data.docs.length,
                  //                   scrollDirection: Axis.horizontal,
                  //                   itemBuilder: (context, index, animation) {
                  //                     DocumentSnapshot item = snapshot.data.docs[index];
                  //                     print(item);
                  //                     return FadeTransition(
                  //                       opacity: Tween<double>(
                  //                         begin: 0,
                  //                         end: 1,
                  //                       ).animate(animation),
                  //                       // And slide transition
                  //                       child: SlideTransition(
                  //                           position: Tween<Offset>(
                  //                             begin: const Offset(0, -0.1),
                  //                             end: Offset.zero,
                  //                           ).animate(animation),
                  //                           // Paste you Widget
                  //                           child: GestureDetector(
                  //                             onTap: () {
                  //                               Navigator.push(
                  //                                   context,
                  //                                   MaterialPageRoute(
                  //                                       builder: (context) =>
                  //                                           CategoryItems(
                  //                                               name: item['title'])));
                  //                             },
                  //                             child: homeItem(wsize, hsize, item),
                  //                           )),
                  //                     );
                  //                   }),
                  //             );
                  //           }),
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset("assets/images/banner.jpg"),
            )
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

Widget header(
    wsize, hsize, homeprovider, categoryprovider, authprovider, context) {
  return Padding(
    padding: EdgeInsets.only(
        top: wsize * 0.03, right: wsize * 0.03, left: wsize * 0.03),
    child: SizedBox(
      height: hsize * .1,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: EdgeInsets.all(wsize * 0.02),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: wsize * 0.045,
                      color: const Color(0xFF21899C),
                      letterSpacing: 2.000000061035156,
                    ),
                    children: const [
                      TextSpan(
                        text: 'DOABA INDIAN ',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: 'RESTAURANT',
                        style: TextStyle(
                          color: Color(0xFFFE9879),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: wsize * 0.04,
                    ),
                    SizedBox(
                      width: wsize * .4,
                      child: GestureDetector(
                        onTap: () async {
                          homeprovider.openMap();
                        },
                        child: AutoSizeText(
                          "230 W Olentangy St, Powell, OH 43065, USA",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: wsize * 0.03,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.grey,
                      size: wsize * 0.03,
                    )
                  ],
                ),
              ]),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: GestureDetector(
                onTap: () async {
                  NotificationController.createNewNotification(context);
                  // await authprovider.changePassword(
                  //     '1234567', '12345678', context);

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
