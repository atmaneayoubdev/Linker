import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/auth/views/forget_password_recovery_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../controllers/auth_controller.dart';
import '../../common/loading_widget.dart';

class ForgetOtpView extends StatefulWidget {
  const ForgetOtpView({super.key, required this.phone});
  final String phone;

  @override
  State<ForgetOtpView> createState() => _ForgetOtpViewState();
}

class _ForgetOtpViewState extends State<ForgetOtpView> {
  CountdownTimerController controller = CountdownTimerController(endTime: 0);
  bool canResend = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  void onEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          canResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    log(widget.phone);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Center(
                          child: Text(
                            "تم ارسال رمز التحقق مكون من 4 ارقام علي رقم هاتفك ${widget.phone}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(height: 2),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      40.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.w),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: PinCodeTextField(
                            length: 4,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            showCursor: false,
                            cursorColor: kTextColor,
                            textStyle: Theme.of(context).textTheme.titleLarge,
                            enableActiveFill: true,
                            enablePinAutofill: true,
                            pinTheme: PinTheme(
                              borderWidth: 1,
                              shape: PinCodeFieldShape.box,
                              fieldHeight: 100.h,
                              fieldWidth: 75.w,
                              borderRadius: BorderRadius.circular(9.r),
                              errorBorderColor: Colors.red,
                              activeFillColor: const Color.fromARGB(5, 0, 0, 0),
                              inactiveFillColor:
                                  const Color.fromARGB(5, 0, 0, 0),
                              selectedFillColor:
                                  const Color.fromARGB(5, 0, 0, 0),
                              inactiveColor: Colors.grey.shade400,
                              activeColor: Colors.grey.shade400,
                              selectedColor: kTextColor,
                            ),
                            enabled: true,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            onCompleted: (v) async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ForgetPasswordRecoveryView(
                                    phone: widget.phone,
                                    code: v,
                                  ),
                                ),
                              );
                            },
                            onChanged: (value) {},
                            appContext: context,
                          ),
                        ),
                      ),
                      SizedBox(height: 37.h),
                      isLoading
                          ? Center(
                              child:
                                  LoadingWidget(color: kDarkColor, size: 40.h),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (() async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await AuthController.reSendOtp(widget.phone)
                                        .then((value) {
                                      isLoading = false;

                                      setState(() {});
                                      if (value ==
                                          "تم إرسال رساله علي الجوال الخاص بك") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: kDarkColor,
                                                content: Text(
                                                  value.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .apply(
                                                          color: Colors.white),
                                                )));

                                        canResend = false;
                                        final int endT = DateTime.now()
                                                .millisecondsSinceEpoch +
                                            1000 * 30;

                                        controller = CountdownTimerController(
                                          endTime: endT,
                                          onEnd: onEnd,
                                        );
                                        setState(() {});
                                      } else {
                                        canResend = false;
                                        final int endT = DateTime.now()
                                                .millisecondsSinceEpoch +
                                            1000 * 30;

                                        controller = CountdownTimerController(
                                          endTime: endT,
                                          onEnd: onEnd,
                                        );
                                        setState(() {});

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  value.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .apply(
                                                          color: Colors.white),
                                                )));
                                      }
                                    });
                                  }),
                                  child: Text(
                                    "إعادة ارسال الكود",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(
                                          color: canResend
                                              ? kBleuColor
                                              : Colors.grey.shade400,
                                        ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                CountdownTimer(
                                  controller: controller,
                                  onEnd: onEnd,
                                  endTime: endTime,
                                  endWidget: Text(
                                    "00",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .apply(color: kBleuColor),
                                  ),
                                  widgetBuilder: (context, time) {
                                    return Text(
                                      time == null ? "00:00" : "00:${time.sec}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .apply(color: kBleuColor),
                                    );
                                  },
                                ),
                              ],
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
