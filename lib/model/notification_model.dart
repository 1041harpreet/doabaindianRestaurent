import 'dart:convert';

import 'package:flutter/widgets.dart';

List<NotificationItem> subcategoryDataFromJson(String str) =>
    List<NotificationItem>.from(
        json.decode(str).map((x) => NotificationItem.fromJson(x)));

String subcategoryDataToJson(List<NotificationItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationItem {
  NotificationItem({
    required this.date,
    required this.email,
    required this.orderID,
    required this.status,
    required this.total,
    required this.tax,
  });

  String date;
  String email;
  String orderID;
  bool status;
  var tax;
  var total;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
          date: json["date"],
          email: json["email"],
          orderID: json["orderID"],
          status: json["status"],
          tax: json["tax"],
          total: json["total"],

      );

  Map<String, dynamic> toJson() => {
    "date": date,
    "email": email,
    "orderID": orderID,
    "status": status,
    "tax": tax,
    "total": total,
  };
}
