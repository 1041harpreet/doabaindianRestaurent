import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'sign_up_screen.dart';
import '../../config/config.dart';
import '../../provider/auth_provider.dart';
import '../../widgets/toast_service.dart';

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
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
              textfieldbtn(size, 'Enter your gmail', 'email', {
                ValidationMessage.required: (error) =>
                "The email must not be empty",
              }),
              SizedBox(
                height: size.height * 0.02,
              ),

              authprovider.resetload == true
                  ? loadingButton(size)
                  : Button(
                  size, "Send", Colors.white, AppConfig.primaryColor,
                      () async {
                    print('sign up start');
                    if (authprovider.resetPasswordForm.valid) {
                      authprovider.resetPassword(authprovider.resetPasswordForm.control('email').value,context);
                      print('sign up end');
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

// Widget richText(
//     double fontSize,
//     ) {
//   return Text.rich(
//     TextSpan(
//       style: GoogleFonts.inter(
//         fontSize: fontSize,
//         color: const Color(0xFF21899C),
//         letterSpacing: 2.000000061035156,
//       ),
//       children: const [
//         TextSpan(
//           text: 'DOABA INDIAN ',
//           style: TextStyle(
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//         TextSpan(
//           text: 'RESTAURANT',
//           style: TextStyle(
//             color: Color(0xFFFE9879),
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ],
//     ),
//   );
// }
// Widget textfieldbtn(Size size, lable, controlname, validation) {
//   return Container(
//     alignment: Alignment.center,
//     height: size.height * 0.07,
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(8.0),
//       border: Border.all(
//         width: 1.0,
//         color: const Color(0xFFEFEFEF),
//       ),
//     ),
//     child: ReactiveTextField(
//       formControlName: controlname,
//       style: GoogleFonts.inter(
//         fontSize: 16.0,
//         color: const Color(0xFF15224F),
//       ),
//       validationMessages: validation,
//       maxLines: 1,
//       cursorColor: const Color(0xFF15224F),
//       decoration: InputDecoration(
//           labelText: lable,
//           labelStyle: GoogleFonts.inter(
//             fontSize: 12.0,
//             color: const Color(0xFF969AA8),
//           ),
//           border: InputBorder.none),
//     ),
//   );
// }

