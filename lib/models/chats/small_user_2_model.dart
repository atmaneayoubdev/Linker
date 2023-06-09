class SmallUserModel2 {
  String id;
  String name;
  String avatar;

  SmallUserModel2({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory SmallUserModel2.fromJson(Map<String, dynamic> json) =>
      SmallUserModel2(
        id: json["id"].toString(),
        name: json["name"].toString(),
        avatar: json["avatar"].toString(),
      );
}
