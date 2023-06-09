import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class UserItemShimmer extends StatelessWidget {
  const UserItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) {
        return 11.verticalSpace;
      },
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: kLightGreyColor,
          highlightColor: Colors.white,
          child: Container(
            height: 80.h,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 25.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: const Color.fromRGBO(219, 219, 219, 1), width: 0.5),
              borderRadius: BorderRadius.circular(9.r),
            ),
          ),
        );
      },
    );
  }
}
