import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget backButton(context) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0),
    child: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10.0)),
          width: 40.0,
          height: 40.0,
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.grey,
          )),
    ),
  );
}

Widget skipButton(context, authprovider) {
  return GestureDetector(
    onTap: () {
      authprovider.signInAnonymously(context);
    },
    child: Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: 15.0,
          color: const Color(0xFF3B4C68),
        ),
        children: const [
          TextSpan(
            text: 'Skip for now?',
          ),
          TextSpan(
            text: ' ',
            style: TextStyle(
              color: Color(0xFFFF5844),
            ),
          ),
          TextSpan(
            text: 'Skip',
            style: TextStyle(
              color: Color(0xFFFF5844),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
