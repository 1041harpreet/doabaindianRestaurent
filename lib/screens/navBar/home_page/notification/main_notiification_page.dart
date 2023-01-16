import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent.app/config/config.dart';
import 'package:restaurent.app/provider/notification_provider.dart';

import 'detail_notification.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(notificationProvider).getFirstNotification();
      controller.addListener(_scrollListener);
    });
    super.initState();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      // ref.watch(notificationProvider).fetchNextNotifications(context);

      print("at the end of list");
    }
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationprovider = ref.watch(notificationProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConfig.primaryColor,
          title: Text("Notifications"),
          actions: [
           Tooltip(child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Icon(Icons.info),
           ),
           message: "You can only view latest 10 Notifications",
             triggerMode: TooltipTriggerMode.tap,
           )
          ],
        ),
        backgroundColor: AppConfig.secmainColor,
        body: notificationprovider.loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : notificationprovider.notificationList.length == 0
                ? Center(
                    child: Text("No Notification", style: AppConfig.blacktext),
                  )
                : ListView.builder(
                    controller: controller,
                    itemCount: notificationprovider.notificationList.length,
                    itemBuilder: (context, index) {
                      return notificationItem(
                          context, notificationprovider, index);
                    },
                  ));
  }
}
