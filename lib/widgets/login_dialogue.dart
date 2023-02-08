import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurent.app/screens/auth/login_screen.dart';

loginBox(context,name) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => Theme(
      data: ThemeData(backgroundColor: Colors.white),
      child: CupertinoAlertDialog(
        title:  Text('To access $name You need to login first'),
        content: const Text('Click on Yes to login'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
              print('login');
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    ),
  );
}
