import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/auth/views/forget_otp_view.dart';

import '../../../controllers/auth_controller.dart';
import '../../common/large_button.dart';
import '../../common/loading_widget.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  TextEditingController phoneController = TextEditingController();
  String finalPhone = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.verticalSpace,
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
                      10.verticalSpace,
                      Image.asset('assets/images/forget_image.png'),
                      33.verticalSpace,
                      Center(
                        child: Text(
                          'هل نسيت كلمه المرور ؟',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      10.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Center(
                          child: Text(
                            "من فضلك قم بادخال البريد الالكتروني لاعاده تعيين كلمه مرور جديده",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall!,
                          ),
                        ),
                      ),
                      40.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                                  decoration: formFieldDecoration!,
                                  initialCountryCode: 'SA',
                                  style: Theme.of(context).textTheme.titleSmall,
                                  dropdownTextStyle:
                                      Theme.of(context).textTheme.titleSmall,
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
                                  if (_formKey.currentState!.validate() &&
                                      finalPhone.isNotEmpty) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    isLoading = true;
                                    setState(() {});
                                    await AuthController.forgetPassword(
                                            finalPhone)
                                        .then((value) {
                                      isLoading = false;
                                      setState(() {});
                                      if (value ==
                                          "تم إرسال رساله علي الجوال الخاص بك") {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgetOtpView(
                                                    phone: finalPhone,
                                                  )),
                                        );
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                            color: kDarkColor, size: 40.h),
                                      )
                                    : const LargeButton(
                                        text: 'دخول',
                                        isButton: false,
                                      ),
                              ),
                            ],
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
    );
  }
}
