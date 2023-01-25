import 'dart:convert';

List<CategoryItem> categoryDataFromJson(String str) => List<CategoryItem>.from(
    json.decode(str).map((x) => CategoryItem.fromJson(x)));

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
      title: json["title"], description: json["description"], img: json["img"]);

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "img": img,
      };
}

List<MadeForUItem> madeforuDataFromJson(String str) => List<MadeForUItem>.from(
    json.decode(str).map((x) => MadeForUItem.fromJson(x)));

String madeforuDataToJson(List<MadeForUItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MadeForUItem {
  MadeForUItem({
    required this.title,
    required this.category,
    required this.img,
    required this.price,
    required this.old,
  });

  String title;
  String category;
  String img;
  double price;
  double old;

  factory MadeForUItem.fromJson(Map<String, dynamic> json) => MadeForUItem(
      title: json["title"],
      category: json["category"],
      price: json["price"],
      old: json["old"],
      img: json["img"]);

  Map<String, dynamic> toJson() => {
        "title": title,
        "category": category,
        "img": img,
        "old": old,
        "price": price
      };
}

List<DropDownItem> dropDownFromJson(String str) => List<DropDownItem>.from(
    json.decode(str).map((x) => DropDownItem.fromJson(x)));

String dropDownToJson(List<DropDownItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DropDownItem {
  DropDownItem({
    required this.title,
  });

  String title;

  factory DropDownItem.fromJson(Map<String, dynamic> json) => DropDownItem(
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
      };
}
