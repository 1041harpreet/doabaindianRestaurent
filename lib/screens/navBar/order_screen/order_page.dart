import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/nav_bar_provider.dart';

class OrderPage extends ConsumerWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final navprovider=ref.watch(NavBarProvider);
    return WillPopScope(
      onWillPop: () async {
        navprovider.changeindex(0);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppConfig.secmainColor,
        body: Center(child: Text("No order yet",style: TextStyle(color: Colors.black)),),
      ),
    );
  }
}
