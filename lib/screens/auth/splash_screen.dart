import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'loader_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
            () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoaderScreen(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SvgPicture.asset('assets/images/bm_logo.svg'),
    );
  }
}
