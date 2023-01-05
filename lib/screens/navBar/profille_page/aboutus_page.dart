import 'package:flutter/material.dart';
import 'package:restaurent.app/config/config.dart';

import '../../../widgets/about_us.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppConfig.primaryColor),
      backgroundColor: AppConfig.secmainColor,
      body: SingleChildScrollView(child: aboutus()),
    );
  }
}
