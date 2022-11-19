import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AuthService extends ChangeNotifier{
  FormGroup loginForm=FormGroup({
    "email": FormControl(
      // value: '1234567890',
        validators: [
          Validators.required,
         Validators.email
        ]),
    'password': FormControl(
      // value: '123456',
        validators: [
          Validators.required,
        ]),
  });
  FormGroup SignUpForm=FormGroup({
    "email": FormControl(
      // value: '1234567890',
        validators: [
          Validators.required,
         Validators.email
        ]),
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

}
final authProvider=ChangeNotifierProvider((ref) {
  var state=AuthService();
  return state;
});