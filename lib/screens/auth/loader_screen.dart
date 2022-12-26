import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/cart_provider.dart';
import 'package:restaurent_app/screens/auth/login_screen.dart';
import 'package:restaurent_app/screens/navBar/nav_bar.dart';

import '../../admin/admin_home_page.dart';
import '../../provider/auth_provider.dart';
import '../../services/connection_service.dart';
import '../../services/notification_service/notification.dart';
class LoaderScreen extends ConsumerStatefulWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends ConsumerState<LoaderScreen> {
 @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
     ref.watch(networkProvider).stream(context);
   });
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
     print('working loader screen');
     if (ref.watch(authProvider).user != null) {
       await ref.watch(authProvider).getUserInfo();
       if (ref.watch(authProvider).role == 'admin') {
         print('admin');
         Navigator.of(context).pushAndRemoveUntil(
             MaterialPageRoute(
               builder: (context) => const AdminHomePage(),
             ),
                 (route) => false);
       }
       if (ref.watch(authProvider).role == 'user') {
         Navigator.of(context).pushAndRemoveUntil(
             MaterialPageRoute(
               builder: (context) => const NavBar(),
             ),
                 (route) => false);
       }
     } else {
       Navigator.of(context).pushAndRemoveUntil(
           MaterialPageRoute(
             builder: (context) => const LoginScreen(),
           ),
               (route) => false);
     }
   });
    // TODO: implement initState
    super.initState();
  }

  @override
  Scaffold build(BuildContext context) {
    // final authprovider = ref.watch(authProvider);



    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppConfig.primaryColor,
                  )),
              const SizedBox(height: 16),
              Text("Loading...",
                  style: TextStyle(color: AppConfig.primaryColor)),
            ],
          ),
        ),
      ),
    );
  }
}
