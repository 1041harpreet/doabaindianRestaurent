import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/widgets/category_item.dart';
import 'package:restaurent_app/screens/navBar/home_page/product_details_view.dart';

import '../../../../widgets/shimmer.dart';

Widget listBuilder(wsize,hsize,cprovider,catname,context){
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
         child: Text("No item here ",
             style: AppConfig.blackTitle),
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
                           builder: (context) =>
                               ProductDetailsView(
                                   item: item,
                                   catname: catname),
                         ));
                   },
                   child: Item(wsize, hsize, item,
                       cprovider, context));
             },
           ))),
 );
  // return StreamBuilder<dynamic>(
  //   stream: stream,
  //   builder: (context, snapshot) {
  //   if(snapshot.hasError){
  //     return Center(child: Text('Error occurred',style: AppConfig.blackTitle),);
  //   }
  //   if(snapshot.hasData){
  //     // return Center(child: CircularProgressIndicator());
  //     print(snapshot.data.docs.length);
  //     if(snapshot.data.docs.length==0){
  //       return Center(child: Text("No Item",style: AppConfig.blackTitle),);
  //     }
  //     return ListView.builder(
  //       // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  //       itemCount:  snapshot.data.docs.length,
  //       itemBuilder: (context, index) {
  //         DocumentSnapshot item = snapshot.data.docs[index];
  //         return GestureDetector(
  //             onTap: () {
  //               Navigator.push(context,
  //                   CupertinoPageRoute(builder: (context) =>ProductDetailsView(item: item,catname:catname),)
  //                  );
  //             },
  //             child: Item(wsize,hsize,item,provider,context));
  //     },);
  //   }else{
  //     return ListView.builder(
  //       itemCount: 10,
  //       scrollDirection: Axis.vertical,
  //       itemBuilder: (context, index) {
  //       return categoryShimmer(wsize,hsize,context);
  //     },);
  //
  //   }
  // },);
}
