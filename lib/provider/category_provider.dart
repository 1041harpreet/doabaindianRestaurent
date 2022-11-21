import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/model/category_model.dart';

import '../model/subcategory_model.dart';

class CategoryService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
  bool loading=false;
  bool subloading=false;

  changeloading(value){
    loading=value;
    notifyListeners();
  }
  changesubloading(value){
    subloading=value;
    notifyListeners();
  }

  addquantity(price) {
    quantity++;
    total += price;
    notifyListeners();

    notifyListeners();
  }

  remquantity(price) {
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

  initquanity() {
    quantity = 0;
    total = 0;
    notifyListeners();
  }
  //this list is used to store categor item
List category=[];
  //this list is used to store sub category item
  List subcategory=[];
  //used to get categor items
  getCategory() async {
    changeloading(true);
    try{
      var ref = await _firestore.collection('category').get();
    category=ref.docs.map((e) => CategoryItem.fromJson(e.data())).toList();
    notifyListeners();
    }
    catch(e){
      print(e.toString());
    }finally{
      changeloading(false);
      notifyListeners();
    }
  }
//used to get subcategory items 
  getsubcategory() async {
    changesubloading(true);
    try{
      var ref = await _firestore.collection('category').doc('item').collection('item').get();
      subcategory=ref.docs.map((e) => SubCategoryItem.fromJson(e.data())).toList();
      notifyListeners();
    }
    catch(e){
      print(e.toString());
    }finally{
      changesubloading(false);
      notifyListeners();
    }
  }



}

  final categoryProvider = ChangeNotifierProvider((ref) {
    return CategoryService();
  });
