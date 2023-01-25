import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget homeItem(wsize, hsize, item) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          margin: EdgeInsets.all(wsize * 0.02),
          // width: wsize/ 2.5,
          height: hsize / 5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(wsize * 0.025),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(2.0, 2.0),
                  color: Colors.black26,
                  blurRadius: wsize * .025)
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: item.img,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.black),
            ),
          )),
      Padding(
        padding: EdgeInsets.only(left: wsize * 0.02),
        child: SizedBox(
          width: wsize / 3,
          child: Text(
            item.title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      )
    ],
  );
}
