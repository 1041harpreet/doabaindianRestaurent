import 'dart:convert';

List<SliderItem> sliderItemFromJson(String str) =>
    List<SliderItem>.from(json.decode(str).map((x) => SliderItem.fromJson(x)));

String sliderItemToJson(List<SliderItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SliderItem {
  SliderItem({required this.img});

  String img;

  factory SliderItem.fromJson(Map<String, dynamic> json) => SliderItem(
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
      };
}
