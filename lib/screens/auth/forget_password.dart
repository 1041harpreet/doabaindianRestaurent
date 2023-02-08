import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../config/config.dart';
import '../../provider/auth_provider.dart';
import '../../widgets/back_button.dart';
import '../../widgets/toast_service.dart';
import 'sign_up_screen.dart';



class ForgetPasswordScreen extends ConsumerWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

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
                backButton(context),

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
          formGroup: authprovider.resetPasswordForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.02,
              ),
              //header text
              Text(
                'Find Your Account',
                style: GoogleFonts.inter(
                  fontSize: 24.0,
                  color: const Color(0xFF15224F),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                'Enter your Email link to your account',
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: const Color(0xFF969AA8),
                ),
                textAlign: TextAlign.center,
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
              textfieldbtn(
                  size,
                  'Enter your gmail',
                  'email',
                  {
                    ValidationMessage.required: (error) =>
                        "The email must not be empty",
                  },
                  false),
              SizedBox(
                height: size.height * 0.02,
              ),

              authprovider.resetload == true
                  ? loadingButton(size)
                  : Button(size, "Send", Colors.white, AppConfig.primaryColor,
                      () async {
                      if (authprovider.resetPasswordForm.valid) {
                        await authprovider.resetPassword(
                            authprovider.resetPasswordForm
                                .control('email')
                                .value,
                            context);
                      } else {
                        print('invalid');
                        authprovider.resetPasswordForm.markAllAsTouched();
                        showErrorToast(
                            message: 'fill the email first', context: context);
                      }
                    }),
            ],
          ),
        ),
      ),
    );
  }
}


