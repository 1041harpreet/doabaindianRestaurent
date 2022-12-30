import 'dart:convert';

List<OrderItem> orderItemFromJson(String str) =>
    List<OrderItem>.from(json.decode(str).map((x) => OrderItem.fromJson(x)));

String orderItemToJson(List<OrderItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderItem {
  OrderItem({
    required this.title,
    required this.count,
    required this.total,
    required this.img,
    required this.price,
    required this.category,
  });

  String title;
  String category;
  String img;
  int count;
  double total;
  double price;
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
      title: json["title"],
    category: json["category"],
    img: json["img"],
      count: json["count"],
      total: json["total"],
      price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "category":category,
    "img":img,
    "count": count,
    "total": total,
    "price": price,
  };
}
