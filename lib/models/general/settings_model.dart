import 'package:linker/models/general/social_model.dart';

class SettingsModel {
  String phone;
  String email;
  SocialModel social;

  SettingsModel({
    required this.phone,
    required this.email,
    required this.social,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        phone: json["phone"].toString(),
        email: json["email"].toString(),
        social: SocialModel.fromJson(json["social"]),
      );
}
