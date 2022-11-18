import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/category_provider.dart';

import 'stream_builder_widget.dart';

class CategoryItems extends ConsumerWidget {
  String name;

  CategoryItems({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  name,
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
                child: streamBuilder(
                    FirebaseFirestore.instance
                        .collection('category')
                        .doc(name)
                        .collection(name)
                        .snapshots(),
                    wsize,
                    hsize,
                    cprovider,name),
              ),
            ),
          ),

        ]),
      ),
    );
  }
}
