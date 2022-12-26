import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent_app/provider/cart_provider.dart';
import 'package:restaurent_app/screens/auth/login_screen.dart';
import 'package:restaurent_app/screens/navBar/nav_bar.dart';
import 'package:restaurent_app/services/notification_service/notification.dart';

import '../admin/admin_home_page.dart';
import '../widgets/toast_service.dart';

class AuthService extends ChangeNotifier {
  bool signupload = false;
  bool signinload = false;
  bool resetload = false;

  resetloading(value) {
    resetload = value;
    notifyListeners();
  }

  signinloading(value) {
    signinload = value;
    notifyListeners();
  }

  signuploading(value) {
    signupload = value;
    notifyListeners();
  }

  FormGroup updateProfile = FormGroup({
    "email": FormControl(
        // value: '1234567890',
        validators: [Validators.required, Validators.email]),
    'phone': FormControl(
        // value: '123456',
        validators: [
          Validators.required,
        ]),
    'username': FormControl(
        // value: '123456',
        validators: [
          Validators.required,
        ]),
  });
  FormGroup resetPasswordForm = FormGroup({
    "email": FormControl(validators: [Validators.required, Validators.email]),
  });
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
    "email": FormControl(validators: [Validators.required, Validators.email]),
    "name": FormControl(validators: [
      Validators.required,
    ]),
    "phone": FormControl(validators: [
      Validators.required,
    ]),
    'password': FormControl(validators: [
      Validators.required,
    ]),
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  storeToken(email) async {
    var token = await NotificationController().requestFirebaseToken();
    print(token);
    await FirebaseFirestore.instance
        .collection('token')
        .doc(email)
        .set({"token": token});
    notifyListeners();
  }

  //SIGN UP METHOD
  Future signUp(email, password, context, username, phone) async {
    signuploading(true);
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        if (role == 'admin') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AdminHomePage(),
              ),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const NavBar(),
              ),
              (route) => false);
        }

        await adduser(email, username, phone);
        await getUserInfo();
        await setInitialTotal(email);
        notifyListeners();
      });
      showSuccessToast(message: 'register successfully', context: context);
      print(_auth.currentUser?.email);

      return null;
    } on FirebaseAuthException catch (e) {
      // print(e.toString());
      print(e.code);
      if (e.code == "network-request-failed") {
        showErrorToast(context: context, message: "No internet Connection");
      }
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
      signuploading(false);
      notifyListeners();
    }
  }

  adduser(email, username, phone) async {
    await FirebaseFirestore.instance.collection('users').doc(email).set(
        {"email": email, "username": username, "phone": phone, 'role': "user"});
    notifyListeners();
  }

  //SIGN IN METHOD
  Future signIn(email, password, context) async {
    signinloading(true);
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await getUserInfo();
        if (role == 'admin') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AdminHomePage(),
              ),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const NavBar(),
              ),
              (route) => false);
        }

        showSuccessToast(message: 'login successfully', context: context);
        notifyListeners();
      });
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "network-request-failed") {
        showErrorToast(context: context, message: "No internet Connection");
      }
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
      signinloading(false);
      notifyListeners();
    }
  }

  //SIGN OUT METHOD
  Future signOut(context) async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
    await AwesomeNotificationsFcm().unsubscribeToTopic('all');
    showSuccessToast(message: 'Logout successfully', context: context);
    print('signout');
  }

  //CHANGE password
  changePassword(String currentPassword, String newPassword, context) async {
    print('pressed');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
    } else {
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

  resetPassword(email, context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        showSuccessToast(message: "link sent successfully", context: context);
        print('done');
      });
    } catch (e) {
      print(e.toString());
      showErrorToast(
          message: "link sent failed,check your email", context: context);
    }
  }

  updateEmail(newemail) {
    try {
      _auth.currentUser!.updateEmail(newemail).then((value) {
        print('success');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  googleSignIn() {}

  setInitialTotal(email) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(email)
          .set({"subtotal": 0.0, "total": 0.0, "status": false});

      notifyListeners();
    } catch (e) {
      print('get total error');
      print(e.toString());
    }
  }

  var phone;
  String username = '';
  String role = 'user';

  getUserInfo() async {
    try {
      print('getting user info');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.email)
          .get()
          .then((value) async {
        phone = value.get('phone');
        username = value.get('username');
        role = value.get('role');
        await storeToken(_auth.currentUser?.email);
        print('my role is $role');
        print(phone);
        print(username);
      });
    } catch (e) {
      print("error $e");
    }
  }
}

final authProvider = ChangeNotifierProvider((ref) {
  var state = AuthService();
  print("user is ${state.user}");
  return state;
});
