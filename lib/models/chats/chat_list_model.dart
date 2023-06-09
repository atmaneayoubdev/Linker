import 'package:linker/models/chats/chat_model.dart';

class ChatListModel {
  List<ChatModel> chats;
  String newMessages;

  ChatListModel({
    required this.chats,
    required this.newMessages,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
        chats:
            (json['data'] as List).map((x) => ChatModel.fromJson(x)).toList(),
        newMessages: json["new_messages"].toString(),
      );
}
