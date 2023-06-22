import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linker/models/general/pagination.dart';
import 'package:linker/models/post/one_post_model.dart';

import '../helpers/constants.dart';
import '../models/post/post_model.dart';

class PostController with ChangeNotifier {
  ////////////////////Get Posts List//////////////////////
  static Future getMyPosts({
    required String token,
    required int page,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'devices-token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get("${baseUrl}posts",
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ),
          queryParameters: {
            "page": page,
          });
      log(response.data.toString());

      if (response.statusCode == 200) {
        List<PostModel> posts = [];
        posts = (response.data["data"] as List)
            .map((x) => PostModel.fromJson(x))
            .toList();

        return {
          "posts": posts,
          "pagination": Pagination.fromJson(response.data["paginate"]),
        };
      }
      return {
        "posts": [],
        "pagination": null,
      };
    } on DioError catch (error) {
      log(error.message!);
      return {
        "posts": [],
        "pagination": null,
      };
    }
  }

  ////////////////////create Post//////////////////////
  static Future createPost({
    required String token,
    required String description,
    required String deviceToken,

    //required List<File> images,
  }) async {
    try {
      Dio dio = Dio();
      // for (var item in images) {
      //   String fileName = item.path.split('/').last;
      //   files.add(await MultipartFile.fromFile(
      //     item.path,
      //     filename: fileName,
      //   ));
      // }
      log(description.length.toString());
      FormData formData = FormData.fromMap({
        // if (images.isNotEmpty) "images[]": files,
        "description": description.toString(),
        "thread": description.toString().length < 286 ? 0 : 1,
      });
      var response = await dio.post(
        "${baseUrl}posts",
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

  ////////////////////Update Post//////////////////////
  static Future updatePost({
    required String token,
    required String description,
    //required List<File> images,
    required String postId,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      // List<MultipartFile> files = [];
      // for (var item in images) {
      //   String fileName = item.path.split('/').last;
      //   files.add(await MultipartFile.fromFile(
      //     item.path,
      //     filename: fileName,
      //   ));
      // }
      log(description.length.toString());
      FormData formData = FormData.fromMap({
        //if (images.isNotEmpty) "images[]": files,
        "description": description.toString(),
        "thread": description.toString().length < 286 ? 0 : 1,
      });
      var response = await dio.post(
        "${baseUrl}posts/$postId/update",
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

  //////////////////// Like Unlike Post//////////////////////
  static Future likeUnlikePost({
    required String token,
    required String postId,
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
        "${baseUrl}posts/$postId/like",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());

      return response.data["message"].toString();
    } on DioError catch (error) {
      log(error.message.toString());
      return error.message;
    }
  }

  ////////////////////Show post//////////////////////
  static Future<OnePostModel> showPost({
    required String token,
    required String postId,
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
        "${baseUrl}posts/$postId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      OnePostModel post = OnePostModel.fromJson(response.data);
      return post;
    } on DioError catch (error) {
      log(error.message.toString());
      rethrow;
    }
  }

  ////////////////////Send Comment//////////////////////
  static Future sendComment({
    required String token,
    required String postId,
    required String comment,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "comment": comment,
      });
      var response = await dio.post(
        "${baseUrl}posts/$postId/comments",
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

  ////////////////////create Post//////////////////////
  static Future sharePost({
    required String token,
    required String postType,
    required String postTypeId,
    required String deviceToken,
    required String description,
  }) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "post_type": postType,
        "post_type_id": postTypeId,
        "description": description,
      });
      var response = await dio.post(
        "${baseUrl}posts/share",
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

  ////////////////////Delete Post//////////////////////
  static Future deletePost({
    required String token,
    required String postId,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();

      var response = await dio.delete(
        "${baseUrl}posts/$postId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            'devices-token': deviceToken,
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
        ),
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

  ////////////////////Delete Post Image//////////////////////
  static Future deletePostImage({
    required String token,
    required String postId,
    required String imageId,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();

      var response = await dio.delete(
        "${baseUrl}posts/$postId/image/$imageId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            'devices-token': deviceToken,
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
        ),
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
}
