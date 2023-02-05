import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent.app/admin/order_detail_page.dart';
import 'package:restaurent.app/admin/provider/order_provider.dart';
import 'package:restaurent.app/admin/widgets/drawer.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/auth_provider.dart';
import 'package:restaurent.app/widgets/toast_service.dart';

import '../provider/nav_bar_provider.dart';
import '../services/notification_service/notification.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        print('not allowed');
        NotificationController().displayNotificationRationale(context);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.watch(orderProvider).changePmore(false);
      await ref.watch(orderProvider).getFirstPendingOrders();
      controller.addListener(_scrollListener);
    });

    super.initState();
  }

  ScrollController controller = ScrollController();

  Future<void> _scrollListener() async {
    if (ref.watch(orderProvider).noPmore) {
      return;
    }
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (ref.watch(orderProvider).isPfetching) {
        print('fetching');
      } else {
        await ref.watch(orderProvider).fetchNextPOrder();
        print('else running');
      }
      print("at the end of list");
    }
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
    final navprovider = ref.watch(NavBarProvider);
    final orderprovider = ref.watch(orderProvider);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: AppConfig.primaryColor,
              title: Text("Pending Orders"),
              actions: [
                IconButton(
                    onPressed: () async {
                      await orderprovider.changePmore(false);
                      await orderprovider.getFirstPendingOrders();
                      showSuccessToast(
                          context: context, message: "Updated Successfully");
                    },
                    icon: const Icon(Icons.refresh))
              ]),
          drawer: Drawer(
            backgroundColor: Colors.white,
            width: wsize * .7,
            child: drawer(context, authprovider, orderprovider,navprovider),
          ),
          backgroundColor: AppConfig.secmainColor,
          body: orderprovider.pendingloading
              ? const Center(child: CircularProgressIndicator())
              : orderprovider.pendingOrderList.isEmpty
                  ? Center(
                      child: Text("No order yet", style: AppConfig.blackTitle),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            shrinkWrap: true,
                            itemCount: orderprovider.pendingOrderList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetail(
                                        index: index,
                                        orderList:
                                            orderprovider.pendingOrderList,
                                        doc: orderprovider
                                                .pendingOrderList[index].date +
                                            orderprovider
                                                .pendingOrderList[index].email,
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
                                                            .pendingOrderList[
                                                                index]
                                                            .email
                                                            .length >
                                                        25
                                                    ? Text(
                                                        '${orderprovider.pendingOrderList[index].email.toString().substring(0, 20)}...',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0))
                                                    : Text(
                                                        orderprovider
                                                            .pendingOrderList[
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
                                                  "\$${orderprovider.pendingOrderList[index].total.toStringAsFixed(2)}",
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
                                                "Date : ${orderprovider.pendingOrderList[index].date}",
                                                style: AppConfig.blackTitle),
                                            Text(
                                              "Phone : ${orderprovider.pendingOrderList[index].phone}",
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
                        orderprovider.isPfetching
                            ? Center(child: CircularProgressIndicator())
                            : Container()
                      ],
                    )),
    );
  }
}
