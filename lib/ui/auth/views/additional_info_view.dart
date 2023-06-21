import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/ui/auth/views/fields_and_interesrets_view.dart';
import 'package:linker/ui/common/large_button.dart';

import '../../../controllers/global_contoller.dart';
import '../../../helpers/constants.dart';
import '../../common/loading_widget.dart';

class AdditionalInfoView extends StatefulWidget {
  const AdditionalInfoView(
      {super.key, required this.phone, required this.token});
  final String phone;
  final String token;

  @override
  State<AdditionalInfoView> createState() => _AdditionalInfoViewState();
}

class _AdditionalInfoViewState extends State<AdditionalInfoView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController emailContoller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hasAgreed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: kDarkColor,
      body: Column(
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
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 36.w),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      20.verticalSpace,
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "من فضلك قم باستكمال بياناتك",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      20.verticalSpace,
                      TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال اسم المستخدم ';
                          }
                          return null;
                        },
                        decoration: formFieldDecoration!.copyWith(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ' اسم المستخدم',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '*  ',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .apply(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: jobController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاءإدخال تخصصك المهني أو نشاطك التجاري';
                          }
                          return null;
                        },
                        decoration: formFieldDecoration!.copyWith(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'تخصصك المهني أو نشاطك التجاري',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '*  ',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .apply(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: emailContoller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال البريد الإلكتروني';
                          }
                          return null;
                        },
                        decoration: formFieldDecoration!.copyWith(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'البريد الالكتروني',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال كلمة المرور';
                          }
                          return null;
                        },
                        decoration: formFieldDecoration!.copyWith(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'كلمه المرور',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '*  ',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .apply(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      35.verticalSpace,
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                hasAgreed = !hasAgreed;
                              });
                            },
                            child: Container(
                              height: 23.h,
                              width: 23.w,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: kBleuColor,
                                    width: 1.h,
                                  ),
                                  borderRadius: BorderRadius.circular(6.r)),
                              child: hasAgreed
                                  ? const FittedBox(
                                      child: Icon(
                                      Icons.check,
                                      color: kBleuColor,
                                    ))
                                  : const SizedBox(),
                            ),
                          ),
                          10.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      contentPadding: const EdgeInsets.all(10),
                                      content: Container(
                                        height: 600.h,
                                        width: 450.w,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(38.r)),
                                        child: FutureBuilder(
                                          future: GlobalController.getPage(
                                              "policy"),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            return snapshot.hasData
                                                ? SingleChildScrollView(
                                                    child: Text(snapshot.data))
                                                : Center(
                                                    child: LoadingWidget(
                                                        color: kDarkColor,
                                                        size: 40.h),
                                                  );
                                          },
                                        ),
                                      ));
                                },
                              );
                            },
                            child: Text(
                              'الموافقة على الشروط والأحكام',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(
                                      decoration: TextDecoration.underline,
                                      color: kTextColor),
                            ),
                          ),
                        ],
                      ),
                      35.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate() && hasAgreed) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => FieldsAndInterestView(
                                      isFromDrawer: false,
                                      email: emailContoller.text,
                                      jobTitle: jobController.text,
                                      passwrod: passwordController.text,
                                      username: usernameController.text,
                                      phone: widget.phone,
                                      token: widget.token,
                                    ))));
                          }
                        },
                        child: const LargeButton(
                          text: 'تسجيل',
                          isButton: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
