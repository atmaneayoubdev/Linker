import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:linker/controllers/auth_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/auth/views/otp_verification_view.dart';
import 'package:linker/ui/auth/views/signin_view.dart';

import '../../common/large_button.dart';
import '../../common/loading_widget.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController phoneController = TextEditingController();
  String finalPhone = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kDarkColor,
        body: Stack(
          children: [
            SizedBox(
              height: 360.h,
              child: Center(
                child: Image.asset(
                  "assets/images/app_logo.png",
                  height: 200.h,
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
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            60.verticalSpace,
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                ' رقم الهاتف',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            15.verticalSpace,
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: IntlPhoneField(
                                controller: phoneController,
                                decoration: formFieldDecoration!.copyWith(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                ),
                                initialCountryCode: 'SA',
                                countries: const ["SA"],
                                style: Theme.of(context).textTheme.titleMedium,
                                dropdownTextStyle:
                                    Theme.of(context).textTheme.titleMedium,
                                keyboardType: TextInputType.phone,
                                showDropdownIcon: true,
                                dropdownIconPosition: IconPosition.leading,
                                disableLengthCheck: true,
                                dropdownIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.transparent,
                                  size: 10,
                                ),
                                onChanged: (value) {
                                  var temp = value.countryCode + value.number;
                                  finalPhone = temp.replaceFirst("+", "");
                                },
                                onCountryChanged: (value) {
                                  finalPhone = '';

                                  phoneController.clear();
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  String pattern = r'[0-9]';
                                  RegExp regExp = RegExp(pattern);

                                  if (value == null ||
                                      value.number.isEmpty ||
                                      !regExp.hasMatch(value.number)) {
                                    return 'الرجاء إدخال رقم الهاتف';
                                  }
                                  if (value.number.length != 9) {
                                    return 'الرجاء إدخال رقم الهاتف';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            20.verticalSpace,
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  isLoading = true;
                                  setState(() {});
                                  await AuthController.sendOtp(finalPhone)
                                      .then((value) {
                                    isLoading = false;
                                    setState(() {});
                                    if (value ==
                                        "تم إرسال رساله علي الجوال الخاص بك") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OtpVerificationView(
                                            isCreatingStroe: false,
                                            phone: finalPhone,
                                          ),
                                        ),
                                      );
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: value ==
                                                "تم إرسال رساله علي الجوال الخاص بك"
                                            ? kDarkColor
                                            : Colors.red,
                                        content: Text(
                                          value.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .apply(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  });
                                }
                              },
                              child: isLoading
                                  ? Center(
                                      child: LoadingWidget(
                                        color: kDarkColor,
                                        size: 40.h,
                                      ),
                                    )
                                  : const LargeButton(
                                      text: 'دخول',
                                      isButton: false,
                                    ),
                            ),
                            60.verticalSpace,
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const SignInView(),
                                  ),
                                  (route) => false,
                                );
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
                                    "لديك حساب بالفعل؟  تسجيل الدخول",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            )
                          ],
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
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
                    "انشاء حساب",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
