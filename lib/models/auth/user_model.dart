class User {
  String id;
  String userName;
  String jobTitle;
  String phoneNumber;
  String apiToken;
  String avatar;
  String email;
  String bio;
  String posts;
  String stories;
  String following;
  String followers;
  String notifications;
  //String cartCount;
  String lastActionAt;
  // List<int> specialtiesList;
  // List<int> interestsList;

  User({
    required this.id,
    required this.userName,
    required this.jobTitle,
    required this.phoneNumber,
    required this.apiToken,
    required this.avatar,
    required this.email,
    required this.bio,
    //required this.cartCount,
    required this.followers,
    required this.following,
    required this.lastActionAt,
    required this.notifications,
    required this.posts,
    required this.stories,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"].toString(),
        userName: json["username"].toString(),
        jobTitle: json["job_title"].toString(),
        phoneNumber: json["phone"].toString(),
        apiToken: json["api_token"].toString(),
        avatar: json["avatar"].toString(),
        email: json["email"].toString(),
        bio: json["bio"].toString(),
        //cartCount: json["cart_count"].toString(),
        followers: json["followers"].toString(),
        following: json["following"].toString(),
        lastActionAt: json["last_action_at"].toString(),
        notifications: json["notifications"].toString(),
        posts: json["posts"].toString(),
        stories: json["stories"].toString(),
      );
  Map<String, dynamic> toJson() {
    return {
      "username": userName,
      "job_title": jobTitle,
      "phone": phoneNumber,
      "api_token": apiToken,
      "email": email,
      'avatar': avatar,
    };
  }
}
