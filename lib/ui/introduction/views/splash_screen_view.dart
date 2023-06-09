import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/global_contoller.dart';
import 'package:linker/helpers/intros_provider.dart';
import 'package:linker/models/general/intro_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../models/auth/user_model.dart';
import '../../landing_view.dart';
import 'intoduction_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user;
  Future checkUser() async {
    await SharedPreferences.getInstance().then((value) {
      if (value.getString("api_token") != null) {
        user = User(
          id: value.getString("id") ?? "",
          userName: value.getString("username") ?? "",
          jobTitle: value.getString("job_title") ?? "",
          phoneNumber: value.getString("phone") ?? "",
          apiToken: value.getString("api_token") ?? "",
          avatar: value.getString("avatar") ?? "",
          email: value.getString("email") ?? "",
          bio: value.getString("bio") ?? "",
          //cartCount: value.getString("cartCount") ?? "",
          followers: value.getString("followers") ?? "",
          following: value.getString("following") ?? "",
          lastActionAt: value.getString("lastActionAt") ?? "",
          notifications: value.getString("notifications") ?? "",
          posts: value.getString("posts") ?? "",
          stories: value.getString("stories") ?? "",

          // interestsList: [],
          // specialtiesList: [],
        );
        setState(() {});
      }
    });
  }

  Future getIntros() async {
    await GlobalController.getIntros().then((value) {
      if (value.runtimeType == List<IntroModel>) {
        Provider.of<IntroProvider>(context, listen: false).setInros(value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<MessagingProvider>(context, listen: false).getToken();
    getIntros().then((value) {
      checkUser().then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => user == null
                  ? const IntrodictionView()
                  : const LandingView(isLogging: true),
            ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/splash_background.png',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: SizedBox(
              width: 250.w,
              height: 250.h,
              child: Image.asset("assets/images/app_logo.png"),
            ),
          ),
        ],
      ),
    );
  }
}
