import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/general/intro_model.dart';
import 'package:linker/models/general/search_model.dart';
import 'package:linker/models/general/specialty_model.dart';

import '../models/general/pagination.dart';

class GlobalController with ChangeNotifier {
  ////////////////////get categories//////////////////////
  static Future<List<SpecialtyModel>> getSpecialies() async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}specialties",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<SpecialtyModel> specialties = [];
        specialties = (response.data['data'] as List)
            .map((x) => SpecialtyModel.fromJson(x))
            .toList();
        return specialties;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message.toString());
      return [];
    }
  }

  ////////////////////Get Page//////////////////////
  static Future<String> getPage(String name) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
      };
      Dio dio = Dio();
      var response = await dio.get(
        "${baseUrl}pages/$name",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      return response.data['data']['content'];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return '';
    }
  }

  ////////////////////Get Search//////////////////////
  static Future getSearch({
    required String token,
    required String text,
    required String deviceToken,
    required int postsPage,
    required int usersPage,
    required bool isPosts,
  }) async {
    try {
      Map<String, String> headers = {
        'devices-token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.post("${baseUrl}search",
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ),
          queryParameters: {
            "page": isPosts ? postsPage : usersPage,
          },
          data: {
            "text": text,
          });
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        SearchModel searchResult = SearchModel(users: [], posts: []);
        searchResult = SearchModel.fromJson(response.data["data"]);
        //return searchResult;
        return {
          "results": searchResult,
          "postsPaginate": Pagination.fromJson(response.data["postsPaginate"]),
          "usersPaginate": Pagination.fromJson(response.data["usersPaginate"]),
        };
      }
      return SearchModel(users: [], posts: []);
    } on DioError catch (error) {
      debugPrint(error.message!);
      return SearchModel(users: [], posts: []);
    }
  }

  ////////////////////send Message//////////////////////
  static Future sendMessage({
    required String token,
    required String text,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'devices-token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.post("${baseUrl}send-message",
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ),
          data: {
            "message": text,
          });
      debugPrint(response.data.toString());
      return response.data["message"];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message;
    }
  }

  ////////////////////get Intro pages//////////////////////
  static Future<List<IntroModel>> getIntros() async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}intros",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<IntroModel> intros = [];
        intros = (response.data['data'] as List)
            .map((x) => IntroModel.fromJson(x))
            .toList();
        return intros;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message.toString());
      return [];
    }
  }
}
