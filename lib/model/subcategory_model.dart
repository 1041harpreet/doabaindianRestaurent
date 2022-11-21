import 'dart:convert';

List<SubCategoryItem> subcategoryDataFromJson(String str) =>
    List<SubCategoryItem>.from(
        json.decode(str).map((x) => SubCategoryItem.fromJson(x)));

String subcategoryDataToJson(List<SubCategoryItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubCategoryItem {
  SubCategoryItem({
    required this.title,
    required this.description,
    required this.img,
    required this.price,
  });

  String title;
  String description;
  String img;
  double price;

  factory SubCategoryItem.fromJson(Map<String, dynamic> json) =>
      SubCategoryItem(
          title: json["title"],
          description: json["description"],
          img: json["img"],
          price: json["price"]);

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "img": img,
        "price": price,
      };
}
