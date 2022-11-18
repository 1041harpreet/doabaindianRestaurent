import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/widgets/category_item.dart';
import 'package:restaurent_app/screens/navBar/home_page/product_details_view.dart';

import '../../../../widgets/shimmer.dart';

Widget streamBuilder(stream,wsize,hsize,provider,catname){
  return StreamBuilder<dynamic>(
    stream: stream,
    builder: (context, snapshot) {
    if(snapshot.hasError){
      return Center(child: Text('Error occurred',style: AppConfig.blackTitle),);
    }
    if(snapshot.hasData){
      // return Center(child: CircularProgressIndicator());
      print(snapshot.data.docs.length);
      if(snapshot.data.docs.length==0){
        return Center(child: Text("No Item",style: AppConfig.blackTitle),);
      }
      return ListView.builder(
        itemCount:  snapshot.data.docs.length,
        itemBuilder: (context, index) {
          DocumentSnapshot item = snapshot.data.docs[index];
          return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsView(item: item,catname:catname),));
              },
              child: Item(wsize,hsize,item,provider,context));
      },);
    }else{
      return ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
        return categoryShimmer(wsize,hsize,context);
      },);

    }
  },);
}
