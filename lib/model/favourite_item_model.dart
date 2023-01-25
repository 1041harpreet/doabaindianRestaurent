import 'dart:convert';

List<FavItem> favDataFromJson(String str) =>
    List<FavItem>.from(json.decode(str).map((x) => FavItem.fromJson(x)));

String favDataToJson(List<FavItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavItem {
  FavItem({
    required this.title,
    required this.category,
    required this.img,
    required this.price,
  });

  String title;
  String category;
  String img;
  double price;

  factory FavItem.fromJson(Map<String, dynamic> json) => FavItem(
      title: json["title"],
      category: json["category"],
      img: json["img"],
      price: json["price"]);

  Map<String, dynamic> toJson() => {
        "title": title,
        "category": category,
        "img": img,
        "price": price,
      };
}
