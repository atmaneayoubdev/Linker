class SocialModel {
  String facebook;
  String twitter;
  String instagram;

  SocialModel({
    required this.facebook,
    required this.twitter,
    required this.instagram,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) => SocialModel(
        facebook: json["facebook"].toString(),
        twitter: json["twitter"].toString(),
        instagram: json["instagram"].toString(),
      );
}
