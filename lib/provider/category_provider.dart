import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/model/category_model.dart';
import '../model/favourite_item_model.dart';
import '../model/slider_model.dart';
import '../model/subcategory_model.dart';

class CategoryService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isselected = false;

  changeselect() {
    isselected = !isselected;
    print(isselected);
    notifyListeners();
  }

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
  bool loading = false;
  bool subloading = false;
  bool favloading = false;

  changeloading(value) {
    loading = value;
    notifyListeners();
  }

  changefavloading(value) {
    favloading = value;
    notifyListeners();
  }

  changesubloading(value) {
    subloading = value;
    notifyListeners();
  }

  addquantity(price) {
    quantity++;
    total += price;
    notifyListeners();
  }

  remquantity(price) {
    if (quantity <= 0) {
      quantity = 0;
      total = 0;
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
  List category = [];
  // List seccategory = [];


  //this list is used to store sub category item
  List subcategory = [];

  //used to get category items
  getCategory() async {
    // changeloading(true);
    try {
      var ref = await _firestore.collection('category').get();
      category = ref.docs.map((e) => CategoryItem.fromJson(e.data())).toList();
    } catch (e) {
      print(e.toString());
    } finally {
      // changeloading(false);
      notifyListeners();
    }
  }

//used to get subcategory items
  getsubcategory(item) async {
    print(item);
    changesubloading(true);
    var ref = await _firestore
        .collection('category')
        .doc(item.toString())
        .collection(item.toString())
        .get();
    print(ref);
    subcategory = ref.docs.map((e) => SubCategoryItem.fromJson(e.data())).toList();
    print(subcategory);
    try {
      // var item=category[index].title;

    } catch (e) {
      print('get sub is running');
      print(e);
    } finally {
      changesubloading(false);
      notifyListeners();
    }
  }

  //get carsoul item
  bool carload = false;

  changecarload(value,item) {
     item= value;
    notifyListeners();
  }
  List madefulist=[];
  bool mfuload=false;

getmadeforu()async{
  changecarload(true, mfuload);
  try{
      var ref=await _firestore.collection('madeforu').get();
      madefulist = ref.docs.map((e) => MadeForUItem.fromJson(e.data())).toList();

  }catch(e){
     print(e);
    }finally{
      changecarload(false, mfuload);
      notifyListeners();
    }
}
  List carsoulList = [];

  getcarsoulItem() async {
    changecarload(true,carload);
    try {
      // var item=category[index].title;
      var ref = await _firestore.collection('carsoul_slider').get();
      carsoulList = ref.docs.map((e) => SliderItem.fromJson(e.data())).toList();
      print(carsoulList);
    } catch (e) {
      print('get car is running');
      print(e.toString());
    } finally {
      changecarload(false,carload);
      notifyListeners();
    }
  }

//favourite item
  List favList = [];

  initialfavButton() {
    isselected = false;
    notifyListeners();
  }

  addToFavourite(email, item, category) async {
    // changefavloading(true);
    try {
      await _firestore
          .collection('favourite')
          .doc(email)
          .collection(email)
          .doc(item.title)
          .set({
        "title": item.title,
        "price": item.price,
        "category": category,
        "img": item.img
      });
    } catch (e) {
      print('add fav error');
      print(e.toString());
    } finally {
      // changefavloading(false);
      notifyListeners();
    }
  }

  getFavouriteItem(email) async {
    changefavloading(true);
    try {
      // var item=category[index].title;
      var ref = await _firestore
          .collection('favourite')
          .doc(email)
          .collection(email)
          .get();
      favList = ref.docs.map((e) => FavItem.fromJson(e.data())).toList();
    } catch (e) {
      print('add fav is running');
      print(e.toString());
    } finally {
      changefavloading(false);
      notifyListeners();
    }
  }

  removeToFavourite(email, item) async {
    // changefavloading(true);
    try {
      await _firestore
          .collection('favourite')
          .doc(email)
          .collection(email)
          .doc(item.title)
          .delete();
    } catch (e) {
      print('remove fav error');
      print(e.toString());
    } finally {
      // changefavloading(false);
      notifyListeners();
    }
  }
}

final categoryProvider = ChangeNotifierProvider((ref) {
  return CategoryService();
});
