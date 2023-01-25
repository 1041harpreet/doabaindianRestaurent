import 'package:flutter/material.dart';
import 'package:restaurent.app/config/config.dart';

class GalleryPage extends StatelessWidget {
  GalleryPage({Key? key}) : super(key: key);
  var url =
      'https://firebasestorage.googleapis.com/v0/b/doabaindianrestaurent.appspot.com/o/gallery%2FInner-view-Restaurant.jpg?alt=media&token=97ccee59-d751-489d-a595-2dad0ae3d4b7';

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppConfig.secmainColor,
        appBar: AppBar(
          backgroundColor: AppConfig.primaryColor,
          title: Text(
            "Gallery",
            style: AppConfig.whitetext,
          ),
        ),
        body: Center(
          child: Text("No Image yet", style: AppConfig.blacktext),
        ));
  }
}
