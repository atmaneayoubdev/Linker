import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsItemWidget extends StatelessWidget {
  const SettingsItemWidget({
    Key? key,
    required this.svg,
    required this.title,
    required this.isMenue,
  }) : super(key: key);
  final String svg;
  final String title;
  final bool isMenue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 19.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: isMenue ? 30.h : 35.h,
                width: 35.w,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(95, 166, 208, 0.05),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    svg,
                    height: isMenue ? 20.h : 26.h,
                  ),
                ),
              ),
              17.horizontalSpace,
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (!isMenue)
            SizedBox(
              height: 30.h,
              width: 30.w,
              child: SvgPicture.asset(
                'assets/icons/circle_chevron.svg',
              ),
            ),
        ],
      ),
    );
  }
}
