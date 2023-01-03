import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/auth_provider.dart';
import 'package:restaurent_app/provider/cart_provider.dart';
import 'package:restaurent_app/screens/navBar/home_page/categories/stream_builder_widget.dart';
import 'package:restaurent_app/screens/navBar/home_page/notification/main_notiification_page.dart';
import 'package:restaurent_app/widgets/buffet.dart';
import 'package:restaurent_app/widgets/home_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../provider/category_provider.dart';
import '../../../provider/home_provider.dart';
import '../../../services/notification_service/notification.dart';
import '../../../widgets/about_us.dart';
import '../../../widgets/shimmer.dart';
import 'carsoul_full_screen.dart';
import 'categories/category_items.dart';
import 'categories/all_category.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  var d;
  TextEditingController searchController = TextEditingController();

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(categoryProvider).getCategory();
      ref.watch(categoryProvider).getcarsoulItem();
      ref.watch(categoryProvider).getmadeforu();
      if(ref.watch(homeProvider).show) {
        _showNewOrderDialog();
        ref.watch(homeProvider).changeshow(false);
      }
    });
    super.initState();
  }
  _showNewOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)), //this right here
          child: buffet()
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryprovider = ref.watch(categoryProvider);
    final cartprovider = ref.watch(cartProvider);
    final authprovider = ref.watch(authProvider);
    final homeprovider = ref.watch(homeProvider);
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await dialogBox(context);
        return shouldPop!;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: AppConfig.secmainColor,
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          backgroundColor: Colors.green,
          onPressed: ()async{
          homeprovider.openwhatsapp();
        },
         child: Image.asset('assets/images/whats.png',fit: BoxFit.fill),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(wsize, hsize, homeprovider, categoryprovider, authprovider,
                  context),
              categoryprovider.carload ? carsoulShimmer(context, wsize):
              CarouselSlider(
                  options: CarouselOptions(
                    height: hsize * 0.3,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 400),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                  ),
                  items: <Widget>[
                    for (var i = 0; i < categoryprovider.carsoulList.length; i++)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CarsoulFullScreen(url: categoryprovider.carsoulList[i].img),));
                        },
                        child: CachedNetworkImage(
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) {
                          return   Image.asset('assets/images/placeholder.png');
                          },
                          imageUrl: categoryprovider.carsoulList[i].img,
                        fit: BoxFit.fill,
                        )
                      ),
                  ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0,left: wsize * .05),
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
                      child:  Text("See All",
                          style: TextStyle(color: Colors.grey.shade900)),
                    ),
                  ),
                ],
              ),
             listview(hsize, wsize, context, categoryprovider),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: wsize * .05),
                    child: Text(
                      "Made for You",
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
                      child:  Text("See all",
                          style: TextStyle(color: Colors.grey.shade900)),
                    ),
                  ),
                ],
              ),
              madeforulist(hsize, wsize, context, categoryprovider),

              aboutus(),
              ],
          ),
        ),
      )),
    );
  }
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
                  // categoryprovider.getAllFeedPosts();
                  Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return const NotificationPage();
                    },
                  ),
                  );

                },
                child: Icon(
                  Icons.notifications_on_sharp,
                  color: AppConfig.primaryColor,
                  size: wsize * 0.09,
                ),
              )),
        )
      ]),
    ),
  );
}

dialogBox(context) {
  return showDialog(
    context: context,
    builder: (context) => Theme(
      data: ThemeData(backgroundColor: Colors.white),
      child: AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to go back?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);

            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    ),
  );
}