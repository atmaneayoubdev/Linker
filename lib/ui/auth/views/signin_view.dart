import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/controllers/auth_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/auth/user_model.dart';
import 'package:linker/ui/auth/views/forget_password_view.dart';
import 'package:linker/ui/auth/views/signup_view.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/messaging_provider.dart';
import '../../common/loading_widget.dart';
import '../../landing_view.dart';
import 'additional_info_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<MessagingProvider>(context, listen: false).getToken();
    Future.delayed(Duration.zero, () {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });
  }

  Future deleteUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kDarkColor,
      body: Stack(
        children: [
          SizedBox(
            height: 360.h,
            child: Center(
              child: Image.asset(
                "assets/images/appforground.png",
                height: 100.h,
              ),
            ),
          ),
          Column(
            children: [
              360.verticalSpace,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            70.verticalSpace,
                            TextFormField(
                              style: Theme.of(context).textTheme.titleMedium,
                              controller: username,
                              validator: (value) {
                                if (username.text.isEmpty) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال اسم المستخدم أو رقم الهاتف';
                                  }
                                }
                                return null;
                              },
                              decoration: formFieldDecoration!.copyWith(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  label: Text(
                                    'اسم المستخدم أو رقم الهاتف',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )),
                            ),
                            20.verticalSpace,
                            TextFormField(
                              style: Theme.of(context).textTheme.titleMedium,
                              controller: password,
                              onTap: () => password.clear(),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال كلمة المرور';
                                }
                                return null;
                              },
                              decoration: formFieldDecoration!.copyWith(
                                  // icon: const Icon(Icons.mail_outline, color: kLightGreyColor,),),
                                  prefixIcon: SizedBox(
                                    height: 17.h,
                                    width: 15.w,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/lock.svg',
                                      ),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  label: Text(
                                    'كلمة المرور',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )),
                            ),
                            20.verticalSpace,
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPasswordView()));
                                },
                                child: Text(
                                  'نسيت كلمة المرور؟',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(color: kBleuColor),
                                ),
                              ),
                            ),
                            20.verticalSpace,
                            GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    String userNameOrPhone = username.text;
                                    if (RegExp(r'^[0-9]+$')
                                        .hasMatch(username.text)) {
                                      userNameOrPhone =
                                          "966${userNameOrPhone.substring(1)}";
                                    }
                                    await AuthController.login(
                                      deviceToken:
                                          Provider.of<MessagingProvider>(
                                        context,
                                        listen: false,
                                      ).deviceToken,
                                      phoneNumber: userNameOrPhone,
                                      password: password.text,
                                    ).then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (value.runtimeType == User) {
                                        User user = value;
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .setUser(user);

                                        if (user.jobTitle.isEmpty) {
                                          deleteUserFromPrefs();
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .clearUser();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration:
                                                const Duration(seconds: 3),
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              "برجاء إستكمال بيانات الحساب اولا",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .apply(color: Colors.white),
                                            ),
                                          ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AdditionalInfoView(
                                                phone: user.phoneNumber,
                                                token: user.apiToken,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LandingView()),
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration:
                                                const Duration(seconds: 3),
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              value.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .apply(color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                                child: isLoading
                                    ? LoadingWidget(
                                        color: kDarkColor, size: 40.h)
                                    : const LargeButton(
                                        text: 'دخول', isButton: false)),
                            20.verticalSpace,
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const SignUpView()));
                              },
                              child: Container(
                                width: double.maxFinite,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    10.r,
                                  ),
                                  color: kLighLightGreyColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "ليس لديك حساب؟ قم بالتسجيل",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              334.verticalSpace,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 5,
                        spreadRadius: 5,
                        color: klighColor,
                      )
                    ]),
                child: Text(
                  "تسجيل الدخول",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
