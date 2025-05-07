import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

loginBox(context, name, navprovider, authprovider) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => Theme(
      data: ThemeData(backgroundColor: Colors.white),
      child: CupertinoAlertDialog(
        title: Text('To access $name You need to login first'),
        content: const Text('Click on Yes to login'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              navprovider.changeindex(0);
              authprovider.signOut(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    ),
  );
}
