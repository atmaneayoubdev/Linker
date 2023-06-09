class SpecialtyModel {
  String name;
  String id;
  String description;
  String image;

  SpecialtyModel({
    required this.name,
    required this.id,
    required this.image,
    required this.description,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) => SpecialtyModel(
        name: json["name"].toString(),
        id: json["id"].toString(),
        image: json["image"].toString(),
        description: json["description"].toString(),
      );
}
