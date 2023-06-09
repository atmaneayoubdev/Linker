class IntroModel {
  String id;
  String description;
  String image;

  IntroModel({
    required this.id,
    required this.description,
    required this.image,
  });

  factory IntroModel.fromJson(Map<String, dynamic> json) => IntroModel(
        id: json["id"].toString(),
        description: json["description"].toString(),
        image: json["image"].toString(),
      );
}
