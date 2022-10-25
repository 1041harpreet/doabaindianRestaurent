import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/screens/navBar/nav_bar.dart';


class LoaderScreen extends ConsumerWidget {
  LoaderScreen({Key? key}) : super(key: key);
  bool init = false;

  @override
  Scaffold build(BuildContext context, WidgetRef ref) {
    // final provider = ref.watch(authProvider);
    // final screenServiceProvider = ref.watch(screenProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // if (provider.loaded) {
      //   if (provider.token != null) {
      //     print('logged in');
      //     if (init == false) {
      //       init = true;
      //       await screenServiceProvider.getUserInfo();
      //       print(screenServiceProvider.userData[0].category);
      //       if (screenServiceProvider.userData[0].category == "Student" ) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => NavBar(),
                  ),
                      (route) => false);
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
                  child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(height: 16),
              Text("Loading...", style: TextStyle(color: AppConfig.primaryColor)),
            ],
          ),
        ),
      ),
    );
  }
}
