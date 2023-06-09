import 'package:linker/models/chats/product_object_model.dart';
import 'package:linker/models/chats/small_user_2_model.dart';

class MessageModel {
  String id;
  SmallUserModel2 user;
  String sendByMe;
  String message;
  String type;
  ObjectProductModel? object;
  String createdAt;

  MessageModel({
    required this.createdAt,
    required this.id,
    required this.user,
    required this.sendByMe,
    required this.message,
    required this.type,
    required this.object,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        sendByMe: json["sendByMe"].toString(),
        message: json["message"].toString(),
        type: json["type"].toString(),
        object: json["object"].toString() == "null"
            ? null
            : ObjectProductModel.fromJson(json["object"]),
        id: json["id"].toString(),
        user: SmallUserModel2.fromJson(json["user"]),
        createdAt: json["created_at"].toString(),
      );
}
