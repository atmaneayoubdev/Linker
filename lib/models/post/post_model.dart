import 'package:linker/models/market/product_model.dart';
import 'package:linker/models/market/store_model.dart';
import 'package:linker/models/post/image_model.dart';
import 'package:linker/models/post/small_user_model.dart';
import 'package:linker/ui/home/views/thread_model.dart';

class PostModel {
  String id;
  SmallUserModel user;
  String description;
  String likes;
  String comments;
  String shares;
  List<ImageModel> images;
  String createdAt;
  String postType;
  String isLiked;
  List<ThreadModel> threads;
  PostModel? postTypeInfo;
  ProductModel? postTypeInfoProduct;
  StoreModel? postTypeInfoStore;

  PostModel({
    required this.id,
    required this.user,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.images,
    required this.createdAt,
    required this.postType,
    required this.isLiked,
    required this.threads,
    required this.postTypeInfo,
    required this.postTypeInfoProduct,
    required this.postTypeInfoStore,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'].toString(),
        user: SmallUserModel.fromJson(json['user']),
        description: json['description'].toString(),
        likes: json['likes'].toString(),
        comments: json['comments'].toString(),
        createdAt: json['created_at'].toString(),
        images: (json['images'] as List)
            .map((x) => ImageModel.fromJson(x))
            .toList(),
        threads: (json['threads'] as List)
            .map((x) => ThreadModel.fromJson(x))
            .toList(),
        postType: json['post_type'].toString(),
        shares: json['shares'].toString(),
        isLiked: json["is_liked"].toString(),
        postTypeInfo: json['post_type_info'].toString() == 'null' ||
                json['post_type'].toString() != "post"
            ? null
            : PostModel.fromJson(json["post_type_info"]),
        postTypeInfoProduct: json['post_type_info'].toString() == 'null' ||
                json['post_type'].toString() != "product"
            ? null
            : ProductModel.fromJson(json['post_type_info']),
        postTypeInfoStore: json['post_type_info'].toString() == 'null' ||
                json['post_type'].toString() != "store"
            ? null
            : StoreModel.fromJson(json['post_type_info']),
      );
}
