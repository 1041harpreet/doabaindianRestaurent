import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/cart_provider.dart';
import 'package:restaurent_app/provider/category_provider.dart';
import 'package:restaurent_app/provider/nav_bar_provider.dart';

import '../../../widgets/category_item.dart';
import '../../../widgets/shimmer.dart';
import '../home_page/categories/stream_builder_widget.dart';
import '../home_page/product_details_view.dart';
class FavouriteScreen extends ConsumerStatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends ConsumerState<FavouriteScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(categoryProvider).getFavouriteItem(ref.watch(cartProvider).email);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final hsize=MediaQuery.of(context).size.height;
    final wsize=MediaQuery.of(context).size.width;
    final navprovider=ref.watch(NavBarProvider);
    final cprovider=ref.watch(categoryProvider);

    return WillPopScope(
      onWillPop: () async {
        navprovider.changeindex(0);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppConfig.secmainColor,
          body:Column(children: [
            Padding(padding: const EdgeInsets.all(8.0), child: header(wsize)),
            Expanded(child:  Padding(
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
                  Builder(wsize,hsize,cprovider,context)
              ),
            ),)
          ],)
        ),
      ),
    );
  }
}


Widget Builder(wsize,hsize,cprovider,context){
  return Padding(
    padding: EdgeInsets.all(wsize * .03),
    child: SizedBox(
        height: hsize * .3,
        width: MediaQuery.of(context).size.width * 1,
        child: cprovider.favloading
            ? ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return categoryShimmer(wsize, hsize, context);
          },
        )
            : cprovider.favList.length==0
            ? Center(
          child: Text("No item here ",
              style: AppConfig.blackTitle),
        )
            : Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: ListView.builder(
              itemCount: cprovider.favList.length,
              itemBuilder: (context, index) {
                var item = cprovider.favList[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                ProductDetailsView(
                                    item: item,
                                    catname: cprovider.favList[index].category),
                          ));
                    },
                    child: Item(wsize, hsize, item,
                        cprovider, context));
              },
            ))),
  );
}
Widget header(wsize) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: AutoSizeText(
        "Favourite Items",
        style: TextStyle(color: Colors.black, fontSize: wsize * 0.1),
      ),
    )
  ]);
}
