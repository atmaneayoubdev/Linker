import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      itemCount: 10,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (BuildContext context, int index) {
        return 10.horizontalSpace;
      },
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: kLightGreyColor,
          highlightColor: Colors.white,
          child: Container(
            height: 50.h,
            width: 120.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      },
    );
  }
}
