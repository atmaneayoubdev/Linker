import 'package:linker/models/post/comment_model.dart';
import 'package:linker/models/post/image_model.dart';
import 'package:linker/models/post/post_model.dart';
import 'package:linker/models/post/small_user_model.dart';
import 'package:linker/ui/home/views/thread_model.dart';

import '../market/product_model.dart';
import '../market/store_model.dart';

class OnePostModel {
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
  List<CommentModel> commentsList;
  List<ThreadModel> threads;
  PostModel? postTypeInfo;
  ProductModel? postTypeInfoProduct;
  StoreModel? postTypeInfoStore;

  OnePostModel({
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
    required this.commentsList,
    required this.threads,
    required this.postTypeInfo,
    required this.postTypeInfoProduct,
    required this.postTypeInfoStore,
  });

  factory OnePostModel.fromJson(Map<String, dynamic> json) => OnePostModel(
        id: json["data"]['id'].toString(),
        user: SmallUserModel.fromJson(json["data"]['user']),
        description: json["data"]['description'].toString(),
        likes: json["data"]['likes'].toString(),
        comments: json["data"]['comments'].toString(),
        createdAt: json["data"]['created_at'].toString(),
        images: (json["data"]['images'] as List)
            .map((x) => ImageModel.fromJson(x))
            .toList(),
        postType: json["data"]['post_type'].toString(),
        shares: json["data"]['shares'].toString(),
        isLiked: json["data"]["is_liked"].toString(),
        commentsList: (json['comments'] as List)
            .map((x) => CommentModel.fromJson(x))
            .toList(),
        threads: (json["data"]['threads'] as List)
            .map((x) => ThreadModel.fromJson(x))
            .toList(),
        postTypeInfo: json["data"]['post_type_info'].toString() == 'null' ||
                json["data"]['post_type'].toString() != "post"
            ? null
            : PostModel.fromJson(json["data"]["post_type_info"]),
        postTypeInfoProduct:
            json["data"]['post_type_info'].toString() == 'null' ||
                    json["data"]['post_type'].toString() != "product"
                ? null
                : ProductModel.fromJson(json["data"]['post_type_info']),
        postTypeInfoStore:
            json["data"]['post_type_info'].toString() == 'null' ||
                    json["data"]['post_type'].toString() != "store"
                ? null
                : StoreModel.fromJson(json["data"]['post_type_info']),
      );
}
