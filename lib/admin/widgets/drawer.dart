import 'package:flutter/material.dart';

import '../../config/config.dart';

Widget drawer(context,authprovider){
 return  ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
       UserAccountsDrawerHeader( // <-- SEE HERE
        decoration: BoxDecoration(color:AppConfig.primaryColor),
        accountName: Text(
          authprovider.username,
          style: AppConfig.blacktext
        ),

        accountEmail: Text(
          authprovider.user.email,
          style: AppConfig.blacktext,
          ),
        currentAccountPicture: Image.asset('assets/images/avatar.png'),
      ),
      ListTile(
        leading: const Icon(
          Icons.home,
          color: Colors.black,
        ),
        title:  Text('Gallery',style: AppConfig.blacktext),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading:  const Icon(
          Icons.bookmark_border,
          color: Colors.black,
        ),
        title:  Text('All Orders',style: AppConfig.blacktext),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading:  const Icon(
          Icons.logout,
          color: Colors.black,
        ),
        title:  Text('Log Out',style: AppConfig.blacktext),
        onTap: () async{
         await authprovider.signOut(context);

        },
      ),
    ],
  );
}