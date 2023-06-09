import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/common/back_button_widget.dart';

class SuccessfullSubView extends StatefulWidget {
  const SuccessfullSubView({super.key});

  @override
  State<SuccessfullSubView> createState() => _SuccessfullSubViewState();
}

class _SuccessfullSubViewState extends State<SuccessfullSubView> {
  TextEditingController storeNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController registerNumberController = TextEditingController();
  TextEditingController registerDateController = TextEditingController();
  TextEditingController sellerNameControlelr = TextEditingController();
  bool isSeller = true;
  bool agreeOnTerms = false;

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
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 77.h,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(38.r),
                            topRight: Radius.circular(38.r)),
                        color: klighSkyBleu,
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BackButtonWidget(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 13.w,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/subscribed.png',
                              height: 225.h,
                              width: 225.w,
                            ),
                            0.verticalSpace,
                            Text('تم التسجيل بنجاج',
                                style: Theme.of(context).textTheme.titleMedium),
                            30.verticalSpace,
                            Text(
                              'سيتم ارسال رابط المنصة عبر بريدك الالكتروني',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(color: kGreyColor),
                            )
                          ],
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
    );
  }
}
