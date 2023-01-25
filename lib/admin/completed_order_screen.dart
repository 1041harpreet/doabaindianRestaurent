import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent.app/admin/order_detail_page.dart';
import 'package:restaurent.app/admin/provider/order_provider.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/auth_provider.dart';

import '../widgets/toast_service.dart';

class CompletedOrderScreen extends ConsumerStatefulWidget {
  const CompletedOrderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CompletedOrderScreen> createState() =>
      _CompletedOrderScreenState();
}

class _CompletedOrderScreenState extends ConsumerState<CompletedOrderScreen> {
  ScrollController controller = ScrollController();

  Future<void> _scrollListener() async {
    if (ref.watch(orderProvider).nomore) {
      return;
    }
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (ref.watch(orderProvider).isfetching) {
        print('fetching');
      } else {
        await ref.watch(orderProvider).fetchNextComOrder();
        print('else running');
      }
      print("at the end of list");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.watch(orderProvider).changemore(false);
      await ref.watch(orderProvider).getFirstCompOrders();
      controller.addListener(_scrollListener);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
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
                IconButton(
                    onPressed: () async {
                      await orderprovider.changemore(false);
                      await orderprovider.getFirstCompOrders();
                      showSuccessToast(
                          context: context, message: "Updated Successfully");
                    },
                    icon: const Icon(Icons.refresh))
              ]),
          backgroundColor: AppConfig.secmainColor,
          body: orderprovider.firstComLoading
              ? const Center(child: CircularProgressIndicator())
              : orderprovider.compOrderList.isEmpty
                  ? Center(
                      child: Text("No order yet", style: AppConfig.blackTitle),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
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
                                        doc: orderprovider
                                                .compOrderList[index].date +
                                            orderprovider
                                                .compOrderList[index].email,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffFAECD6),
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
                                                Text("${index + 1}. Email :",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            wsize * 0.04)),
                                                orderprovider
                                                            .compOrderList[
                                                                index]
                                                            .email
                                                            .length >
                                                        25
                                                    ? Text(
                                                        '${orderprovider.compOrderList[index].email.toString().substring(0, 20)}...',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0))
                                                    : Text(
                                                        orderprovider
                                                            .compOrderList[
                                                                index]
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
                          ),
                        ),
                        orderprovider.isfetching
                            ? Center(child: CircularProgressIndicator())
                            : Container()
                      ],
                    )),
    );
  }
}
