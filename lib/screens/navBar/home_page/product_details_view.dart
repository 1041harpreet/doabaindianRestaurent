import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent.app/provider/cart_provider.dart';
import 'package:restaurent.app/provider/nav_bar_provider.dart';
import 'package:restaurent.app/screens/navBar/nav_bar.dart';
import 'package:restaurent.app/widgets/toast_service.dart';

import '../../../config/config.dart';
import '../../../provider/category_provider.dart';
import '../../../widgets/category_item.dart';

class ProductDetailsView extends ConsumerStatefulWidget {
  var item;
  String catname;

  ProductDetailsView({Key? key, required this.item, required this.catname}) : super(key: key);

  @override
  ConsumerState<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends ConsumerState<ProductDetailsView> {
  bool isselected = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(categoryProvider).initquanity( widget.item.price);
      ref.watch(categoryProvider).initialfavButton();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hsize = MediaQuery.of(context).size.height;
    final wsize = MediaQuery.of(context).size.width;
    final provider = ref.watch(categoryProvider);
    final cartprovider = ref.watch(cartProvider);
    final navprovider = ref.watch(NavBarProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConfig.secmainColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white, border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(10.0)),
                          width: 40.0,
                          height: 40.0,
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        navprovider.changeindex(2);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NavBar()),
                        );
                      },
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(10.0)),
                        width: 40.0,
                        height: 40.0,
                        child: Badge(
                          badgeContent: Text(cartprovider.badgevalue.toString()),
                          child: const Icon(
                            Icons.shopping_cart,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // height: MediaQuery.of(context).size.height * .5,
                padding: const EdgeInsets.only(bottom: 0),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.item.img,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress, color: AppConfig.primaryColor),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.black),
                  ),
                ),
                // Image.network(, fit: BoxFit.cover)),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, right: 14, left: 14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.title,
                            style: GoogleFonts.poppins(
                              fontSize: wsize * 0.05,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.catname.length > 30
                                  ? Text(widget.catname.substring(0, 30) + '...',
                                      style: GoogleFonts.poppins(
                                        fontSize: wsize * 0.045,
                                        color: Colors.black,
                                      ))
                                  : Text(widget.catname,
                                      style: GoogleFonts.poppins(
                                        fontSize: wsize * 0.045,
                                        color: Colors.black,
                                      )),
                              Text(
                                '\$${widget.item.price}',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        provider.remquantity(widget.item.price);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 0.1,
                                            )),
                                        child: Padding(
                                          padding: EdgeInsets.all(wsize * 0.03),
                                          child: Text("-", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          width: 0.1,
                                        )),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(provider.quantity.toString(), style: TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        provider.addquantity(widget.item.price);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 0.1,
                                            )),
                                        child: Padding(
                                          padding: EdgeInsets.all(wsize * 0.03),
                                          child: Text("+", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Total : ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black,
                                      )),
                                  Text(
                                    '\$${provider.total.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Similar This',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            // width: 150.0,
                            height: hsize * 0.25,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.subcategory.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => ProductDetailsView(
                                                item: provider.subcategory[index],
                                                catname: widget.catname,
                                              )));
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    // width: wsize*0.5,
                                    // height: hsize*0.35,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: buildImg(hsize, wsize, provider.subcategory[index].img),
                                          height: hsize * 0.2,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            provider.subcategory[index].title,
                                            style: GoogleFonts.mulish(fontSize: hsize * 0.02, color: Colors.black),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  provider.changeselect();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppConfig.greyColor),
                  ),
                  child: provider.isselected
                      ? InkWell(
                          hoverColor: Colors.black12,
                          onTap: () async {
                            await provider.changeselect();
                            await provider.removeToFavourite(cartprovider.email, widget.item);
                          },
                          child: const Icon(
                            CupertinoIcons.heart_fill,
                            size: 45,
                            color: Colors.red,
                          ),
                        )
                      : InkWell(
                          hoverColor: Colors.black12,
                          onTap: () async {
                            print('fav');
                            await provider.changeselect();
                            await provider.addToFavourite(cartprovider.email, widget.item, widget.catname);
                          },
                          child: const Icon(
                            CupertinoIcons.heart,
                            size: 45,
                            color: Colors.red,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: provider.quantity == 0
                    ? InkWell(
                        onTap: () {
                          showErrorToast(context: context, message: "please select item");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '+ Add to Cart',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          print('cart clicked');
                          cartprovider.addToCart(widget.item, provider.quantity, widget.catname, context);
                          print('cart done');
                        },
                        child: cartprovider.cartloading == true
                            ? Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppConfig.primaryColor,
                                    strokeWidth: 3.0,
                                  ),
                                ))
                            : Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  '+ Add to Cart',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
