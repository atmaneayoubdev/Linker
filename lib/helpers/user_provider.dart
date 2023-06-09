import 'package:flutter/material.dart';
import 'package:linker/models/auth/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User user = User(
      id: '',
      userName: '',
      jobTitle: '',
      phoneNumber: '',
      apiToken: '',
      avatar: '',
      email: '',
      bio: '',
      //cartCount: '',
      followers: '',
      following: '',
      lastActionAt: '',
      notifications: '',
      posts: '',
      stories: '');

  void setUserNotifications(String count) {
    user.notifications = count;
    notifyListeners();
  }

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  Future<void> clearUser() async {
    user = User(
        id: '',
        userName: '',
        jobTitle: '',
        phoneNumber: '',
        apiToken: '',
        avatar: '',
        email: '',
        bio: '',
        //cartCount: '',
        followers: '',
        following: '',
        lastActionAt: '',
        notifications: '',
        posts: '',
        stories: '');
    final prefs = await SharedPreferences.getInstance();
    prefs.clear;
    notifyListeners();
  }
}
