// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class Auth extends ChangeNotifier {
//   String? token;
//   bool loaded = false;
//   final _storage = const FlutterSecureStorage();
//
//   Future writeSecureData(String value) async {
//     var writeData = await _storage.write(
//       key: "token",
//       value: value ,
//     );
//     token = value;
//     return writeData;
//   }
//
//   Future readSecureData() async {
//     var readData = await _storage.read(
//       key: 'token',
//     );
//     token = readData;
//     loaded = true;
//     notifyListeners();
//     return readData;
//   }
//
//   Future deleteSecureData() async {
//     var deleteData = await _storage.delete(
//       key: 'token',
//     );
//     return deleteData;
//   }
// }
//
// final auth = ChangeNotifierProvider((r) {
//   var state = Auth();
//   state.readSecureData().then((value) => print('Token red is $value'));
//   return state;
// });
