import 'package:auto_animated/auto_animated.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:restaurentapp/config/config.dart';
import 'package:restaurentapp/screens/navBar/home_page/categories/stream_builder_widget.dart';

import '../../../../provider/category_provider.dart';
import '../../../../widgets/home_item.dart';
import '../../../../widgets/shimmer.dart';
import '../product_details_view.dart';
import 'category_items.dart';
import '../../../../widgets/category_item.dart';

class MoreCategory extends ConsumerStatefulWidget {
  int index;

  MoreCategory({Key? key, required this.index}) : super(key: key);

  @override
  ConsumerState<MoreCategory> createState() => _MoreCategoryState();
}

class _MoreCategoryState extends ConsumerState<MoreCategory>
    with TickerProviderStateMixin {
  late TabController _controller;
  final options = const LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 0),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 10),

    // Animation duration (default 250)
    showItemDuration: Duration(microseconds: 10),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.01,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );

  late int selectedIndex;

  @override
  void initState() {
    print(widget.index);
    selectedIndex = widget.index;
    print(selectedIndex);
    _controller =
        TabController(length: 13, vsync: this, initialIndex: selectedIndex);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
     await ref.watch(categoryProvider).getsubcategory(await ref.watch(categoryProvider).catogries[selectedIndex]);
    });
    _controller.addListener(()async {
      ref.watch(categoryProvider).subloading==true;
      print(_controller.index);
        await ref.watch(categoryProvider).getsubcategory(await ref.watch(categoryProvider).catogries[_controller.index]);
        print(ref.watch(categoryProvider).subcategory);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cprovider = ref.watch(categoryProvider);
    final wsize = MediaQuery
        .of(context)
        .size
        .width;
    final hsize = MediaQuery
        .of(context)
        .size
        .height;
    return SafeArea(
        child: Scaffold(
          backgroundColor: AppConfig.secmainColor,
          body: Column(
            children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 40.0,
                        height: 40.0,
                        child: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.grey,
                        )),
                  ),
                ),
                SizedBox(
                  height: 70.0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: wsize * 0.04),
                          child: const AutoSizeText(
                            "Categories",
                            style: TextStyle(fontSize: 30.0, color: Colors
                                .black),
                          ),
                        ),
                      ]),
                ),
              ]),
              DecoratedBox(
                decoration: BoxDecoration(
                  //This is for background color
                  color: Colors.black.withOpacity(0.01),
                  //This is for bottom border that is needed
                  border: Border(
                      top: BorderSide(
                          color: AppConfig.blackColor.withOpacity(0.2)),
                      bottom:
                      BorderSide(color: AppConfig.blackColor.withOpacity(0.2))),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBar(
                        isScrollable: true,
                        controller: _controller,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                          // color: AppConfig.primaryColor,
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: cprovider.catogries
                            .map((e) =>
                            Tab(
                              child: Text(e),
                            ))
                            .toList())),
              ),
              Expanded(
                child: TabBarView(

                    controller: _controller,
                    children: cprovider.catogries
                        .map(
                          (e) =>
                      listBuilder(wsize,hsize,cprovider,cprovider.catogries[_controller.index],context),
                    )
                        .toList()),
              ),
            ],
          ),
        ));
  }
}
