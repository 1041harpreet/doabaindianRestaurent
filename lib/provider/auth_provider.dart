import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent_app/screens/auth/login_screen.dart';
import 'package:restaurent_app/screens/navBar/nav_bar.dart';

import '../widgets/toast_service.dart';

class AuthService extends ChangeNotifier {
  bool signupload = false;
  bool signinload = false;

  signinloading( value) {
    signinload = value;
    notifyListeners();
  }
  signuploading( value) {
    signupload = value;
    notifyListeners();
  }

  FormGroup loginForm = FormGroup({
    "email": FormControl(
        // value: '1234567890',
        validators: [Validators.required, Validators.email]),
    'password': FormControl(
        // value: '123456',
        validators: [
          Validators.required,
        ]),
  });
  FormGroup SignUpForm = FormGroup({
    "email": FormControl(
        // value: '1234567890',
        validators: [Validators.required, Validators.email]),
    "name": FormControl(
        // value: '1234567890',
        validators: [
          Validators.required,
        ]),
    'password': FormControl(
        // value: '123456',
        validators: [
          Validators.required,
        ]),
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp(email, password, context) async {
    signuploading( true);
    try {
      await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) {});
      showSuccessToast(message: 'register successfully', context: context);

      return null;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      print(e.code);
      if (e.code == 'email-already-in-use') {
        print('already used email');
        showErrorToast(context: context, message: "Email already registered");
      }
      if (e.code == 'invalid-email') {
        showErrorToast(context: context, message: "Email is invalid");
      }
      if (e.code == 'weak-password') {
        showErrorToast(context: context, message: "Password is weak");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      signuploading( false);
      notifyListeners();
    }
  }

  //SIGN IN METHOD
  Future signIn(email, password, context) async {
    signinloading( true);
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => NavBar(),
            ),
            (route) => false);
        showSuccessToast(message: 'login successfully', context: context);
        notifyListeners();
      });
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        showErrorToast(
            context: context, message: "User not found, try another email");
      }
      if (e.code == 'invalid-email') {
        showErrorToast(context: context, message: "Email is wrong ");
      }
      if (e.code == 'wrong-password') {
        showErrorToast(context: context, message: "Password is wrong");
      }
      if (e.code == 'user-disabled') {
        showErrorToast(context: context, message: "User deactivated");
      } else {
        (e) {
          print(e.toString());
        };
      }
    } catch (e) {
      print(e.toString());
    } finally {
      signinloading( false);
      notifyListeners();
    }
  }

  //SIGN OUT METHOD
  Future signOut(context) async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false);
    showSuccessToast(message: 'Logout successfully', context: context);
    print('signout');
  }

  //CHANGE password
  void changePassword(
      String currentPassword, String newPassword, context) async {
    print('pressed');
    final user = FirebaseAuth.instance.currentUser;
    if(user==null){

    }else{
      final cred = EmailAuthProvider.credential(
          email: '1041harpreet@gmail.com', password: currentPassword);
      print(cred);
      user?.reauthenticateWithCredential(cred).then((value) {
        print(value);
        user.updatePassword(newPassword).then((_) {
          print(newPassword);
          showSuccessToast(
              context: context, message: "Password update successfully");
          //Success, do something
        }).catchError((error) {

          showErrorToast(message: "something went wrong", context: context);
          //Error, show something
        });
      }).catchError((err) {
        print(err);
        showErrorToast(message: "something went wrong", context: context);
      });
    }

  }
}
forgetPassword(){
  print('forget password');
}

final authProvider = ChangeNotifierProvider((ref) {
  var state = AuthService();
  print(state.user);
  return state;
});
