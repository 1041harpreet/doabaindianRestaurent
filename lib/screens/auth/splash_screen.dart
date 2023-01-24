import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent.app/provider/auth_provider.dart';

import '../../services/notification_service/notification.dart';
import '../navBar/profille_page/main_Profile_screen.dart';
import 'loader_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
     Timer(
      const Duration(milliseconds: 250),
            () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoaderScreen(),
            )));
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child:richText(context) ),
    );
  }
}
Widget richText( context) {
  return Text.rich(
    TextSpan(
      style: GoogleFonts.inter(
        fontSize: MediaQuery.of(context).size.width*0.05,
        color: const Color(0xFF21899C),
        letterSpacing: 2.000000061035156,
      ),
      children: const [
        TextSpan(
          text: 'DOABA INDIAN ',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        TextSpan(
          text: 'RESTAURANT',
          style: TextStyle(
            color: Color(0xFFFE9879),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

