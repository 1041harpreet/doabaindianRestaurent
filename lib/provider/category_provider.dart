import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryService extends ChangeNotifier {
  List catogries = [
    'Appetizer (Non- Vegetarian)',
    'Appetizer (Vegetarian)',
    'Beverages',
    'Biryani & Rice',
    'Breads – Made in Tandoor',
    'Chutneys & Sides',
    'Dessert',
    ' Entrees – (Chicken or Murgh)',
    'Entrees – Gosht (Goat & Lamb)',
    'Entrees – North Indian Vegetarian',
    'Entrees – Seafood (Fish & Shrimp)',
    'Soup & Salad',
    'Tandoor Clay Oven'
  ];

  int quantity = 0;
  double total = 0;

  addquantity( price) {
    quantity++;
    total += price;
    notifyListeners();

    notifyListeners();
  }
  remquantity( price) {
    if (quantity <= 0) {
      quantity = 0;
      total = 0;
      notifyListeners();
    } else {
      quantity--;
      total -= price;
    }
    notifyListeners();
  }
  initquanity(){
    quantity=0;
    total=0;
    notifyListeners();
  }
}

final categoryProvider = ChangeNotifierProvider((ref) {
  return CategoryService();
});
