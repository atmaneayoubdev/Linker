import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linker/models/chats/chat_list_model.dart';
import 'package:linker/models/chats/message_model.dart';
import 'package:linker/models/chats/user_receiver_model.dart';

import '../helpers/constants.dart';

class ChatController with ChangeNotifier {
  ////////////////////Get Messages List//////////////////////
  static Future<ChatListModel> getChat({
    required String token,
    required String type,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'devices-token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}chats?type=$type",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        return ChatListModel.fromJson(response.data);
      }
      return response.data["message"];
    } on DioError catch (error) {
      debugPrint(error.message!);
      rethrow;
    }
  }

  ////////////////////Get Reload Chat//////////////////////
  static Future getReloadChat({
    required String token,
    required String chatId,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'devices-token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}chats/$chatId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        UserReceiverModel userReceiverModel = UserReceiverModel.fromJson(
          response.data["user_receiver"],
        );
        List<MessageModel> chats = [];
        chats = (response.data['data'] as List)
            .map((x) => MessageModel.fromJson(x))
            .toList();

        return {
          "chats": chats,
          "user": userReceiverModel,
        };
      }
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message ?? "error";
    }
  }

  ////////////////////Send message//////////////////////
  static Future sendMessage({
    required String token,
    required String userId,
    required String message,
    required String type,
    required bool isStore,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "user_id": userId,
        "message": message,
        "type": type,
        "user_type": isStore ? "store" : "default",
      });
      var response = await dio.post(
        "${baseUrl}chats",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            'devices-token': deviceToken,
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
        ),
        data: formData,
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        return {
          "message": response.data['message'].toString(),
          "chat_id": response.data['data']['chat_id'].toString(),
        };
      }
      if (response.statusCode == 400) {
        return {
          "message": response.data['message'].toString(),
          //"chat_id": response.data['data']['chat_id'].toString(),
        };
      }
    } on DioError catch (error) {
      debugPrint(error.toString());
      return error.message;
    }
  }
}
