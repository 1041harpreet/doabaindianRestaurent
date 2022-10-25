import 'package:flutter/material.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:scrollable_list_tabview/model/scrollable_list_tab.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppConfig.secmainColor,
      body: Column(
        children: [
          Container(height: 100.0, color: Colors.black54),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50.0,
              child: TextFormField(
                style: TextStyle(color: AppConfig.primaryColor),
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: AppConfig.primaryColor),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: AppConfig.primaryColor)),
                  label: Text("Search for Lunch",
                      style: TextStyle(color: AppConfig.primaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: AppConfig.primaryColor)),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: AppConfig.primaryColor),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
