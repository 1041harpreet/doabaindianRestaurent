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
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(notificationProvider).getNotification();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationprovider = ref.watch(notificationProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConfig.primaryColor,
          title: Text("Notifications"),
        ),
        backgroundColor: AppConfig.secmainColor,
        body: notificationprovider.loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : notificationprovider.notificationList.length == 0
                ? Center(
                    child: Text("No Notification",style: AppConfig.blacktext),
                  )
                : ListView.builder(
                    itemCount: notificationprovider.notificationList.length,
                    itemBuilder: (context, index) {
                      return notificationItem(context,notificationprovider,index);
                    },
                  ));
  }
}
