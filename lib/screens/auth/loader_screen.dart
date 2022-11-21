import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/cart_provider.dart';
import 'package:restaurent_app/screens/auth/login_screen.dart';
import 'package:restaurent_app/screens/navBar/nav_bar.dart';

import '../../provider/auth_provider.dart';


class LoaderScreen extends ConsumerWidget {
  LoaderScreen({Key? key}) : super(key: key);
  bool init = false;

  @override
  Scaffold build(BuildContext context, WidgetRef ref) {
    final authprovider = ref.watch(authProvider);
    final cartprovider = ref.watch(cartProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(authprovider.user !=null){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const NavBar(),
            ),
                (route) => false);
      }else{
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
                (route) => false);
      }
      // if (provider.loaded) {
      //   if (provider.token != null) {
      //     print('logged in');
      //     if (init == false) {
      //       init = true;
      //       await screenServiceProvider.getUserInfo();
      //       print(screenServiceProvider.userData[0].category);
      //       if (screenServiceProvider.userData[0].category == "Student" ) {
      //         Navigator.of(context).pushAndRemoveUntil(
      //             MaterialPageRoute(
      //               builder: (context) => const NavBar(),
      //             ),
      //                 (route) => false);
      //       } else {
      //         Navigator.of(context).pushAndRemoveUntil(
      //             MaterialPageRoute(
      //               builder: (context) => NavBar(),
      //             ),
      //                 (route) => false);
      //       }
      //     }
      //   } else {
      //     print('login screen');
      //     Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(
      //           builder: (context) => LoginScreen(),
      //         ),
      //             (route) => false);
      //   }
      // }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:  [
               SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2,color: AppConfig.primaryColor,)),
              const SizedBox(height: 16),
              Text("Loading...", style: TextStyle(color: AppConfig.primaryColor)),
            ],
          ),
        ),
      ),
    );
  }
}
