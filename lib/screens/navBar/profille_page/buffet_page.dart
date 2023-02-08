import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../config/const.dart';
import '../../../widgets/buffet.dart';

class BuffetPage extends StatelessWidget {
  const BuffetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.secmainColor,
      appBar: AppBar(backgroundColor: AppConfig.primaryColor),
      body: Center(child: buffet(Const.buffetImg)),
    );
  }
}
