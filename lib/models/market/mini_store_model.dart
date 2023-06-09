class MiniStoreModel {
  String id;
  String storeName;
  String photo;
  String cover;
  String productCount;

  MiniStoreModel({
    required this.id,
    required this.cover,
    required this.photo,
    required this.productCount,
    required this.storeName,
  });

  factory MiniStoreModel.fromJson(Map<String, dynamic> json) => MiniStoreModel(
        id: json["id"].toString(),
        storeName: json["store_name"].toString(),
        photo: json["photo"].toString(),
        cover: json["cover"].toString(),
        productCount: json["product_count"].toString(),
      );
}
