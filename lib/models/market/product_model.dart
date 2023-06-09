import 'package:linker/models/market/category_model.dart';
import 'package:linker/models/market/menu_model.dart';
import 'package:linker/models/market/mini_store_model.dart';
import 'package:linker/models/post/image_model.dart';

class ProductModel {
  String id;
  MiniStoreModel store;
  MarketCategoryModel category;
  MenuModel menu;
  String title;
  String description;
  String price;
  String rates;
  String url;
  String isFavorite;
  String mainImage;
  List<ImageModel> images;

  ProductModel({
    required this.category,
    required this.description,
    required this.id,
    required this.images,
    required this.isFavorite,
    required this.mainImage,
    required this.menu,
    required this.price,
    required this.rates,
    required this.store,
    required this.title,
    required this.url,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'].toString(),
        category: MarketCategoryModel.fromJson(json['category']),
        menu: MenuModel.fromJson(json['menu']),
        store: MiniStoreModel.fromJson(json['store']),
        description: json['description'].toString(),
        isFavorite: json['is_fav'].toString(),
        mainImage: json['main_image'].toString(),
        url: json['url'].toString(),
        images: (json['images'] as List)
            .map((x) => ImageModel.fromJson(x))
            .toList(),
        rates: json['rates'].toString(),
        price: json['price'].toString(),
        title: json["title"].toString(),
      );
}
