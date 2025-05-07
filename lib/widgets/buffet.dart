import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buffet(img) {

  return Container(
      // height: 500.0,
      padding: const EdgeInsets.all(8.0),
      child: CachedNetworkImage(
        imageUrl: img,
        placeholder: (context, url) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ],
          );
        },
        errorWidget: (context, url, error) =>
            const Icon(Icons.error, color: Colors.black),
      ));
}
