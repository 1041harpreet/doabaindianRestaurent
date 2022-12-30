import 'dart:convert';

List<AdminOrderItem> adminOrderDataFromJson(String str) =>
    List<AdminOrderItem>.from(json.decode(str).map((x) => AdminOrderItem.fromJson(x)));

String adminOrderDataToJson(List<AdminOrderItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminOrderItem {
  AdminOrderItem({
    required this.email,
    required this.date,
    required this.tax,
    required this.name,
    required this.phone,
    required this.total,
    required this.status,
    required this.note,
    required this.orderID,
  });

  String email;
  double total;
  String date;
  String name;
  String orderID;
  String phone;
  String note;
  double tax;
  String status;

  factory AdminOrderItem.fromJson(Map<String, dynamic> json) => AdminOrderItem(
      email: json["email"],
      total: json["total"],
      date: json["date"],
      name: json["name"],
      orderID: json["orderID"],
      note: json["note"],
      status: json["status"],
      phone: json["phone"],
      tax: json["tax"]);

  Map<String, dynamic> toJson() => {
    "email": email,
    "total": total,
    "date": date,
    "name": name,
    "orderID": orderID,
    "note": note,
    "tax": tax,
    "status": status,
    "phone": phone,
  };
}

List<AdminOrderItemDetails> adminOrderDetailDataFromJson(String str) =>
    List<AdminOrderItemDetails>.from(json.decode(str).map((x) => AdminOrderItemDetails.fromJson(x)));

String adminOrderDetailDataToJson(List<AdminOrderItemDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminOrderItemDetails {
  AdminOrderItemDetails({
    required this.title,
    required this.count,
    required this.total,
  });

  String title;
  double total;
  int count;


  factory AdminOrderItemDetails.fromJson(Map<String, dynamic> json) => AdminOrderItemDetails(
      title: json["title"],
      total: json["total"],
      count: json["count"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "total": total,
    "count": count,

  };
}
