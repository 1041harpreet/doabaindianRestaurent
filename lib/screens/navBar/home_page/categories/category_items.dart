import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/category_provider.dart';

import '../../../../widgets/category_item.dart';
import '../../../../widgets/shimmer.dart';
import '../product_details_view.dart';
import 'builder.dart';
class CategoryItems extends ConsumerStatefulWidget {
  String name;
  int index;
   CategoryItems({Key? key,required this.name,required this.index}) : super(key: key);

  @override
  ConsumerState<CategoryItems> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends ConsumerState<CategoryItems> {


@override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    ref.watch(categoryProvider).getsubcategory(widget.name);
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cprovider = ref.watch(categoryProvider);
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConfig.secmainColor,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: wsize * 0.05,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
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
                    listBuilder(

                        wsize,
                        hsize,
                        cprovider,widget.name,context),
                  ),
            ),
          ),
        ]),
      ),
    );
  }
}
