import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class StorySpecialtyShimmer extends StatelessWidget {
  final bool? isHome;

  const StorySpecialtyShimmer({super.key, this.isHome});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) {
        return 9.horizontalSpace;
      },
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: kLightGreyColor,
          highlightColor: Colors.white,
          child: Container(
            height: 60.h,
            width: 144.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
        );
      },
    );
  }
}
