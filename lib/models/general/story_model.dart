import 'package:linker/models/general/specialty_model.dart';
import 'package:linker/models/post/image_model.dart';
import 'package:linker/models/post/small_user_model.dart';

class StroyModel {
  String id;
  SmallUserModel user;
  SpecialtyModel specialtyModel;
  String imageCount;
  String description;
  List<ImageModel> images;
  String likes;
  String views;
  String createdAt;
  String isLiked;

  StroyModel({
    required this.imageCount,
    required this.id,
    required this.user,
    required this.specialtyModel,
    required this.createdAt,
    required this.description,
    required this.images,
    required this.likes,
    required this.views,
    required this.isLiked,
  });

  factory StroyModel.fromJson(Map<String, dynamic> json) => StroyModel(
        id: json["id"].toString(),
        user: SmallUserModel.fromJson(json["user"]),
        specialtyModel: SpecialtyModel.fromJson(json["specialty"]),
        createdAt: json["created_at"].toString(),
        description: json["description"].toString(),
        imageCount: json["images_count"].toString(),
        images: (json['images'] as List)
            .map((x) => ImageModel.fromJson(x))
            .toList(),
        likes: json["likes"].toString(),
        views: json["views"].toString(),
        isLiked: json["is_liked"].toString(),
      );
}
