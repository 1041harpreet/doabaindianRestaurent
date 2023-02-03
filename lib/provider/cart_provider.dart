import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent.app/model/order_item_model.dart';
import 'package:restaurent.app/provider/auth_provider.dart';
import 'package:restaurent.app/widgets/toast_service.dart';

import '../config/const.dart';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
class CartService extends ChangeNotifier {
  // String email;
  CartService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //set loading in cart screen
  bool cartloading = false;
  bool checkoutloading = false;
  bool loading = false;

  changecheckload(value) {
    checkoutloading = value;
    notifyListeners();
  }

  changeloading(value) {
    cartloading = value;
    notifyListeners();
  }

  int badgevalue = 0;

  getBadge() async {
    try{
      await _firestore
          .collection('cart')
          .doc(Const.email)
          .collection(Const.email)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          changeBadge(0);
          print('empty');
        } else {
          changeBadge(value.docs.length);
          print('value exist' + value.docs.length.toString());
        }
      });
    }catch(e){
      print(e);
    }finally{
      notifyListeners();
    }

  }

  changeBadge( value) {
    badgevalue = value;
    notifyListeners();
  }

  double subtotal = 0.0;
  double total = 0.0;
  double tax = 0.0;
  int availableCount = 0;
  double itemTotal = 0.0;

// add an item to cart
  addToCart(item, subitem, count, category, context) async {
    changeloading(true);
    try {
      await checkFromCart(item, subitem);
      if (exist == true) {
        await _firestore
            .collection('cart')
            .doc(Const.email)
            .collection(Const.email)
            .doc(item.title + subitem)
            .update({
          'total': itemTotal + item.price * count,
          "count": count + availableCount,
        });
      } else {
        var total = count * item.price;
        await _firestore
            .collection('cart')
            .doc(Const.email)
            .collection(Const.email)
            .doc(item.title + subitem)
            .set({
          "count": count,
          "img": item.img,
          "price": item.price,
          "title": item.title + subitem,
          "category": category,
          "total": total
        });
      }
      showSuccessToast(message: "Item added to cart", context: context);
      await addToTotal(item, count);
    } catch (e) {
      showErrorToast(message: "Failed", context: context);
      print(e);
    } finally {
      await getBadge();
      changeloading(false);
    }
  }

  // add bill to total
  addToTotal(item, count) async {
    var itemtotal = item.price * count;
    subtotal = subtotal + itemtotal;
    await _firestore
        .collection('cart')
        .doc(Const.email)
        .update({"subtotal": subtotal, 'total': subtotal + tax});
    await getTotal();
  }

  bool exist = false;
  //check specific item available in cart or not
  checkFromCart(item, subitem) async {
    await _firestore
        .collection('cart')
        .doc(Const.email)
        .collection(Const.email)
        .doc(item.title + subitem)
        .get()
        .then((value) async {
      print("value exist ${value.exists}");
      exist = value.exists;
      if (exist == true) {
        availableCount = value.get('count');
        itemTotal = value.get('total');
      }
      notifyListeners();
    });
  }

  //remove from cart :
  removeFromCart(item, context) async {
    changecheckload(true);
    try {
      await removeToTotal(item, item.count);
      await _firestore
          .collection('cart')
          .doc(Const.email)
          .collection(Const.email)
          .doc(item.title)
          .delete();
      showSuccessToast(message: "item removed from cart", context: context);
      await getTotal();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      await getBadge();
      getorderItem();
      changecheckload(false);
      // notifyListeners();
    }
  }

  //remove price of item from total
  removeToTotal(item, count) async {
    try {
      var itemtotal = item.price * count;
      var stotal = subtotal.toStringAsFixed(2);
      //check bill can be 5.900002
      subtotal = double.tryParse(stotal)! - itemtotal;
      await _firestore
          .collection('cart')
          .doc(Const.email)
          .update({"subtotal": subtotal, 'total': subtotal + tax});
      await getTotal();
    } catch (e) {
      print(e.toString());
    }
  }

  //get total bill :
  getTotal() async {
    try {
      await _firestore.collection('cart').doc(Const.email).get().then((value) {
        if (value.exists == true) {
          var x = value.get('subtotal');
          subtotal = x.toDouble();
          var y = value.get('total');
          total = y.toDouble();
        } else {
          subtotal = 0.0;
          total = 0.0;
        }
      });
    } catch (e) {
      subtotal = 0.0;
      total = 0.0;
      print(e.toString());
    }finally{
      notifyListeners();
    }
  }

  //get list of order items
  List orderItem = [];
  getorderItem() async {
    changeloading(true);
    try {
      var ref = await _firestore
          .collection('cart')
          .doc(Const.email)
          .collection(Const.email)
          .get();
      orderItem = ref.docs.map((e) => OrderItem.fromJson(e.data())).toList();
    } catch (e) {
      orderItem = [];
      print(e);
    } finally {
      changeloading(false);
      // notifyListeners();
    }
  }
}
final cartProvider = ChangeNotifierProvider((ref) {
  var state = CartService();
  return state;
});
