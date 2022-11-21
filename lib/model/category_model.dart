import 'dart:convert';

List<CategoryItem> categoryDataFromJson(String str) =>
    List<CategoryItem>.from(json.decode(str).map((x) => CategoryItem.fromJson(x)));

String categoryDataToJson(List<CategoryItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryItem {
  CategoryItem({
    required this.title,
    required this.description,
    required this.img,

  });

  String title;
  String description;
  String img;

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
      title: json["title"],
      description: json["description"],
      img: json["img"]);

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "img": img,
  };
}
