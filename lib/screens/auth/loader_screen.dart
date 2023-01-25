import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/screens/auth/login_screen.dart';
import 'package:restaurent.app/screens/navBar/nav_bar.dart';
import 'package:restaurent.app/widgets/shimmer.dart';

import '../../admin/admin_home_page.dart';
import '../../config/const.dart';
import '../../provider/auth_provider.dart';
import '../../services/connection_service.dart';

class LoaderScreen extends ConsumerStatefulWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends ConsumerState<LoaderScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(networkProvider).stream(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print('working loader screen');
      if (ref.watch(authProvider).user != null) {
        await ref
            .watch(authProvider)
            .getUserInfo(ref.watch(authProvider).user.email, true);
        if (Const.role == 'admin') {
          print('admin');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AdminHomePage(),
              ),
              (route) => false);
        }
        if (Const.role == 'user') {
          // await ref.watch(NavBarProvider).changeindex(0);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => NavBar(),
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
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: carsoulShimmer(context, wsize)),
              ),
              SizedBox(
                height: hsize / 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return homePageShimmer(context, wsize, hsize);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: carsoulShimmer(context, wsize)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Wait we are fetching information",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppConfig.primaryColor,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
