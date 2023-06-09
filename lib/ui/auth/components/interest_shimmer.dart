import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class InterestShimmer extends StatelessWidget {
  const InterestShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) {
        return 10.verticalSpace;
      },
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: kLightGreyColor,
          highlightColor: Colors.white,
          child: Container(
            height: 40.h,
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
