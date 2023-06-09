import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/helpers/constants.dart';

class SubscriptionOpitonsItemWidget extends StatelessWidget {
  const SubscriptionOpitonsItemWidget({
    Key? key,
    required this.name,
  }) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/circular_check.svg',
          height: 20.h,
          width: 20.w,
        ),
        7.horizontalSpace,
        Text(
          name,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .apply(color: kLightBlackColor),
        ),
        //20.horizontalSpace,
        // const Spacer(),
        // Container(
        //   height: 19.h,
        //   width: 46.w,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(14.r),
        //     color: klighColor,
        //   ),
        //   child: Center(
        //     child: Text('1', style: Theme.of(context).textTheme.bodyMedium),
        //   ),
        // ),
      ],
    );
  }
}
