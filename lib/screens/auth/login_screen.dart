import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent_app/screens/auth/sign_up_screen.dart';
import 'package:restaurent_app/screens/navBar/nav_bar.dart';
import 'package:restaurent_app/widgets/toast_service.dart';

import '../../config/config.dart';
import '../../provider/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final authprovider=ref.watch(authProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppConfig.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            //to give space from top
            const Expanded(
              flex: 1,
              child: Center(),
            ),

            //page content here
            Expanded(
              flex: 9,
              child: buildCard(size,authprovider,context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Size size,authprovider,context) {
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
          formGroup:authprovider.loginForm ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.02,
              ),
              //header text
              Text(
                'Login Account',
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
                'Discover your food & Try to Login',
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

              //email & password section
              textfieldbtn(size, 'Email', 'email',{
                ValidationMessage.required: (error) => "The email must not be empty",
                ValidationMessage.email: (error) => 'Please enter a valid email',

              }),
              SizedBox(
                height: size.height * 0.02,
              ),
              textfieldbtn(size, 'Password', 'password',{
                ValidationMessage.required: (error) => "The password must not be empty",
              }),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      print('click');
                      authprovider.resetPassword('1041harpreet@gmail.com');
                      // authprovider.updateEmail('1044harpreet@gmail.com');

                    },
                    child: Text(
                      'Forget Password?',
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        color: const Color(0xFF969AA8),
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: size.height * 0.03,
              ),
              //sign in button
              authprovider.signinload==true ? loadingButton(size):
              Button(size,"Sign in",Colors.white,AppConfig.primaryColor,(){
                if( authprovider.loginForm.valid){
                  authprovider.signIn(authprovider.loginForm.control('email').value,authprovider.loginForm.control('password').value,context);
                print('sign in');
                }
                else{
                  print('invalid');
                  authprovider.loginForm.markAllAsTouched();
                  showErrorToast(message: 'fill the detail first',context: context);
                }
                // Navigator.push(context, MaterialPageRoute(builder: (context) => NavBar(),));
              }),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                'or login with',
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: const Color(0xFF969AA8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Button(size,"sign up with Google",Colors.black,Colors.white,(){
                print('sign in with google');
              }),
              SizedBox(
                height: size.height * 0.02,
              ),
              //footer section. sign up text here
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),));
                  },
                  child: footerText()),
            ],
          ),
        ),
      ),
    );
  }

  Widget richText(double fontSize,) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF21899C),
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: 'DOABA INDIAN ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'RESTAURENT',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget textfieldbtn(Size size, lable, controlname,validation) {
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
        formControlName: controlname,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
          validationMessages: validation,
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

  Widget loadingButton(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppConfig.primaryColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C2E84).withOpacity(0.2),
            offset: const Offset(0, 15.0),
            blurRadius: 60.0,
          ),
        ],
      ),
      child: const Center(child: CircularProgressIndicator(color:Colors.white,))
    );
  }

  Widget Button(Size size,title,titlecolor,buttoncolor,ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        height: size.height * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: buttoncolor,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: titlecolor,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget footerText() {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: 12.0,
          color: const Color(0xFF3B4C68),
        ),
        children: const [
          TextSpan(
            text: 'Don’t have an account ?',
          ),
          TextSpan(
            text: ' ',
            style: TextStyle(
              color: Color(0xFFFF5844),
            ),
          ),
          TextSpan(
            text: 'Sign up',
            style: TextStyle(
              color: Color(0xFFFF5844),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
