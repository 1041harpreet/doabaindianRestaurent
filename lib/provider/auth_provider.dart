import 'dart:io';

import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent.app/provider/nav_bar_provider.dart';
import 'package:restaurent.app/provider/notification_provider.dart';
import 'package:restaurent.app/screens/auth/login_screen.dart';
import 'package:restaurent.app/screens/navBar/nav_bar.dart';
import 'package:restaurent.app/screens/navBar/profille_page/setting/notification/notification_setting_provider.dart';
import 'package:restaurent.app/services/mail_services.dart';
import 'package:restaurent.app/services/notification_service/notification.dart';

import '../admin/admin_home_page.dart';
import '../config/const.dart';
import '../widgets/toast_service.dart';
import 'cart_provider.dart';

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
          Validators.number,
          Validators.maxLength(12),
          Validators.minLength(10),
        ]),
    'username': FormControl(
        // value: '123456',
        validators: [
          Validators.required,
        ]),
    'img': FormControl(),
  });
  FormGroup myProfile = FormGroup({
    "email": FormControl(validators: [Validators.required, Validators.email]),
    'phone': FormControl(validators: [
      Validators.required,
    ]),
    'username': FormControl(validators: [
      Validators.required,
    ]),
    'img': FormControl(),
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
      Validators.minLength(10),
      Validators.number,
      Validators.maxLength(12)
    ]),
    'password': FormControl(validators: [
      Validators.required,
      Validators.minLength(6)
    ]),
  });
  FormGroup changePasswordForm = FormGroup({
    "current": FormControl(validators: [Validators.required]),
    "new":
        FormControl(validators: [Validators.required, Validators.minLength(6)]),
  });

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  storeToken(email) async {
    try {
      var token = await NotificationController().requestFirebaseToken();
      print(token);
      await FirebaseFirestore.instance
          .collection('token')
          .doc(email)
          .set({"token": token});
    } catch (e) {
      print(e);
    }
  }

  //  signInWithGoogle(context) async {
  //    final GoogleSignIn googleSignIn = GoogleSignIn();
  //    await googleSignIn.signOut().then((value) {
  //      print('sign out complete');
  //    });
  //   try{
  //     await googleSignIn.signIn().then((value) async {
  //      await Auth().writeSecureData(value?.id);
  //       print('working');
  //     await adduser(value?.email, value?.displayName, '',value?.photoUrl);
  //       await getUserInfo(value?.email);
  //       await setInitialTotal(value?.email);
  //       print(value?.email);
  //       print(value?.displayName);
  //       print(value?.photoUrl);
  //     });
  //
  //   }catch(e){
  //     showErrorToast(message: "Something went wrong",context: context);
  //     print(e);
  //   }
  //
  // }

  //SIGN UP METHOD
  signUp(email, password, context, username, phone) async {
    signuploading(true);
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        await adduser(email, username, phone, '');
        await getUserInfo(_auth.currentUser?.email, true);
        await setInitialTotal(email);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const NavBar(),
            ),
            (route) => false);
        NotificationSettingService().writeValue(true);
      });
      SignUpForm.reset();
      showSuccessToast(message: 'register successfully', context: context);
      print(_auth.currentUser?.email);
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

  adduser(email, username, phone, img) async {
    await _firestore.collection('users').doc(email).set({
      "email": email,
      "username": username,
      "phone": phone,
      'role': "user",
      "img": img
    });
  }

  deleteUser() async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.email)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  //SIGN IN METHOD
  signIn(email, password, context) async {
    signinloading(true);
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await getUserInfo(email, true);
        if (Const.role == 'admin') {
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
        loginForm.reset();
        showSuccessToast(message: 'login successfully', context: context);
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "network-request-failed") {
        showErrorToast(context: context, message: "No internet Connection");
      }
      if (e.code == 'user-not-found') {
        showErrorToast(context: context, message: "User not found");
      }
      if (e.code == 'invalid-email') {
        showErrorToast(context: context, message: "Email/password is wrong ");
      }
      if (e.code == 'wrong-password') {
        showErrorToast(context: context, message: "email/Password is wrong");
      }
      if (e.code == 'user-disabled') {
        showErrorToast(context: context, message: "User deactivated");
      } else {
        (e) {
          showErrorToast(context: context, message: "Something Went wrong");

          print(e.toString());
        };
      }
    } catch (e) {
      showErrorToast(context: context, message: "Something went wrong");

      print(e.toString());
    } finally {
      signinloading(false);
      notifyListeners();
    }
  }

  //SIGN OUT METHOD
  Future signOut(context) async {
    await _auth.signOut();
    showSuccessToast(message: 'Logout successfully', context: context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
    await AwesomeNotificationsFcm().unsubscribeToTopic('all');
    print('signout');
  }

  //delete account
  bool deleteload = false;

  changeDeleteLoad(value) {
    deleteload = value;
    notifyListeners();
  }

  deleteAccount(context, currentPassword) async {
    changeDeleteLoad(true);
    try {
      if (user == null) {
      } else {
        final cred = EmailAuthProvider.credential(
            email: user.email!, password: currentPassword);
        print(cred);
        user?.reauthenticateWithCredential(cred).then((value) async {
          print(value);
          await NotificationService().deleteToken();
          await deleteUser();
          _auth.currentUser?.delete().then((value) async {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false);
            NotificationSettingService().unSubscribeNotification();
            MailService().devMail(Const.username, Const.email);
          }).catchError((err) {
            print(err);
            showErrorToast(message: "something went wrong", context: context);
          });
        }).catchError((value) {
          showErrorToast(
              message: "Something went wrong,check your Password",
              context: context);

          print(value);
        });
      }
      changeDeleteLoad(false);
    } catch (e) {
      print(e);
      changeDeleteLoad(false);
      showErrorToast(context: context, message: "Something went wrong");
    } finally {
      notifyListeners();
    }
  }

//change password
  bool changePasswordLoading = false;

  changePLoading(value) {
    changePasswordLoading = value;
    notifyListeners();
  }

  changePassword(String currentPassword, String newPassword, context) async {
    changePLoading(true);
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user == null) {
      } else {
        final cred = EmailAuthProvider.credential(
            email: user.email!, password: currentPassword);
        print(cred);
        user?.reauthenticateWithCredential(cred).then((value) {
          print(value);
          user.updatePassword(newPassword).then((_) {
            print(newPassword);
            changePasswordForm.reset();
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
      changePLoading(false);
    } catch (e) {
      print(e.toString());
      changePLoading(false);
    }
  }

  resetPassword(email, context) async {
    resetloading(true);
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        resetPasswordForm.reset();
        showSuccessToast(
            message: "link sent successfully,check your email",
            context: context);
        print('done');
      });
    } catch (e) {
      print(e.toString());
      showErrorToast(message: "link sent failed", context: context);
    } finally {
      resetloading(false);
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

  setInitialTotal(email) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(email)
          .set({"subtotal": 0.0, "total": 0.0, "status": false});
    } catch (e) {
      print('get total error');
      print(e.toString());
    }
  }

  // String phone = '';
  // String username = '';
  // String role = 'user';
  // String img = '';

  getUserInfo(email, needed) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get()
          .then((value) async {
        Const.phone = value.get('phone');
        Const.username = value.get('username');
        Const.img = value.get('img');
        Const.role = value.get('role');
        Const.email = value.get('email');
        needed ? await storeToken(email) : '';
        needed ? adminDetail() : '';
        print('my role is ${Const.role}');

      });
    } catch (e) {
      Const.role = 'user';
      print("error $e");
    }
  }

  adminDetail() async {
    try {
      await _firestore.collection('admin').doc('admin').get().then((value) {
        Const.adminMail = value.get('mail');
        Const.adminPhone = value.get('phone');
        Const.devMail = value.get('devmail');
        print(Const.adminPhone);
      });
    } catch (e) {
      print(e);
    }finally{
      notifyListeners();
    }
  }

//update profile
  updateProfileDetails(context, email, username, phone, img) async {
    try {
      await _firestore.collection('users').doc(email).update(
          {"username": username, "phone": phone, "img": img}).then((value) {
        showSuccessToast(
            context: context, message: "Profile updated successfully");
        getUserInfo(email, false);
        // notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  File? imageFile;

  //uplaod image
  uploadimage(email, context, image) async {
    var imageUrl = '';
    try {
      Reference reference =
          await FirebaseStorage.instance.ref('users').child(email);
      UploadTask uploadTask = reference.putFile(File(image));
      TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        // print("success");
        Navigator.pop(context);
        showSuccessToast(
            message: "Nice! Your Image has been Selected Successfully",
            context: context);
      }
      imageUrl = await snapshot.ref.getDownloadURL();
      print(imageUrl);
    } catch (e) {
      imageUrl = '';
      print(e);
    }
    return imageUrl;
  }

  bool imageLoading = false;
  changeImageLoading(value) {
    imageLoading = value;
    notifyListeners();
  }

//pick image
  getImage(context, source) async {
    var uplaodedImage = '';
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        changeImageLoading(true);
        print('img picked');
        uplaodedImage = (pickedFile.path);
        print(uplaodedImage);
        // uplaodedImage=await uploadimage(_auth.currentUser?.email, context, i);
      } else {
        uplaodedImage = '';
        showErrorToast(message: "Failed to pick image", context: context);
      }
    } catch (e) {
      uplaodedImage = '';
      print(e);
    } finally {
      changeImageLoading(false);
    }
    return uplaodedImage;
  }
}

final authProvider = ChangeNotifierProvider((ref) {
  var state = AuthService();
  return state;
});
