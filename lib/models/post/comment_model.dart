import 'package:linker/models/post/small_user_model.dart';

class CommentModel {
  String id;
  SmallUserModel user;
  String comment;
  String createdAt;

  CommentModel({
    required this.id,
    required this.user,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"].toString(),
        user: SmallUserModel.fromJson(json["user"]),
        comment: json["comment"].toString(),
        createdAt: json["created_at"].toString(),
      );
}
