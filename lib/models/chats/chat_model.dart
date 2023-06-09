import 'package:linker/models/chats/last_message_model.dart';
import 'package:linker/models/chats/small_user_2_model.dart';

class ChatModel {
  String id;
  SmallUserModel2 user;
  LastMessageModel lastMessage;
  String lastDate;

  ChatModel({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.lastDate,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"].toString(),
        user: SmallUserModel2.fromJson(json["user"]),
        lastMessage: LastMessageModel.fromJson(json["last_message"]),
        lastDate: json["lastDate"].toString(),
      );
}
