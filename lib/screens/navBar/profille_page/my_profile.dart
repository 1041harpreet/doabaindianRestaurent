import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/auth_provider.dart';

class MyProfile extends ConsumerWidget {
  const MyProfile({Key? key}) : super(key: key);

  Widget buildImage(onpressed) {
    const image = AssetImage("assets/images/avatar.png");

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onpressed),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authprovider = ref.watch(authProvider);
    final size=MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppConfig.primaryColor,
          actions: [
          ],
          // backgroundColor: Colors.white,
        ),
        body: ReactiveForm(
            formGroup: authprovider.updateProfile,
            child: Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            buildImage(() {}),
                            // isEdit ?
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: buildEditIcon(Colors.grey),
                            )
                            // : SizedBox(width: 0,height: 0,)
                          ],
                        ),
                        const SizedBox(height: 16),
                        textfieldbtn(size, 'Username', 'username'),
                        const SizedBox(height: 16),
                        textfieldbtn(size, 'Email', 'email'),
                        const SizedBox(height: 16),
                        textfieldbtn(size, 'Phone No', 'phone'),
                      ],
                    ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}

Widget textfieldbtn(Size size, lable, controlname) {
  return Container(
    alignment: Alignment.center,
    height: size.height * 0.07,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        width: 1.0,
        color: const Color(0xFFEFEFEF),
      ),
    ),
    child: ReactiveTextField(
      readOnly: true,
      formControlName: controlname,
      style: GoogleFonts.inter(
        fontSize: 16.0,
        color: const Color(0xFF15224F),
      ),
      maxLines: 1,
      cursorColor: const Color(0xFF15224F),
      decoration: InputDecoration(
          labelText: lable,
          labelStyle: GoogleFonts.inter(
            fontSize: 12.0,
            color: const Color(0xFF969AA8),
          ),
          border: InputBorder.none),
    ),
  );
}
