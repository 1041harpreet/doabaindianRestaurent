import 'package:flutter/material.dart';

class Const {
  size(context) {
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
  }

  List<String> categoryName = [
    "Beverages",
    "Soup and Salad",
    "Appetizer (Vegetarian)",
    "Appetizer ( Non-Vegetarian)",
    "Entrees- Chicken /Murgh"
  ];
  List<Map<String, List<String>>> fakeData = [
    {
      "Appetizer -Vegetarian": [
        "first item",
        "second item",
        "third item",
        "fourth item",
      ],
      "Appetizer Non-Vegetarian": [
        "first item",
        "second item",
        "third item",
        "fourth item",
      ],
      "Entrees – North Indian Vegetarian": [
        "first item",
        "second item",
        "third item",
        "fourth item",
      ],
      "Entrees – Gosht (Goat & Lamb)": [
        "first item",
        "second item",
        "third item",
        "fourth item",
      ],
      "Entrées – Chicken/Murgh": [
        "first item",
        "second item",
        "third item",
        "fourth item",
      ],
    }
  ];
}
