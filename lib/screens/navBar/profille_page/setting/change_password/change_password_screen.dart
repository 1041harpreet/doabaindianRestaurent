import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../config/config.dart';
import '../../../../../provider/auth_provider.dart';
import '../../../../../widgets/toast_service.dart';
import '../../../../auth/sign_up_screen.dart';


class ChangePasswordScreen extends ConsumerWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authprovider = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppConfig.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            //to give space from top
            Expanded(
              flex: 1,
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      authprovider.changePasswordForm.reset();
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
                ),
              ]),
            ),

            //page content here
            Expanded(
              flex: 9,
              child: buildCard(size, authprovider, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Size size, authprovider, context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ReactiveForm(
          formGroup: authprovider.changePasswordForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.02,
              ),
              //header text
              Text(
                'Change Password',
                style: GoogleFonts.inter(
                  fontSize: 24.0,
                  color: const Color(0xFF15224F),
                  fontWeight: FontWeight.w600,
                ),
              ),
              //logo section
              SizedBox(
                height: size.height * 0.03,
              ),
              richText(20),
              SizedBox(
                height: size.height * 0.05,
              ),
              // //email & password section
              textfieldbtn(size, 'Current Password', 'current', {
                ValidationMessage.required: (error) =>
                "Current password must not be empty",
              }),
              SizedBox(
                height: size.height * 0.02,
              ),
              textfieldbtn(size, 'New Password', 'new', {
                ValidationMessage.required: (error) =>
                "New password must not be empty",
                ValidationMessage.minLength: (error) =>
                "Password length must be greater than 6.",

              }),
              SizedBox(
                height: size.height * 0.02,
              ),
              authprovider.changePasswordLoading == true
                  ? loadingButton(size)
                  : Button(
                  size, "Change Password", Colors.white, AppConfig.primaryColor,
                      () async {
                    if (authprovider.changePasswordForm.valid) {
                     await authprovider.changePassword(
                          authprovider.changePasswordForm.control('current').value,
                          authprovider.changePasswordForm.control('new').value,
                          context);

                    } else {
                      print('invalid');
                      authprovider.changePasswordForm.markAllAsTouched();
                      showErrorToast(
                          message: 'fill the details first', context: context);
                    }
                  }),




            ],
          ),
        ),
      ),
    );
  }



}


