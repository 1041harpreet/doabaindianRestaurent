import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AuthService extends ChangeNotifier{
  FormGroup loginForm=FormGroup({
    "phone": FormControl(
      // value: '1234567890',
        validators: [
          Validators.required,
          Validators.number,
          Validators.minLength(10),
          Validators.maxLength(10)
        ]),
    'password': FormControl(
      // value: '123456',
        validators: [
          Validators.required,
        ]),
  });
  FormGroup SignUpForm=FormGroup({
    "phone": FormControl(
      // value: '1234567890',
        validators: [
          Validators.required,
          Validators.number,
          Validators.minLength(10),
          Validators.maxLength(10)
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