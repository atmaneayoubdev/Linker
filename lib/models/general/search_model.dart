import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/models/post/post_model.dart';

class SearchModel {
  List<OtherUser> users;
  List<PostModel> posts;

  SearchModel({
    required this.users,
    required this.posts,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        users:
            (json['users'] as List).map((x) => OtherUser.fromJson(x)).toList(),
        posts:
            (json['posts'] as List).map((x) => PostModel.fromJson(x)).toList(),
      );
}
