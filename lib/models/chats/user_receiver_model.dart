class UserReceiverModel {
  String id;
  String name;
  String avatar;
  String createdAt;

  UserReceiverModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  factory UserReceiverModel.fromJson(Map<String, dynamic> json) =>
      UserReceiverModel(
        id: json["id"].toString(),
        name: json["username"].toString() != "null"
            ? json["username"].toString()
            : json["name"].toString(),
        avatar: json["avatar"].toString(),
        createdAt: json["last_action_at"].toString(),
      );
}
