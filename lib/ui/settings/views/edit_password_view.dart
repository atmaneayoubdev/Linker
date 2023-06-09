import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';

import 'package:linker/ui/common/back_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../../common/large_button.dart';
import '../../common/loading_widget.dart';

class EditPasswordView extends StatefulWidget {
  const EditPasswordView({super.key});

  @override
  State<EditPasswordView> createState() => _EditPasswordViewState();
}

class _EditPasswordViewState extends State<EditPasswordView> {
  TextEditingController currentPassContoller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isCurrentPassVisible = false;
  bool isPasswordVisible = false;
  bool isConfirmPassVisible = false;

  Future editPassword() async {
    setState(() {
      isLoading = true;
    });
    await MyProfileController.editPassword(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      oldPassword: currentPassContoller.text,
      password: passwordController.text,
    ).then((value) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: value["result"] == true ? kDarkColor : Colors.red,
          content: Text(
            value["message"],
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(248, 248, 248, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38.r),
                    topRight: Radius.circular(38.r),
                  ),
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  //padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38.r),
                      topRight: Radius.circular(38.r),
                    ),
                    color: const Color.fromRGBO(250, 250, 250, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 77,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 23.h),
                        decoration: BoxDecoration(
                          color: klighSkyBleu,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(38.r),
                              topRight: Radius.circular(38.r)),
                        ),
                        child: Stack(children: [
                          Center(
                            child: Text(
                              'تعديل كلمة المرور',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: BackButtonWidget(),
                          )
                        ]),
                      ),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: const Color.fromRGBO(250, 250, 250, 1),
                          padding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 13.w,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  controller: currentPassContoller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور الحالية';
                                    }
                                    if (value.length < 8) {
                                      return 'كلمة المرور قصيرة';
                                    }

                                    return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: !isCurrentPassVisible,
                                  decoration: formFieldDecoration!.copyWith(
                                    suffixIcon: SizedBox(
                                      height: 10.h,
                                      width: 15.w,
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isCurrentPassVisible =
                                                  !isCurrentPassVisible;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            isCurrentPassVisible
                                                ? 'assets/icons/visible.svg'
                                                : 'assets/icons/invisible.svg',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    label: Text(
                                      'كلمه المرور الحالية',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                                20.verticalSpace,
                                TextFormField(
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    if (value.length < 8) {
                                      return 'كلمة المرور قصيرة';
                                    }
                                    if (value !=
                                        confirmPasswordController.text) {
                                      return 'كلمتا المرور غير متطابقتان';
                                    }

                                    return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: !isPasswordVisible,
                                  decoration: formFieldDecoration!.copyWith(
                                    suffixIcon: SizedBox(
                                      height: 10.h,
                                      width: 15.w,
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isPasswordVisible =
                                                  !isPasswordVisible;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            isPasswordVisible
                                                ? 'assets/icons/visible.svg'
                                                : 'assets/icons/invisible.svg',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    label: Text(
                                      'كلمة المرور الجديدة',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                                20.verticalSpace,
                                TextFormField(
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  controller: confirmPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    if (value.length < 8) {
                                      return 'كلمة المرور قصيرة';
                                    }
                                    if (value !=
                                        confirmPasswordController.text) {
                                      return 'كلمتا المرور غير متطابقتان';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: !isConfirmPassVisible,
                                  decoration: formFieldDecoration!.copyWith(
                                    suffixIcon: SizedBox(
                                      height: 10.h,
                                      width: 15.w,
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isConfirmPassVisible =
                                                  !isConfirmPassVisible;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            isConfirmPassVisible
                                                ? 'assets/icons/visible.svg'
                                                : 'assets/icons/invisible.svg',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    label: Text(
                                      'كلمة المرور الجديدة',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      editPassword();
                                    }
                                  },
                                  child: isLoading
                                      ? LoadingWidget(
                                          color: kDarkColor, size: 40.h)
                                      : const LargeButton(
                                          text: 'حفظ', isButton: false),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
