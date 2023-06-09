import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linker/models/general/story_model.dart';

import '../helpers/constants.dart';
import '../models/general/specialty_model.dart';

class StoryController with ChangeNotifier {
  ////////////////////Get All Stroeis List//////////////////////
  static Future<List<StroyModel>> getAllStories({
    required String token,
    String? specialtyId,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        specialtyId == null
            ? "${baseUrl}stories/all?orderByLikes"
            : "${baseUrl}stories/all?orderByLikes&specialty_id=$specialtyId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        List<StroyModel> stories = [];
        stories = (response.data['data'] as List)
            .map((x) => StroyModel.fromJson(x))
            .toList();

        return stories;
      }
      return [];
    } on DioError {
      return [];
    }
  }

  ////////////////////Get Following Story List//////////////////////
  static Future<List<StroyModel>> getFollowingStories({
    required String token,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}stories",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());

      if (response.statusCode == 200) {
        List<StroyModel> stories = [];
        stories = (response.data['data'] as List)
            .map((x) => StroyModel.fromJson(x))
            .toList();

        return stories;
      }
      return [];
    } on DioError catch (error) {
      log(error.toString());
      return [];
    }
  }

  ////////////////////show single story//////////////////////
  static Future showSingleStory({
    required String token,
    required String deviceToken,
    required String storyId,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}stories/$storyId/show",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      return StroyModel.fromJson(response.data["data"]);
    } on DioError catch (error) {
      log(error.toString());
      return error.message;
    }
  }

  ////////////////////get categories//////////////////////
  static Future<List<SpecialtyModel>> getSpecialies(
    String token,
    String deviceToken,
  ) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}stories/getSpecialties",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        List<SpecialtyModel> specialties = [];
        specialties = (response.data['data'] as List)
            .map((x) => SpecialtyModel.fromJson(x))
            .toList();
        return specialties;
      }
      return [];
    } on DioError catch (error) {
      log(error.message.toString());
      return [];
    }
  }

  //////////////////// Like Unlike Story//////////////////////
  static Future likeUnlikePost({
    required String token,
    required String storyId,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}stories/$storyId/likes",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());

      return response.data["message"].toString();
    } on DioError catch (error) {
      log(error.message!);
      return error.message;
    }
  }

  ////////////////////create createStory//////////////////////
  static Future createStory({
    required String token,
    required String description,
    required File image,
    required int speciatltyId,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      String fileName = image.path.split('/').last;

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
        "description": description,
        "specialty_id": speciatltyId,
      });
      var response = await dio.post(
        "${baseUrl}stories",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            'Devices_Token': deviceToken,
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
        ),
        data: formData,
      );
      log(response.data.toString());

      if (response.statusCode == 200) {
        return response.data['message'];
      }
      if (response.statusCode == 400) {
        return response.data['message'].toString();
      }
    } on DioError catch (error) {
      log(error.toString());
      return error.message;
    }
  }

  //////////////////// Like Unlike Sotory//////////////////////
  static Future likeUnlikeStory({
    required String token,
    required String storyId,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}posts/$storyId/like",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());

      return response.data["message"].toString();
    } on DioError catch (error) {
      log(error.message!);
      return error.message;
    }
  }

  //////////////////// Delete Post//////////////////////
  static Future deleteStory({
    required String token,
    required String storyId,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.delete(
        "${baseUrl}stories/$storyId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());

      return response.data["message"].toString();
    } on DioError catch (error) {
      log(error.message!);
      return error.message;
    }
  }
}
