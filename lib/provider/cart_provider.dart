import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:restaurent_app/model/order_item_model.dart';
import 'package:restaurent_app/provider/auth_provider.dart';
import 'package:restaurent_app/widgets/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
class CartService extends ChangeNotifier {
  String email;
  CartService(this.email);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FormGroup checkoutForm = FormGroup({
    "fullname": FormControl(
        validators: [Validators.required]),
    'address': FormControl(
        validators: [
          Validators.required,
        ]),
    'company': FormControl(),
    'additional': FormControl(),
    'email': FormControl(
        validators: [
          Validators.required,
          Validators.email
        ]),
    'phone': FormControl<int>(
        validators: [
          Validators.required,
        ]),
    'town': FormControl(),
    'state': FormControl(
        validators: [
        ]),
    'zipcode': FormControl(
        validators: [
          Validators.required,
        ]),
  });

  //set total ,subtotal, status initial
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

  int badgevalue = 2;

  getBadge() async {
    await _firestore
        .collection('cart')
        .doc(email)
        .collection(email)
        .get()
        .then((value) {
      print('value is');
      if (value.docs.isEmpty) {
        changeBadge(0);
        print('empty');
      } else {
        changeBadge(value.docs.length);
        print(value.docs.length);
        print('value exist');
      }
      notifyListeners();
    });
  }

  changeBadge(int value) {
    badgevalue = value;
    notifyListeners();
  }

  double subtotal = 0.0;
  double total = 0.0;
  double tax = 5.0;

  int availableCount = 0;
  double itemTotal = 0.0;

// add an item to cart
  addToCart(item, count, category, context) async {
    changeloading(true);
    try {
      await checkFromCart(item);
      if (exist == true) {
        await getcountValue(item);
        await _firestore
            .collection('cart')
            .doc(email)
            .collection(email)
            .doc(item['title'])
            .update({
          'total': itemTotal + item['price'] * count,
          "count": count + availableCount,
        });
        print('update done');
      } else {
        var total = count * item['price'];
        print('item total is $total');
        await _firestore
            .collection('cart')
            .doc(email)
            .collection(email)
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
      await addToTotal(item, count);
      print('total calculated$subtotal');
      showSuccessToast(message: "Item added to cart", context: context);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    } finally {
      await getBadge();
      changeloading(false);
      notifyListeners();
    }
  }

  bool exist = false;

  //check specific item available in cart or not
  checkFromCart(item) async {
    await _firestore
        .collection('cart')
        .doc(email)
        .collection(email)
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
        .doc(email)
        .collection(email)
        .doc(item['title'])
        .get()
        .then((value) {
      print("count value in firebase is ${value.get('count')}");
      availableCount = value.get('count');
      itemTotal = value.get('total');
      print("count value is $availableCount");
      notifyListeners();
    });
  }

  //remove from cart :
  removeFromCart(item, context) async {
    changecheckload(true);
    try {
      await removeToTotal(item, item['count']);
      await _firestore
          .collection('cart')
          .doc(email)
          .collection(email)
          .doc(item['title'])
          .delete();
      showSuccessToast(message: "item removed from cart", context: context);
      await getTotal();
      notifyListeners();
      print('deleted');
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      await getBadge();
      changecheckload(false);
      notifyListeners();
    }
  }

  //update from cart :
  updateCart() {}

  // add bill to total
  addToTotal(item, count) async {
    var itemtotal = item['price'] * count;
    subtotal = subtotal + itemtotal;
    await _firestore
        .collection('cart')
        .doc(email)
        .update({"subtotal": subtotal, 'total': subtotal + tax});
    await getTotal();
    notifyListeners();
  }

  //remove price of item from total
  removeToTotal(item, count) async {
    try {
      var itemtotal = item['price'] * count;
      print('item price $itemTotal');
      var stotal = subtotal.toStringAsFixed(2);
      //check bill can be 5.900002
      subtotal = double.tryParse(stotal)! - itemtotal;
      print('before subtotal$subtotal');
      await _firestore
          .collection('cart')
          .doc(email)
          .update({"subtotal": subtotal, 'total': subtotal + tax});
      await getTotal();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  //get total bill :

  getTotal() async {
    try {
      await _firestore.collection('cart').doc(email).get().then((value) {
        if(value.exists==true){
          var x = value.get('subtotal');
          subtotal = x.toDouble();
          var y = value.get('total');
          total = y.toDouble();
          notifyListeners();
        }else{
          subtotal=0.0;
          total=0.0;
          notifyListeners();
        }

      });
      print('subtotal is $subtotal');
      notifyListeners();
    } catch (e) {
      print('get total error');
      print(e.toString());
    }
  }

  userMail(email,user) async {
    print('sending');
    String username = '1041harpreet@gmail.com';
    String password = 'ualpmmclbwwazchx';
    String domainSmtp = 'mail.domain.com'; //also use for gmail smtp
    final smtpServer = gmail(username, password);
    // final smtpSer = SmtpServer(domainSmtp,
    //     username: username, password: password, port: 587);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(email)
      // ..ccRecipients.addAll([email])
      // ..bccRecipients.add(const Address('bccAddress@example.com'))
      ..subject = 'Order placed $user'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>$user</h1>\n"
          "<p>Your order payment of ${total.toStringAsFixed(2)} is successfully done</p>\n"
         ;
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.${e.message}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  checkout() async {
    // sendMail();
  }
  List orderItem=[];
  getorderItem() async {
    changeloading(true);
    try{
      var ref = await _firestore.collection('cart').doc(email).collection(email).get();
      orderItem=ref.docs.map((e) => OrderItem.fromJson(e.data())).toList();
      notifyListeners();
    }
    catch(e){
      print(e.toString());
    }finally{
      changeloading(false);
      notifyListeners();
    }
  }
}

final cartProvider = ChangeNotifierProvider((ref) {
  final authprovider=ref.watch(authProvider);
  var state = CartService(authprovider.user.email);
  print(authprovider.user.email);
  print(authprovider.phone);


  state.getBadge();
  return state;
});
