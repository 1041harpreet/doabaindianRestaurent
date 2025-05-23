import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/config.dart';

Widget Item(wsize, hsize, item, provider, context) {
  return Padding(
      padding: EdgeInsets.only(
          left: wsize * 0.02, right: wsize * 0.02, top: wsize * 0.03),
      child: Container(
        // width: wsize * .3,
        height: hsize * .145,
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
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child:
                        // ImageShimmer(context,wsize,hsize),
                        SizedBox(
                            width: wsize * 0.3,
                            child: Center(
                              child: buildImg(hsize, wsize, item.img),
                            )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: wsize * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: wsize * 0.04, top: wsize * 0.03),
                          child: item.title.toString().length > 20
                              ? AutoSizeText(
                                  '${item.title.toString().substring(0, 17)}...',
                                  maxLines: 1,
                                  style: GoogleFonts.mulish(
                                      fontWeight: FontWeight.w600,
                                      fontSize: wsize * 0.04,
                                      color: Colors.black87))
                              : AutoSizeText(item.title,
                                  maxLines: 1,
                                  style: GoogleFonts.mulish(
                                      fontWeight: FontWeight.w600,
                                      fontSize: wsize * 0.04,
                                      color: Colors.black87)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: wsize * 0.04, top: wsize * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AutoSizeText("Price : ",
                                  style: GoogleFonts.mulish(
                                      color: AppConfig.primaryColor,
                                      fontSize: wsize * 0.045,
                                      fontWeight: FontWeight.w500)),
                              AutoSizeText("\$${item.price}",
                                  style: GoogleFonts.mulish(
                                      color: Colors.black,
                                      fontSize: wsize * 0.045,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: wsize * 0.02),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppConfig.primaryColor,
                    size: 25,
                  ),
                ),
              )
            ]),
      ));
}

Widget buildImg(hsize, wsize, img) {
  return Container(
      // height: hsize * .216,
      // width: wsize * .38,
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
          imageUrl: img,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.black),
        ),
      ));
}
