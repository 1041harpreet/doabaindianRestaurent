import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent.app/admin/provider/order_provider.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/screens/auth/sign_up_screen.dart';

class OrderDetail extends ConsumerStatefulWidget {
  var orderList;
  int index;
  String doc;

  OrderDetail(
      {Key? key,
      required this.orderList,
      required this.index,
      required this.doc})
      : super(key: key);

  @override
  ConsumerState<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends ConsumerState<OrderDetail> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(orderProvider).getorderdetails(widget.doc);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderprovider = ref.watch(orderProvider);
    return Scaffold(
      backgroundColor: AppConfig.secmainColor,
      appBar: AppBar(
        backgroundColor: AppConfig.primaryColor,
        title: const Text("Order Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              row("ORDER ID : ", widget.orderList[widget.index].orderID),
              row("EMAIL ID : ", widget.orderList[widget.index].email),
              row("PHONE NO : ", widget.orderList[widget.index].phone),
              row("DATE : ", widget.orderList[widget.index].date),
              const Text("Order Detail : ",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              orderprovider.detailLoad
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: orderprovider.orderDetailList.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                orderprovider.orderDetailList[index].title,
                                style: AppConfig.blackTitle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'X ${orderprovider.orderDetailList[index].count}',
                                style: AppConfig.blackTitle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                orderprovider.orderDetailList[index].total
                                    .toString(),
                                style: AppConfig.blackTitle,
                              ),
                            )
                          ],
                        );
                      },
                    ),
              row("Tax : ", '\$${widget.orderList[widget.index].tax}'),
              row("Total : ", '\$${widget.orderList[widget.index].total}'),
              row("Status : ", '${widget.orderList[widget.index].status}'),
              row("Note : ", '${widget.orderList[widget.index].note}'),
              const Divider(),
              if (widget.orderList[widget.index].status == false)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: orderprovider.markloading == true
                      ? loadingButton(MediaQuery.of(context).size)
                      : Button(MediaQuery.of(context).size, "Mark as Complete",
                          Colors.black, AppConfig.primaryColor, () async {
                          await orderprovider.markAsComplete(
                              widget.orderList[widget.index].date +
                                  widget.orderList[widget.index].email,
                              context);
                          Navigator.pop(context);
                          await orderprovider.getFirstPendingOrders();
                          await orderprovider.changePmore(false);
                          print('mark as complete');
                        }),
                ),
              const SizedBox(
                height: 10.0,
              ),
              if (widget.orderList[widget.index].status == true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: orderprovider.deleteloading == true
                      ? loadingButton(MediaQuery.of(context).size)
                      : Button(MediaQuery.of(context).size, "Delete",
                          Colors.black, AppConfig.primaryColor, () async {
                          await orderprovider.deleteOrder(
                              widget.orderList[widget.index].date +
                                  widget.orderList[widget.index].email,
                              context);
                          Navigator.pop(context);
                          orderprovider.getFirstCompOrders();
                        }),
                )
            ]),
      ),
    );
  }
}

row(name, value) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Row(
      children: [
        Text(name,
            style: const TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
        Text(value,
            style: const TextStyle(color: Colors.black54, fontSize: 15.0)),
      ],
    ),
  );
}
