import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/auth/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {
////////////////////////////Send OTP////////////////////////////////
  static Future<String> sendOtp(
    String phone,
  ) async {
    try {
      Dio dio = Dio();
      debugPrint(phone);
      var response = await dio.post(
        "${baseUrl}otp",
        options: Options(
            headers: {'Accept': 'application/json'},
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
        data: {
          'phone': phone,
        },
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        if (response.data['message'].toString() ==
            "تم إرسال رساله علي الجوال الخاص بك") {
          return response.data['message'].toString();
        }
      }
      if (response.statusCode == 400) {
        return response.data['errors'].first['value'].toString();
      }
      return 'حدث خطأ حاول مرة أخرى';
    } on DioError catch (error) {
      debugPrint(error.toString());
      return "error";
    }
  }

  ////////////////////////////Send OTP////////////////////////////////
  static Future<String> reSendOtp(
    String phone,
  ) async {
    try {
      Dio dio = Dio();
      debugPrint(phone);
      var response = await dio.post(
        "${baseUrl}re-send",
        options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {'Accept': 'application/json'}),
        data: {
          'phone': phone,
        },
      );
      debugPrint(response.data.toString());

      return response.data['message'].toString();
    } on DioError catch (error) {
      debugPrint(error.toString());
      return "error";
    }
  }

  ////////////////////////////Check OTP////////////////////////////////
  static Future checkOtp({
    required String phone,
    required String otp,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}check-otp",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {'Devices_Token': deviceToken, 'Accept': 'application/json'},
        ),
        data: {
          'phone': phone,
          'otp': int.parse(otp),
        },
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        return {
          'token': response.data["api_token"].toString(),
          'message': response.data['message'].toString(),
        };
      }
      if (response.statusCode == 400) {
        return {
          'message': response.data['message'].toString(),
        };
      }
    } on DioError catch (error) {
      debugPrint(error.toString());
      return {
        'message': 'error',
      };
    }
  }

  ////////////////////////////Reginster////////////////////////////////
  static Future register({
    required String usernme,
    required String jobTitle,
    required String email,
    required String password,
    required String deviceToken,
    required List<int> specialies,
    required List<int> interests,
    required String token,
    required String phone,
  }) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "username": usernme,
        "job_title": jobTitle,
        "email": email,
        "password": password,
        "specialties[]": specialies,
        "interests[]": interests,
      });
      var response = await dio.post(
        "${baseUrl}completed-data",
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
      User user = User(
        id: "",
        userName: usernme,
        jobTitle: jobTitle,
        phoneNumber: phone,
        apiToken: token,
        avatar: '',
        email: email,
        bio: '',
        // cartCount: '',
        followers: '',
        following: '',
        lastActionAt: '',
        notifications: '',
        posts: '',
        stories: '',
        // interestsList: interests,
        // specialtiesList: specialies,
      );
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      prefs.setString('username', user.userName);
      prefs.setString('phone', user.phoneNumber);
      prefs.setString('api_token', token);
      prefs.setString('job_title', user.jobTitle);
      prefs.setString('email', user.email);
      prefs.setString('avatar', user.avatar);
      if (response.statusCode == 200) {
        if (response.data['message'].toString() ==
            "أهلا وسهلا بك , شكرا علي الإنضمام لدينا") {
          return {
            'message': response.data['message'].toString(),
            'user': user,
          };
        }
      } else if (response.statusCode == 400) {
        if (response.data['message'].toString() == "بيانات مفقوده") {
          return {
            'message': response.data['errors'].first["value"].toString(),
          };
        } else {
          return {
            'message': response.data["message"],
          };
        }
      } else {
        return {
          'message': response.data["message"],
        };
      }
    } on DioError catch (error) {
      debugPrint(error.toString());
      return {
        'message': error.message,
      };
    }
  }

  ////////////////////////////LogOut///////////////////////////
  static Future logout({
    required String token,
    required String deviceToken,
  }) async {
    Map<String, String> headers = {
      'Devices_Token': deviceToken,
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}my-profile/logout",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        return response.data['message'];
      }
    } on DioError catch (error) {
      debugPrint(error.response!.statusCode.toString());
      debugPrint(error.message!);
      return error.message.toString();
    }
  }

  ////////////////////////////login///////////////////////////
  static Future login({
    required String phoneNumber,
    required String password,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}login",
        options: Options(headers: {
          'Devices_Token': deviceToken,
          'Accept': 'application/json',
        }),
        data: {
          'object': phoneNumber,
          'password': password,
        },
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        if (response.data['message'].toString() == "معلومات المستخدم") {
          User user;
          user = User.fromJson(response.data["data"]);
          final prefs = await SharedPreferences.getInstance();
          user.apiToken = response.data['api_token'];
          prefs.setString('username', user.userName);
          prefs.setString('phone', user.phoneNumber);
          prefs.setString('api_token', user.apiToken);
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

          return user;
        }
      }
      if (response.statusCode == 400) {
        return response.data['message'];
      }
    } on DioError catch (error) {
      debugPrint(error.message.toString());
      debugPrint(error.message.toString());
      if (error.response!.statusCode == 400) {
        return error.response!.data['message'];
      }
      return "error";
    }
  }

  //////////////////////////// Forgot Password ////////////////////////////////
  static Future<String> forgetPassword(
    String phone,
  ) async {
    try {
      Dio dio = Dio();
      debugPrint(phone);
      var response = await dio.post(
        "${baseUrl}forget-password",
        options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {'Accept': 'application/json'}),
        data: {
          'phone': phone,
        },
      );
      debugPrint(response.data.toString());

      return response.data['message'].toString();
    } on DioError catch (error) {
      debugPrint(error.toString());
      return error.message.toString();
    }
  }

  //////////////////////////// New Password ////////////////////////////////
  static Future<String> newPassword(
    String phone,
    String otp,
    String password,
  ) async {
    try {
      Dio dio = Dio();
      debugPrint(phone);
      var response = await dio.post(
        "${baseUrl}new-password",
        options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {'Accept': 'application/json'}),
        data: {
          'phone': phone,
          "otp": int.parse(otp),
          "password": password,
        },
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        return response.data['message'].toString();
      }
      if (response.statusCode == 400) {
        return response.data['errors'].first["value"].toString();
      }
      return response.data['message'].toString();
    } on DioError catch (error) {
      debugPrint(error.toString());
      return "error";
    }
  }
}
