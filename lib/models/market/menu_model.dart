class MenuModel {
  String id;
  String name;

  MenuModel({
    required this.id,
    required this.name,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        id: json["id"].toString(),
        name: json["name"].toString(),
      );
}
