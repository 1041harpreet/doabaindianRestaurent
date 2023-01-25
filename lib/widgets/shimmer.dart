import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmerEffectUI extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  var circular;

  MyShimmerEffectUI.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    required this.circular,
  }) : this.shapeBorder = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circular));

  MyShimmerEffectUI.circular(
      {super.key,
      this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  //  LinearGradient _shimmerGradient = LinearGradient(
  //   colors: [
  //     Color(0xFFEBEBF4),
  //     Color(0xFFF4F4F4),
  //     Color(0xFFEBEBF4),
  //   ],
  //   stops: [
  //     0.1,
  //     0.3,
  //     0.4,
  //   ],
  //   begin: Alignment(-1.0, -0.3),
  //   end: Alignment(1.0, 0.3),
  //   tileMode: TileMode.clamp,
  // );

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor:Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(seconds: 3),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey,
            shape: shapeBorder,
          ),
        ),
      );
}

Widget homePageShimmer(context, wsize, hsize) => Column(
      children: [
        Container(
          margin: const EdgeInsets.all(6),
          width:hsize/6,
          height: hsize / 6,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),border: Border.all(color: Colors.black12)),
          child: MyShimmerEffectUI.rectangular(height: 50.0, circular: 20.0),
        ),
        SizedBox(
            width: wsize / 2.8,
            child: MyShimmerEffectUI.rectangular(
              height: 25.0,
              circular: 0.0,
            ))
      ],
    );

Widget ImageShimmer(context, wsize, hsize) => Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2.0),
          width: wsize * 0.3,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: MyShimmerEffectUI.rectangular(
              height: wsize * 0.3, circular: 20.0),
        ),
      ],
    );

Widget categoryShimmer(wsize, hsize, context) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
    child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: MyShimmerEffectUI.rectangular(
            height: wsize * 0.28, width: wsize * 0.28, circular: 10.0),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(left:wsize*0.02,top: wsize*0.05),
            child: MyShimmerEffectUI.rectangular(
                height: wsize * 0.048, width: wsize * 0.4, circular: 0.0),
          ),
          Padding(
            padding:  EdgeInsets.only(left:wsize*0.02,top: wsize*0.015),
            child: MyShimmerEffectUI.rectangular(
                height: wsize * 0.045, width: wsize * 0.35, circular: 0.0),
          ),

        ],
      ),
          Padding(
            padding:  EdgeInsets.only(left:wsize*0.05,top: wsize*0.1),
            child: MyShimmerEffectUI.rectangular(
                height: wsize * 0.1, width: wsize * 0.1, circular: 5.0),
          )
    ]),
  );

}
Widget checkoutshimmer(context,wsize)
{
  return ListTile(
    leading:
    MyShimmerEffectUI.rectangular(height: 150, width:wsize, circular: 10.0),
    title: Align(
      alignment: Alignment.centerLeft,
      child: MyShimmerEffectUI.rectangular(
          height: 18,
          circular: 0.0,
          width: MediaQuery.of(context).size.width * 0.35),
    ),
    subtitle: MyShimmerEffectUI.rectangular(
        height: 16,
        width: MediaQuery.of(context).size.width * 0.3,
        circular: 0.0),
  );
}

Widget carsoulShimmer(context,wsize)
{
  return MyShimmerEffectUI.rectangular(height: 200, width:wsize*0.9, circular: 10.0);
}
Widget tabShimmer(){
  return MyShimmerEffectUI.rectangular(height: 30.0,width: 50.0, circular: 2.0);
}