import 'package:linker/models/post/small_user_model.dart';

class SubRateModel {
  String id;
  SmallUserModel user;
  String rate;
  String feedback;
  String craetedAt;

  SubRateModel({
    required this.id,
    required this.user,
    required this.craetedAt,
    required this.feedback,
    required this.rate,
  });

  factory SubRateModel.fromJson(Map<String, dynamic> json) => SubRateModel(
        id: json["id"].toString(),
        user: SmallUserModel.fromJson(json["user"]),
        craetedAt: json["created_at"].toString(),
        feedback: json["feedback"].toString(),
        rate: json["rate"].toString(),
      );
}
