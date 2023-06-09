class ObjectProductModel {
  String id;
  String title;
  String mainImage;

  ObjectProductModel({
    required this.id,
    required this.title,
    required this.mainImage,
  });

  factory ObjectProductModel.fromJson(Map<String, dynamic> json) =>
      ObjectProductModel(
        mainImage: json["main_image"].toString(),
        id: json["id"].toString(),
        title: json["title"].toString(),
      );
}
