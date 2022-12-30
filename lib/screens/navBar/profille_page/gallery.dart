import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/screens/navBar/home_page/carsoul_full_screen.dart';
import 'package:restaurent_app/widgets/shimmer.dart';

class GalleryPage extends StatelessWidget {
   GalleryPage({Key? key}) : super(key: key);
  var url='https://firebasestorage.googleapis.com/v0/b/doabaindianrestaurent.appspot.com/o/gallery%2FInner-view-Restaurant.jpg?alt=media&token=97ccee59-d751-489d-a595-2dad0ae3d4b7';
  @override
  Widget build(BuildContext context) {
    final wsize=MediaQuery.of(context).size.width;
    return  Scaffold(
backgroundColor: AppConfig.secmainColor,
      appBar: AppBar(
          backgroundColor: AppConfig.primaryColor,
          title: Text("Gallery",style: AppConfig.whitetext,),
      ),
      body: ListView.builder(
         scrollDirection: Axis.vertical,
        itemCount: 10,
        itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CarsoulFullScreen(url: url,),));
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: CachedNetworkImage(
              imageUrl: url,
              errorWidget: (context, url, error) {
                return Text(" Something error",style: AppConfig.blacktext,);
              },
              placeholder: (context, url)  {
                return  Center(child: carsoulShimmer(context, wsize),);
              },
            ),
          ),
        );
      },)
    );
  }
}
