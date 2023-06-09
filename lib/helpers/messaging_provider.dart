import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessagingProvider with ChangeNotifier {
  String deviceToken = "";

  Future getToken() async {
    deviceToken = await FirebaseMessaging.instance.getToken() ?? 'nothing';
    debugPrint(deviceToken);
    notifyListeners();
  }

  void deleteToken() {
    deviceToken = "Nothing";
    debugPrint(deviceToken);

    notifyListeners();
  }
}
