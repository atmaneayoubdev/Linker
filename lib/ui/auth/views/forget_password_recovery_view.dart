import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/controllers/auth_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/auth/views/signin_view.dart';
import 'package:linker/ui/common/large_button.dart';

import '../../common/loading_widget.dart';

class ForgetPasswordRecoveryView extends StatefulWidget {
  const ForgetPasswordRecoveryView(
      {super.key, required this.phone, required this.code});
  final String phone;
  final String code;

  @override
  State<ForgetPasswordRecoveryView> createState() =>
      _ForgetPasswordRecoveryViewState();
}

class _ForgetPasswordRecoveryViewState
    extends State<ForgetPasswordRecoveryView> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          76.verticalSpace,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      25.verticalSpace,
                      SizedBox(
                        height: 45.h,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(
                                    'assets/icons/forward_button.svg'),
                              ),
                            ),
                            Center(
                              child: Text(
                                'استعادة كلمة المرور',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      60.verticalSpace,
                      TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال كلمة المرور';
                          }
                          if (value != confirmPasswordController.text) {
                            return 'كلمتا المرور غير متطابقتان';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !isPasswordVisible,
                        decoration: formFieldDecoration!.copyWith(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          suffixIcon: SizedBox(
                            height: 10.h,
                            width: 15.w,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
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
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء تأكيد كلمة المرور';
                          }
                          if (value != passwordController.text) {
                            return 'كلمتا المرور غير متطابقتان';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !isConfirmPassVisible,
                        decoration: formFieldDecoration!.copyWith(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
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
                            'تاكيد كلمة المرور الجديدة',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      100.verticalSpace,
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            await AuthController.newPassword(widget.phone,
                                    widget.code, passwordController.text)
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              if (value == "تم تغير كلمة المرور بنجاح") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: kDarkColor,
                                        content: Text(
                                          value.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .apply(color: Colors.white),
                                        )));
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInView()),
                                    (route) => false);
                              } else if (value == "كود التحقق غير صحيح") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          value.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .apply(color: Colors.white),
                                        )));
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          value.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .apply(color: Colors.white),
                                        )));
                              }
                            });
                          }
                        },
                        child: isLoading
                            ? Center(
                                child: LoadingWidget(
                                    color: kDarkColor, size: 40.h),
                              )
                            : const LargeButton(
                                text: 'استمرار', isButton: false),
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
