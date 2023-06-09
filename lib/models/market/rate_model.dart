import 'package:linker/models/market/sub_rate_model.dart';

class RateModel {
  String totalRate;
  int count;
  List<String> avatars;
  List<SubRateModel> rates;

  RateModel({
    required this.avatars,
    required this.count,
    required this.totalRate,
    required this.rates,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
        avatars: (json['avatars'] as List<dynamic>).cast<String>(),
        count: json["count"],
        totalRate: json["total_rate"].toString(),
        rates: (json['data'] as List)
            .map((x) => SubRateModel.fromJson(x))
            .toList(),
      );
}
