import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:restaurent_app/admin/order_detail_page.dart';
import 'package:restaurent_app/admin/provider/order_provider.dart';
import 'package:restaurent_app/admin/widgets/drawer.dart';
import 'package:restaurent_app/config/config.dart';
import 'package:restaurent_app/provider/auth_provider.dart';
import 'package:restaurent_app/services/connection_service.dart';

import '../widgets/toast_service.dart';

class CompletedOrderScreen extends ConsumerStatefulWidget {
  const CompletedOrderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CompletedOrderScreen> createState() =>
      _CompletedOrderScreenState();
}

class _CompletedOrderScreenState extends ConsumerState<CompletedOrderScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(orderProvider).getFirstCompOrders();
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
              title: Text("Completed Orders"),
              actions: [
                PopupMenuButton(
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onSelected: (value) {
                    // your logic
                  },
                  itemBuilder: (BuildContext bc) {
                    return [
                      PopupMenuItem(
                        onTap: () async {
                          print('working');
                          await orderprovider.getAllCompOrders();
                          showSuccessToast(
                              context: context,
                              message: "Updated Successfully");
                        },
                        value: '/all',
                        child:
                            Text("See All Orders", style: AppConfig.blackTitle),
                      ),
                    ];
                  },
                ),
                IconButton(
                    onPressed: () async {
                      await orderprovider.getFirstCompOrders();
                      showSuccessToast(
                          context: context, message: "Updated Successfully");
                    },
                    icon: const Icon(Icons.refresh))
              ]),
          drawer: Drawer(
            backgroundColor: Colors.white,
            width: wsize * .7,
            child: drawer(context, authprovider, orderprovider),
          ),
          backgroundColor: AppConfig.secmainColor,
          body: orderprovider.comOrderLoading
              ? const Center(child: CircularProgressIndicator())
              : orderprovider.compOrderList.isEmpty
                  ? Center(
                      child: Text("No order yet", style: AppConfig.blackTitle),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: orderprovider.compOrderList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetail(
                                  index: index,
                                  orderList: orderprovider.compOrderList,
                                  doc: orderprovider.compOrderList[index].date +
                                      orderprovider.compOrderList[index].email,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0)),
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
                                          orderprovider.compOrderList[index]
                                                      .email.length >
                                                  25
                                              ? Text(
                                                  '${orderprovider.compOrderList[index].email.toString().substring(0, 20)}...',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13.0))
                                              : Text(
                                                  orderprovider
                                                      .compOrderList[index]
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
                                            "\$${orderprovider.compOrderList[index].total.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
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
                                          "Date : ${orderprovider.compOrderList[index].date}",
                                          style: AppConfig.blackTitle),
                                      Text(
                                        "Phone : ${orderprovider.compOrderList[index].phone}",
                                        style: AppConfig.blackTitle,
                                      )
                                    ]),
                              ),
                            ]),
                          ),
                        );
                      },
                    )),
    );
  }
}
