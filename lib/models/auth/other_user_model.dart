class OtherUser {
  String id;
  String username;
  String jobTitle;
  String phoneNumber;
  String avatar;
  String email;
  String bio;
  String following;
  String followers;
  String lastActionAt;
  String followHim;
  String chatId;

  // List<int> specialtiesList;
  // List<int> interestsList;

  OtherUser({
    required this.id,
    required this.username,
    required this.jobTitle,
    required this.phoneNumber,
    required this.avatar,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.lastActionAt,
    required this.followHim,
    required this.chatId,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
        id: json["id"].toString(),
        username: json["username"].toString(),
        jobTitle: json["job_title"].toString(),
        phoneNumber: json["phone"].toString(),
        avatar: json["avatar"].toString(),
        email: json["email"].toString(),
        bio: json["bio"].toString(),
        followers: json["followers"].toString(),
        following: json["following"].toString(),
        lastActionAt: json["last_action_at"].toString(),
        followHim: json["follow_him"].toString(),
        chatId: json["chat_id"].toString(),
      );
}
