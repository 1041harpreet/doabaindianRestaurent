import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:restaurent_app/admin/order_detail_page.dart';
import 'package:restaurent_app/admin/provider/order_provider.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/auth_provider.dart';
import 'package:restaurent_app/services/connection_service.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(orderProvider).getdetail();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size.width;
    final hsize = MediaQuery.of(context).size.height;
    final authprovider = ref.watch(authProvider);
    final orderprovider = ref.watch(orderProvider);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: AppConfig.primaryColor,
              title: header(wsize),
              actions: [
                IconButton(
                    onPressed: () {
                      authprovider.signOut(context);
                    },
                    icon: const Icon(Icons.logout))
              ]),
          drawer: Drawer(
            width: wsize * .7,
          ),
          backgroundColor: AppConfig.secmainColor,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                SizedBox(
                  height: hsize * 0.35,
                  child: GridView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) => ItemTile(index),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1.5),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Your orders",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.0)),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: IconButton(
                          onPressed: () async {
                            await orderprovider.getdetail();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ),
                        ))
                  ],
                ),
                Container(
                  height: 500.0,
                  color: Colors.grey,
                  child: orderprovider.orderloading
                      ? const Center(child: CircularProgressIndicator())
                      : orderprovider.orderList.isEmpty
                          ? Center(
                              child: Text("No order yet",
                                  style: AppConfig.blackTitle),
                            )
                          : ListView.builder(
                              itemCount: orderprovider.orderList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OrderDetail(
                                                  index: index,
                                                  orderList:
                                                      orderprovider.orderList,
                                                  doc: orderprovider
                                                          .orderList[index]
                                                          .date +
                                                      orderprovider
                                                          .orderList[index]
                                                          .email,
                                                )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    // height: 100.0,
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text("Email :",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17.0)),
                                                  orderprovider.orderList[index].email.length>25 ? Text(
                                                      '${orderprovider
                                                          .orderList[index]
                                                          .email.toString().substring(0,20)}...',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0)) :
                                                  Text(
                                                      orderprovider
                                                          .orderList[index]
                                                          .email,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Total Bill : ",
                                                    style: TextStyle(
                                                        fontSize: 17.0,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "\$${orderprovider.orderList[index].total.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        fontSize: 17.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Date : ${orderprovider.orderList[index].date}",
                                                  style: AppConfig.blackTitle),
                                              Text(
                                                "Phone : ${orderprovider.orderList[index].phone}",
                                                style: AppConfig.blackTitle,
                                              )
                                            ]),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          )),
    );
  }
}

Widget header(wsize) {
  return AutoSizeText(
    "Admin Panel",
    style: TextStyle(color: Colors.white, fontSize: wsize * 0.06),
  );
}

class ItemTile extends StatelessWidget {
  final int itemNo;

  ItemTile(
    this.itemNo,
  );

  List image = ["all.png", "pending.png", "complete.png", "user.png"];

  List name = ["All Order", "Pending Order", "Completed Order", "All Users"];

  @override
  Widget build(BuildContext context) {
    final Color color = Colors.primaries[itemNo % Colors.primaries.length];
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: color,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 30.0,
              child: Image.asset('assets/images/${image[itemNo]}'),
            ),
            // Iconify(),
            Text(
              name[itemNo],
              style: const TextStyle(fontSize: 17.0),
            )
          ]),
        ));
  }
}
