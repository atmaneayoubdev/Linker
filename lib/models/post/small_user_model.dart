class SmallUserModel {
  String id;
  String username;
  String job;
  String avatar;

  SmallUserModel({
    required this.id,
    required this.username,
    required this.avatar,
    required this.job,
  });

  factory SmallUserModel.fromJson(Map<String, dynamic> json) => SmallUserModel(
        id: json["id"].toString(),
        username: json["username"].toString(),
        avatar: json["avatar"].toString(),
        job: json["job_title"].toString(),
      );
}
