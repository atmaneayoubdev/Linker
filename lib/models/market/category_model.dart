class MarketCategoryModel {
  String id;
  String name;

  MarketCategoryModel({
    required this.id,
    required this.name,
  });

  factory MarketCategoryModel.fromJson(Map<String, dynamic> json) =>
      MarketCategoryModel(
        id: json["id"].toString(),
        name: json["name"].toString(),
      );
}
