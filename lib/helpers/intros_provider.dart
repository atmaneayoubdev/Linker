import 'package:flutter/material.dart';
import 'package:linker/models/general/intro_model.dart';

class IntroProvider with ChangeNotifier {
  List<IntroModel> intros = [];

  Future setInros(List<IntroModel> pages) async {
    intros = pages;
    notifyListeners();
  }
}
