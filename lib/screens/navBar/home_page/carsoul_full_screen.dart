import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurent.app/config/config.dart';

import '../../../widgets/shimmer.dart';

class CarsoulFullScreen extends StatelessWidget {
  String url;

  CarsoulFullScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: url,
          errorWidget: (context, url, error) {
            return Text(
              " Something error",
              style: AppConfig.blacktext,
            );
          },
          placeholder: (context, url) {
            return Center(
              child: carsoulShimmer(context, wsize),
            );
          },
        ),
      ),
    );
  }
}
