import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linker/models/market/category_model.dart';
import 'package:linker/models/market/menu_model.dart';
import 'package:linker/models/market/plan_model.dart';
import 'package:linker/models/market/product_model.dart';
import 'package:linker/models/market/store_model.dart';

import '../helpers/constants.dart';
import '../models/market/rate_model.dart';

class MarketController with ChangeNotifier {
  ////////////////////Get Categories List//////////////////////
  static Future<List<MarketCategoryModel>> getCategories({
    required String token,
    required String storeId,
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
        storeId.isEmpty
            ? "${baseUrl}categories"
            : "${baseUrl}categories?store_id=$storeId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<MarketCategoryModel> categories = [];
        categories = (response.data["data"] as List)
            .map((x) => MarketCategoryModel.fromJson(x))
            .toList();

        return categories;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Get Menues List//////////////////////
  static Future<List<MenuModel>> getMenueList({
    required String token,
    required String storeId,
    required String catId,
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
        "${baseUrl}menus",
        queryParameters: {
          "store_id": storeId,
          "category_id": catId,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        List<MenuModel> menues = [];
        menues = (response.data["data"] as List)
            .map((x) => MenuModel.fromJson(x))
            .toList();

        return menues;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Get Most Rated Products List//////////////////////
  static Future<List<ProductModel>> getBestRatedProducts(
      {required String token,
      String? storeId,
      required String deviceToken}) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        storeId == null
            ? "${baseUrl}store/best-products-rates"
            : "${baseUrl}store/best-products-rates?store_id=$storeId",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<ProductModel> products = [];
        products = (response.data["data"] as List)
            .map((x) => ProductModel.fromJson(x))
            .toList();

        return products;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Get Favorite Products//////////////////////
  static Future<List<ProductModel>> getFavoriteProducts({
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
        "${baseUrl}store/fav?object_type=product",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<ProductModel> products = [];
        products = (response.data["data"] as List)
            .map((x) => ProductModel.fromJson(x))
            .toList();

        return products;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Get New Products List//////////////////////
  static Future<List<ProductModel>> getNewProducts({
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
        "${baseUrl}store/new-products",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<ProductModel> products = [];
        products = (response.data["data"] as List)
            .map((x) => ProductModel.fromJson(x))
            .toList();

        return products;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Get Products And Filter List//////////////////////
  static Future<List<ProductModel>> getProducts({
    required String token,
    required String title,
    required String catId,
    required String menuId,
    required String priceFrom,
    required String priceTo,
    required String type,
    required String rate,
    required String storeId,
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
        "${baseUrl}store/products?"
        "${title.isEmpty ? '' : '&title=$title'}"
        "${catId.isEmpty ? '' : '&category_id=$catId'}"
        "${menuId.isEmpty ? '' : '&menu_id=$menuId'}"
        "${priceFrom.isEmpty ? '' : '&price_from=$priceFrom'}"
        "${priceTo.isEmpty ? '' : '&price_to=$priceTo'}"
        //"${type.isEmpty ? '' : '&type=$type'}"
        "${rate.isEmpty ? '' : '&rate=$rate'}"
        "${storeId.isEmpty ? '' : '&store_id=$storeId'}",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        List<ProductModel> products = [];
        products = (response.data["data"] as List)
            .map((x) => ProductModel.fromJson(x))
            .toList();

        return products;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Get Best rated stores List//////////////////////
  static Future<List<StoreModel>> getBestRatedStores({
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
        "${baseUrl}store/best-stores-rates",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<StoreModel> stores = [];
        stores = (response.data["data"] as List)
            .map((x) => StoreModel.fromJson(x))
            .toList();

        return stores;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Get Best rated stores List//////////////////////
  static Future<List<PlanModel>> getPlans({
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
        "${baseUrl}plans",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<PlanModel> planes = [];
        planes = (response.data["data"] as List)
            .map((x) => PlanModel.fromJson(x))
            .toList();

        return planes;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Get Best rated stores List//////////////////////
  static Future<List<StoreModel>> getFavoriteStores({
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
        "${baseUrl}store/fav?object_type=store",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<StoreModel> stores = [];
        stores = (response.data["data"] as List)
            .map((x) => StoreModel.fromJson(x))
            .toList();

        return stores;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Get Stores Filter//////////////////////
  static Future<List<StoreModel>> getStoresFilter({
    required String token,
    required String catId,
    required String storeName,
    required String rate,
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
        "${baseUrl}store/all?${catId.isEmpty ? '' : '&category_id=$catId'}${storeName.isEmpty ? '' : '&store_name=$storeName'}${rate.isEmpty ? '' : '&rates=$rate'}",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<StoreModel> stores = [];
        stores = (response.data["data"] as List)
            .map((x) => StoreModel.fromJson(x))
            .toList();

        return stores;
      }
      return [];
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Check phone//////////////////////
  static Future checkPhone({
    required String token,
    required String otp,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };

      Dio dio = Dio();

      var response = await dio.post("${baseUrl}store/store-request/check-phone",
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ),
          data: {
            'otp': otp,
          });

      return response.data['message'].toString();
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////Resend Code//////////////////////

  static Future resendCode({
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

      var response = await dio.post(
        "${baseUrl}store/store-request/re-send",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      if (response.statusCode == 200 &&
          response.data['message'].toString() ==
              "تم إرسال رساله علي الجوال الخاص بك") {
        return response.data['otp'].toString();
      } else {
        return response.data['message'].toString();
      }
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////create Post//////////////////////
  static Future createStore({
    required String token,
    required String fullName,
    required String storename,
    required String storeType,
    required String phone,
    required String email,
    required String type,
    required String planId,
    required List<MarketCategoryModel> categories,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      List<int> cats = [];
      for (var cat in categories) {
        cats.add(int.parse(cat.id));
      }
      FormData formData = FormData.fromMap({
        "full_name": fullName,
        "store_name": storename,
        "store_type": storeType,
        "phone": phone,
        "email": email,
        "type": type,
        "plan_id": planId,
        "categories[]": cats,
      });
      var response = await dio.post(
        "${baseUrl}store/store-request",
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

      if (response.statusCode == 200 &&
          response.data['message'].toString() == "تم إرسال طلبك بنجاح") {
        return response.data['data']['otp'].toString();
      } else {
        return response.data['message'].toString();
      }
    } on DioError catch (error) {
      log(error.toString());
      return error.message;
    }
  }

  ////////////////////Add remove favorite//////////////////////

  static Future addRemoveFavorite({
    required String token,
    required bool isProducts,
    required String objectId,
    required String deviceToken,
  }) async {
    try {
      Map<String, String> headers = {
        'Devices_Token': deviceToken,
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "object_type": isProducts ? "product" : "store",
        "object_id": objectId,
      });
      var response = await dio.post(
        "${baseUrl}store/fav",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: formData,
      );

      return response.data['message'].toString();
    } on DioError catch (error) {
      log(error.message!);
      return [];
    }
  }

  ////////////////////////////Get Single Store///////////////////////////
  static Future showStore({
    required String token,
    required String storeId,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "${baseUrl}store/show-store/$storeId",
        options: Options(headers: {
          'Devices_Token': deviceToken,
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        }),
      );
      if (response.statusCode == 200) {
        return StoreModel.fromJson(response.data["data"]);
      }
      if (response.statusCode == 400) {
        return response.data['message'];
      }
    } on DioError catch (error) {
      log(error.message.toString());
      return error.response;
    }
  }

  ////////////////////////////Get Single product///////////////////////////
  static Future showProduct({
    required String token,
    required String productId,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(
        "${baseUrl}store/products/$productId",
        options: Options(headers: {
          'Devices_Token': deviceToken,
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        }),
      );

      if (response.statusCode == 200) {
        ProductModel product = ProductModel.fromJson(response.data["data"]);
        return product;
      }
      if (response.statusCode == 400) {
        return response.data['message'];
      }
    } on DioError catch (error) {
      log(error.message.toString());
      return error.response;
    }
  }

  ////////////////////////////Add Rate///////////////////////////
  static Future addRate({
    required String token,
    required String objectId,
    required String type,
    required String feedback,
    required String rate,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "type": type,
        "object_id": objectId,
        "rate": rate,
        "feedback": feedback,
      });
      var response = await dio.post(
        "${baseUrl}store/rates",
        options: Options(headers: {
          'Devices_Token': deviceToken,
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        }),
        data: formData,
      );

      return response.data['message'];
    } on DioError catch (error) {
      log(error.message.toString());
      return error.response!.data["message"];
    }
  }

  ////////////////////Get Rates//////////////////////
  static Future getProductsRates({
    required String token,
    required String productId,
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
        "${baseUrl}store/products/$productId/rates",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      return RateModel.fromJson(response.data['data']);
    } on DioError catch (error) {
      log(error.message!);
      return error.message;
    }
  }

  ////////////////////Get Rates//////////////////////
  static Future getStoreRates({
    required String token,
    required String storeId,
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
        "${baseUrl}store/show-store/$storeId/rates",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      return RateModel.fromJson(response.data['data']);
    } on DioError catch (error) {
      log(error.message!);
      return error.message;
    }
  }
}
