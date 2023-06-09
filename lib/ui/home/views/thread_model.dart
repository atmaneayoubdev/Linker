import 'package:linker/models/post/small_user_model.dart';

class ThreadModel {
  String id;
  SmallUserModel user;
  String description;
  String likes;
  String comments;
  String shares;
  String createdAt;

  ThreadModel({
    required this.id,
    required this.user,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.createdAt,
  });

  factory ThreadModel.fromJson(Map<String, dynamic> json) => ThreadModel(
        id: json['id'].toString(),
        user: SmallUserModel.fromJson(json['user']),
        description: json['description'].toString(),
        likes: json['likes'].toString(),
        comments: json['comments'].toString(),
        createdAt: json['created_at'].toString(),
        shares: json['shares'].toString(),
      );
}
