import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class CreateStoreBottomSheet extends StatelessWidget {
  const CreateStoreBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800.h,
      width: 400.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(38.r),
          topRight: Radius.circular(38.r),
        ),
      ),
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
            style:
                Theme.of(context).textTheme.bodyLarge!.apply(color: kGreyColor),
          )
        ],
      ),
    );
  }
}
