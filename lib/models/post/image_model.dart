class ImageModel {
  String id;
  String image;

  ImageModel({
    required this.id,
    required this.image,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"].toString(),
        image: json["image"].toString(),
      );
}
