import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_app/services/toast_service.dart';

class CartService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //set total ,subtotal, status initial
  //set loading in cart screen
  bool cartloading = false;
  changeloading(value) {
    cartloading = value;
    notifyListeners();
  }

  int badgevalue=0;
  changeBadge(int value){
    badgevalue=value;
    notifyListeners();
  }
  double subtotal = 0.0;
  double total = 0.0;
  double tax = 5.0;

  int availableCount = 0;
  double itemTotal=0.0;
// add an item to cart
  addToCart(item, count, category, context) async {
    changeloading(true);
    try {
      await checkFromCart(item);
      if (exist == true) {
        await getcountValue(item);
        await _firestore
            .collection('cart')
            .doc('6283578905')
            .collection('6283578905')
            .doc(item['title'])
            .update({
          'total':itemTotal+item['price']*count,
          "count": count + availableCount,
        });
        print('update done');
      }
      else {
        var total=count*item['price'];
        print('item total is $total');
        await _firestore
            .collection('cart')
            .doc('6283578905')
            .collection('6283578905')
            .doc(item['title'])
            .set({
          "count": count,
          "img": item['img'],
          "price": item['price'],
          "title": item['title'],
          "category": category,
          "total": total
        });
      }
      await addToTotal(item,count);
      print('total calculated$subtotal');
      showSuccessToast(message: "Item added to cart", context: context);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    } finally {
      changeloading(false);
      notifyListeners();
    }
  }

  bool exist = false;
  //check specific item available in cart or not
  checkFromCart(item) async {
    await _firestore
        .collection('cart')
        .doc('6283578905')
        .collection('6283578905')
        .doc(item['title'])
        .get()
        .then((value) async {
      print("value exist " + value.exists.toString());
      exist = value.exists;
      if (exist == true) {
        await getcountValue(item);
        notifyListeners();
      }
      notifyListeners();
    });
  }
  //check how much item available in cart
  getcountValue(item) async {
    await _firestore
        .collection('cart')
        .doc('6283578905')
        .collection('6283578905')
        .doc(item['title'])
        .get()
        .then((value) {
      print("count value in firebase is ${value.get('count')}");
      availableCount = value.get('count');
      itemTotal=value.get('total');
      print("count value is $availableCount");
      notifyListeners();
    });
  }
  //remove from cart :
  removeFromCart(item, context) async {
    try {
      await removeToTotal(item,item['count']);
      await _firestore
          .collection('cart')
          .doc('6283578905')
          .collection('6283578905')
          .doc(item['title'])
          .delete();
      getTotal();
      notifyListeners();
      print('deleted');
      // showSuccessToast(message: "item removed from cart",context: context);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  //update from cart :
  updateCart() {}
  // add bill to total
  addToTotal(item,count) async {
    var itemtotal = item['price'] *count;
    subtotal = subtotal + itemtotal;
    await _firestore
        .collection('cart')
        .doc('6283578905')
        .update({"subtotal": subtotal,
      'total':subtotal+tax
    });
    await getTotal();
    notifyListeners();
  }
  //remove price of item from total
  removeToTotal(item,count) async {
    try{
      var itemtotal = item['price'] *count;
      print('item price $itemTotal');
      var stotal=subtotal.toStringAsFixed(2);
      //check bill can be 5.900002

      subtotal = double.tryParse(stotal)! - itemtotal;
      print('before subtotal$subtotal');
      await _firestore
          .collection('cart')
          .doc('6283578905')
          .update({"subtotal": subtotal,
        'total':subtotal+tax
      });
      await getTotal();
      notifyListeners();
    }catch(e){
      print(e.toString());
    }


  }

  //get total bill :
  getTotal() async {
    await _firestore.collection('cart').doc('6283578905').get().then((value) {
      var x = value.get('subtotal');
      subtotal=x.toDouble();
      var y=value.get('total');
      total=y.toDouble();
      notifyListeners();
    });
    print('subtotal is $subtotal');
    notifyListeners();
  }
}

final cartProvider = ChangeNotifierProvider((ref) {
  var state = CartService();
  return state;
});
