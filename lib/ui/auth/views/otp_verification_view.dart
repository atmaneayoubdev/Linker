import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/auth_controller.dart';
import 'package:linker/controllers/market_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/auth/views/additional_info_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../additional/components/create_store_bottom_sheet.dart';
import '../../common/loading_widget.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView(
      {Key? key, required this.isCreatingStroe, this.phone})
      : super(key: key);
  final bool isCreatingStroe;
  final String? phone;

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
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

  Future checkOtp(String v) async {
    setState(() {
      isLoading = true;
    });
    await AuthController.checkOtp(
      phone: widget.phone!,
      otp: v,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value['message'] == "برجاء قم بإستكمال البيانات") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionalInfoView(
              phone: widget.phone!,
              token: value["token"].toString(),
            ),
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: value['message'] == "برجاء قم بإستكمال البيانات"
              ? kDarkColor
              : Colors.red,
          content: Text(
            value['message'],
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: Colors.white),
          ),
        ),
      );
    });
  }

  Future checkSubOtp(String v) async {
    setState(() {
      isLoading = true;
    });
    await MarketController.checkPhone(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      otp: v,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value == "تم التسجيل بنجاح") {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: ((context) {
              return const CreateStoreBottomSheet();
            })).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.red,
        //     content: Text(
        //       value,
        //       style: Theme.of(context)
        //           .textTheme
        //           .bodySmall!
        //           .apply(color: Colors.white),
        //     ),
        //   ),
        // );
      }
    });
  }

  Future reSendCode() async {
    setState(() {
      isLoading = true;
    });
    await AuthController.sendOtp(widget.phone!).then((value) {
      isLoading = false;
      setState(() {});
      if (value == "تم إرسال رساله علي الجوال الخاص بك") {
        isLoading = false;
        canResend = false;
        final int endT = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

        controller = CountdownTimerController(
          endTime: endT,
          onEnd: onEnd,
        );
        setState(() {});
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: value == "تم إرسال رساله علي الجوال الخاص بك"
              ? kDarkColor
              : Colors.red,
          content: Text(
            value.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: Colors.white),
          )));
    });
  }

  Future reSendSubOtp() async {
    setState(() {
      isLoading = true;
    });
    await MarketController.resendCode(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      isLoading = false;
      setState(() {});
      if (value == "تم إرسال رساله علي الجوال الخاص بك") {
        isLoading = false;
        canResend = false;
        final int endT = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

        controller = CountdownTimerController(
          endTime: endT,
          onEnd: onEnd,
        );
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: value == "تم إرسال رساله علي الجوال الخاص بك"
                ? kDarkColor
                : Colors.red,
            content: Text(
              value.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(color: Colors.white),
            )));
      }
    });
  }

  @override
  void dispose() {
    log(widget.phone!);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  100.verticalSpace,
                  SvgPicture.asset(
                    "assets/icons/otp_image.svg",
                    height: 181.h,
                  ),
                  SizedBox(height: 25.h),
                  SizedBox(
                    width: 275.w,
                    child: Center(
                      child: Text(
                        !widget.isCreatingStroe
                            ? "تم ارسال رمز التحقق مكون من 4 ارقام علي رقم هاتفك ${widget.phone!}"
                            : "تم ارسال رمز التحقق مكون من 4 ارقام علي رقم هاتفك",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(height: 2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  60.verticalSpace,
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
                          inactiveFillColor: const Color.fromARGB(5, 0, 0, 0),
                          selectedFillColor: const Color.fromARGB(5, 0, 0, 0),
                          inactiveColor: Colors.grey.shade400,
                          activeColor: Colors.grey.shade400,
                          selectedColor: kTextColor,
                        ),
                        enabled: true,
                        animationDuration: const Duration(milliseconds: 300),
                        onCompleted: (v) async {
                          widget.isCreatingStroe ? checkSubOtp(v) : checkOtp(v);
                        },
                        onChanged: (value) {},
                        appContext: context,
                      ),
                    ),
                  ),
                  SizedBox(height: 37.h),
                  isLoading
                      ? LoadingWidget(color: kDarkColor, size: 40.h)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (() async {
                                widget.isCreatingStroe
                                    ? reSendSubOtp()
                                    : reSendCode();
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
        ],
      ),
    );
  }
}
