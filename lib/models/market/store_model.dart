import 'package:linker/models/market/category_model.dart';

class StoreModel {
  String id;
  String storeName;
  String email;
  String phone;
  String rate;
  String type;
  String photo;
  String cover;
  String shortDescription;
  String storeInformation;
  String storePolicy;
  String productCount;
  String isFavorite;
  List<MarketCategoryModel> categories;
  String chatId;

  StoreModel({
    required this.categories,
    required this.cover,
    required this.id,
    required this.email,
    required this.phone,
    required this.photo,
    required this.rate,
    required this.shortDescription,
    required this.storeInformation,
    required this.storeName,
    required this.storePolicy,
    required this.type,
    required this.isFavorite,
    required this.productCount,
    required this.chatId,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        id: json['id'].toString(),
        storeName: json['store_name'].toString(),
        email: json['email'].toString(),
        phone: json['phone'].toString(),
        rate: json['rate'].toString(),
        type: json['type'].toString(),
        photo: json['photo'].toString(),
        cover: json['cover'].toString(),
        shortDescription: json['short_description'].toString(),
        storeInformation: json['store_information'].toString(),
        storePolicy: json['store_policy'].toString(),
        productCount: json['product_count'].toString(),
        isFavorite: json['is_fav'].toString(),
        chatId: json['chat_id'].toString(),
        categories: (json['categories'] as List)
            .map((x) => MarketCategoryModel.fromJson(x))
            .toList(),
      );
}
