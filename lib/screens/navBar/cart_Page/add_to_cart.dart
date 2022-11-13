import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/screens/navBar/home_page/item.dart';

import '../home_page/categories/cat_item.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConfig.secmainColor,
        body: Column(children: [
          Padding(padding: const EdgeInsets.all(8.0), child: header(wsize)),
          StreamBuilder<dynamic>(
            stream: FirebaseFirestore.instance.collection('cart').doc('6283578905').collection('6283578905').snapshots(),
            builder: (context,AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppConfig.primaryColor,
                          )),
                      const SizedBox(height: 16),
                      Text("Loading...",
                          style: TextStyle(
                              color: AppConfig.primaryColor)),
                    ],
                  ),
                );
              }
              if(snapshot.hasError){
                return Text('error',style: AppConfig.blackTitle,);
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot item = snapshot.data.docs[index];
                return CartItem(wsize, hsize,context,item);
              },
              ),
              );

            },
          ),
          Container(height: 100.0,
            color: Colors.white,
            width: wsize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal",style:TextStyle(color: Colors.black,fontSize: hsize*0.022,fontWeight: FontWeight.bold),),
                      Text("\$99.99",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black)),

                    ],),
                ),
                Container(color: AppConfig.primaryColor,
                  height: 50.0,
                  width: wsize,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(child: Text("Go for CheckOut",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0))),

                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

Widget header(wsize) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Iconify(Bx.shopping_bag, color: Colors.black, size: wsize * 0.1),
    Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: AutoSizeText(
        "Your Cart",
        style: TextStyle(color: Colors.black, fontSize: wsize * 0.1),
      ),
    )
  ]);
}

Widget CartItem(wsize, hsize,context,item) {
  return Padding(
      padding: EdgeInsets.only(
          left: wsize * 0.02, right: wsize * 0.02, top: wsize * 0.02),
      child: Container(
        // width: wsize * .3,
        height: hsize * .15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(wsize * 0.025),
          boxShadow: [
            BoxShadow(
                offset: const Offset(2.0, 2.0),
                color: Colors.black26,
                blurRadius: wsize * .025)
          ],
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                    width: wsize * 0.25,
                    child: Center(
                      child: buildImg(hsize, wsize,
                          item['img']),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: wsize * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: wsize * 0.03, top: wsize * 0.03),
                      child: AutoSizeText(item['title'],
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: wsize * 0.045,
                              color: Colors.black87)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wsize * 0.04,top: wsize*0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const AutoSizeText("Price : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold)),
                          AutoSizeText("\$${item['price']}",
                              style: TextStyle(
                                  color: AppConfig.primaryColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)),

                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: wsize * 0.00,
                        top: wsize*0.01
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: wsize * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 0.1,
                                        )),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text("-",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        width: 0.1,
                                      )),
                                  child:  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
                                    child: Text("${item['count']}",
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 0.1,
                                        )),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text("+",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 0.1,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(Icons.delete,color: AppConfig.primaryColor,),
                              )
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     const Text("SubTotal : ",
                          //         style: TextStyle(
                          //             color: Colors.black,
                          //             fontSize: 18.0,
                          //             fontWeight: FontWeight.bold)),
                          //     Text("\$99.9",
                          //         style: TextStyle(
                          //             color: AppConfig.primaryColor,
                          //             fontSize: 18.0,
                          //             fontWeight: FontWeight.bold)),
                          //   ],
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left:8.0),
                          //   child: Container(
                          //     height: wsize*0.07,
                          //     width: wsize*0.15,
                          //     decoration: BoxDecoration(
                          //         color: Colors.grey[300],
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(wsize*0.02),
                          //         ),
                          //         // border: Border.all(color: Colors.black87)
                          //     ),
                          //     child: Center(child: Text("Remove",style: TextStyle(color: AppConfig.primaryColor,fontWeight: FontWeight.w500))),
                          //   ),
                          // )
                          // Padding(
                          //   padding: const EdgeInsets.only(left:8.0),
                          //   child: TextButton(onPressed: (){}, child: const Text("Add Me",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ));
}
