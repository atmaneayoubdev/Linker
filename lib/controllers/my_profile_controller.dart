import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/models/general/notification_model.dart';
import 'package:linker/models/general/specialty_model.dart';
import 'package:linker/models/post/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth/user_model.dart';

class MyProfileController with ChangeNotifier {
  ////////////////////get Specialities//////////////////////
  static Future getMySpecialties({
    required String token,
    required String deviceToken,
    bool? notInt,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}my-profile/my-specialties",
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
        List<int> list = [];
        for (var item in specialties) {
          list.add((int.parse(item.id)));
        }
        if (notInt != null) {
          return specialties;
        }
        return list;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get Interests//////////////////////
  static Future getMyInterests({
    required String token,
    required String deviceToken,
    bool? notInt,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}my-profile/my-interests",
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
        List<int> list = [];
        for (var item in specialties) {
          list.add((int.parse(item.id)));
        }
        if (notInt != null) {
          return specialties;
        }
        return list;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////////////Edit Speciaties////////////////////////////////
  static Future editSpecialties({
    required List<int> specialties,
    required String token,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "specialties[]": specialties,
      });
      var response = await dio.post(
        "${baseUrl}my-profile/my-specialties",
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
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        return 'success';
      }
      if (response.statusCode == 400) {
        return response.data['message'].toString();
      }
    } on DioError catch (error) {
      debugPrint(error.toString());
      return {
        'message': error.message,
      };
    }
  }

  ////////////////////////////Edit Interests////////////////////////////////
  static Future editInterest({
    required List<int> specialties,
    required String token,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "interests[]": specialties,
      });
      var response = await dio.post(
        "${baseUrl}my-profile/my-interests",
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
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        return 'success';
      }
      if (response.statusCode == 400) {
        return response.data['message'].toString();
      }
    } on DioError catch (error) {
      debugPrint(error.toString());
      return {
        'message': error.message,
      };
    }
  }

  ////////////////////////////Get My Profile///////////////////////////
  static Future getMyProfile({
    required String token,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      debugPrint(token);
      var response = await dio.get(
        "${baseUrl}my-profile",
        options: Options(headers: {
          'Devices_Token': deviceToken,
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        }),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        if (response.data['message'].toString() == "معلومات المستخدم") {
          User user;
          user = User.fromJson(response.data["data"]);
          user.apiToken = token;
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("id", user.id);
          prefs.setString('username', user.userName);
          prefs.setString('phone', user.phoneNumber);
          prefs.setString('job_title', user.jobTitle);
          prefs.setString('email', user.email);
          prefs.setString('avatar', user.avatar);
          prefs.setString('bio', user.bio);
          prefs.setString('followers', user.followers);
          prefs.setString('following', user.following);
          prefs.setString('posts', user.posts);
          prefs.setString('stories', user.stories);
          prefs.setString('notifications', user.notifications);
          prefs.setString('lastActionAt', user.lastActionAt);
          prefs.setString('api_token', token);

          return user;
        }
      }
      if (response.statusCode == 400) {
        return response.data['message'];
      }
    } on DioError catch (error) {
      debugPrint(error.message.toString());
      if (error.response!.statusCode == 400) {
        return error.response!.data['message'];
      }
      return "error";
    }
  }

  ////////////////////get profile posts//////////////////////
  static Future<List<PostModel>> getMyPosts({
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
        "${baseUrl}my-profile/my-posts",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        List<PostModel> posts = [];
        posts = (response.data['data'] as List)
            .map((x) => PostModel.fromJson(x))
            .toList();

        return posts;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////////////Show Profile///////////////////////////
  static Future showProfile({
    required String token,
    required String userId,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      debugPrint(token);
      var response = await dio.get(
        "${baseUrl}profile/$userId",
        options: Options(headers: {
          'Devices_Token': deviceToken,
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        }),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        if (response.data['message'].toString() == "معلومات المستخدم") {
          OtherUser user;

          user = OtherUser.fromJson(response.data["data"]);
          user.followHim = response.data['follow_him'].toString();

          return user;
        }
      }
      if (response.statusCode == 400) {
        return response.data['message'];
      }
    } on DioError catch (error) {
      debugPrint(error.message.toString());
      return error.response!.data["message"];
    }
  }

  ////////////////////get profile posts//////////////////////

  static Future<List<PostModel>> showProfilePosts({
    required String token,
    required String userId,
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
        "${baseUrl}profile/$userId/posts",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        List<PostModel> posts = [];
        posts = (response.data['data'] as List)
            .map((x) => PostModel.fromJson(x))
            .toList();

        return posts;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get single post//////////////////////

  static Future showSinglePost({
    required String token,
    required String postId,
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
        "${baseUrl}posts/$postId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      return PostModel.fromJson(response.data["data"]);
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message;
    }
  }

  ////////////////////Follow Unfollow//////////////////////

  static Future followUnfollow({
    required String token,
    required String userId,
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
        "${baseUrl}profile/$userId/follow",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      return response.data["message"].toString();
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message;
    }
  }

  ////////////////////Get Notifications//////////////////////
  static Future getNotifications({
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
        "${baseUrl}my-profile/notifications",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        List<NotificationModel> notifications = [];
        notifications = (response.data['data'] as List)
            .map((x) => NotificationModel.fromJson(x))
            .toList();
        return notifications;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  ////////////////////Get Notifications//////////////////////
  static Future getNotificationsCount({
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
        "${baseUrl}my-profile/get-notifications-count",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      if (response.data["message"] == "برجاء إستكمال بيانات الحساب اولا") {
        return "برجاء إستكمال بيانات الحساب اولا";
      } else {
        return response.data["data"]["notifications"].toString();
      }
    } on DioError catch (error) {
      debugPrint(error.toString());
      return error.message;
    }
  }

  ////////////////////delete one Notification//////////////////////
  static Future deleteNotification({
    required String token,
    required String notificatoinId,
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
        "${baseUrl}my-profile/notifications/$notificatoinId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      return response.data["message"].toString();
    } on DioError catch (error) {
      debugPrint(error.toString());
      return error.message;
    }
  }

  ////////////////////Delete all Notifications//////////////////////
  static Future deleteAllNotification({
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
        "${baseUrl}my-profile/notifications/delete-all-notifications",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      return response.data["notifications_count"].toString();
    } on DioError catch (error) {
      debugPrint(error.toString());
      return error.message;
    }
  }

  ////////////////////////////Edit Account info////////////////////////////////
  static Future editAcocuntInfo({
    required String token,
    required String username,
    required String jobTitle,
    required String bio,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "username": username,
        "bio": bio,
        "job_title": jobTitle,
      });
      var response = await dio.post(
        "${baseUrl}my-profile",
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
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        User user;
        user = User.fromJson(response.data["data"]);
        user.apiToken = token;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("id", user.id);
        prefs.setString('username', user.userName);
        prefs.setString('phone', user.phoneNumber);
        prefs.setString('job_title', user.jobTitle);
        prefs.setString('email', user.email);
        prefs.setString('avatar', user.avatar);
        prefs.setString('bio', user.bio);
        prefs.setString('followers', user.followers);
        prefs.setString('following', user.following);
        prefs.setString('posts', user.posts);
        prefs.setString('stories', user.stories);
        //prefs.setString('cartCount', user.cartCount);
        prefs.setString('notifications', user.notifications);
        prefs.setString('lastActionAt', user.lastActionAt);
        prefs.setString('api_token', token);

        if (response.data['message'] == "تم تغير البيانات بنجاح") {
          return {
            'result': true,
            'message': response.data['message'].toString(),
            'user': user,
          };
        } else {
          return {
            'result': false,
            'message': response.data['message'].toString(),
          };
        }
      }
      if (response.statusCode == 400) {
        return {
          'result': false,
          'message': response.data['message'].toString(),
        };
      }
    } on DioError catch (error) {
      debugPrint(error.toString());
      return {
        'message': error.message,
      };
    }
  }

  ////////////////////////////Edit Account Picture////////////////////////////////
  static Future editAccountPicture({
    required String token,
    required File image,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      var response = await dio.post(
        "${baseUrl}my-profile/change-avatar",
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
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        User user;
        user = User.fromJson(response.data["data"]);
        user.apiToken = token;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("id", user.id);
        prefs.setString('username', user.userName);
        prefs.setString('phone', user.phoneNumber);
        prefs.setString('job_title', user.jobTitle);
        prefs.setString('email', user.email);
        prefs.setString('avatar', user.avatar);
        prefs.setString('bio', user.bio);
        prefs.setString('followers', user.followers);
        prefs.setString('following', user.following);
        prefs.setString('posts', user.posts);
        prefs.setString('stories', user.stories);
        //prefs.setString('cartCount', user.cartCount);
        prefs.setString('notifications', user.notifications);
        prefs.setString('lastActionAt', user.lastActionAt);
        prefs.setString('api_token', token);
        if (response.data['message'] == "تم تغير الصوره الشخصية") {
          return {
            'result': true,
            'message': response.data['message'].toString(),
            'user': user,
          };
        } else {
          return {
            'result': false,
            'message': response.data['message'].toString(),
          };
        }
      }
      if (response.statusCode == 400) {
        return {
          'result': false,
          'message': response.data['message'].toString(),
        };
      }
    } on DioError catch (error) {
      debugPrint(error.toString());
      return {
        'message': error.message,
      };
    }
  }

  ////////////////////////////Edit Account Password////////////////////////////////
  static Future editPassword({
    required String token,
    required String oldPassword,
    required String password,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "old_password": oldPassword,
        "password": password,
        "password_confirmation": password,
      });
      var response = await dio.post(
        "${baseUrl}my-profile/change-password",
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
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        if (response.data['message'] == "تم تغير كلمه المرور") {
          return {
            'result': true,
            'message': response.data['message'].toString(),
          };
        } else {
          return {
            'result': false,
            'message': response.data['message'].toString(),
          };
        }
      }
      if (response.statusCode == 400) {
        return {
          'result': false,
          'message': response.data['message'].toString(),
        };
      }
    } on DioError catch (error) {
      debugPrint(error.toString());
      return {
        'message': error.message,
      };
    }
  }

  ////////////////////////////Delete acocunt////////////////////////////////
  static Future deleteAccount({
    required String token,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();

      var response = await dio.post(
        "${baseUrl}my-profile/delete-account",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            'Devices_Token': deviceToken,
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
        ),
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        return response.data['message'];
      }
      return response.data["message"].toString();
    } on DioError catch (error) {
      debugPrint(error.toString());
      return error.message.toString();
    }
  }

  ////////////////////////////Get Followers///////////////////////////

  static Future<List<OtherUser>> getFollowers({
    required String token,
    required String type,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      debugPrint(token);
      var response = await dio.get(
        "${baseUrl}my-profile/$type",
        options: Options(headers: {
          'Devices_Token': deviceToken,
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        }),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        List<OtherUser> users = [];
        users = (response.data['data'] as List)
            .map((x) => OtherUser.fromJson(x))
            .toList();
        return users;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message.toString());
      return [];
    }
  }
}
