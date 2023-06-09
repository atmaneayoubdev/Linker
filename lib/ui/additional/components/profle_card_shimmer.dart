import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class ProfileCardShimmer extends StatelessWidget {
  const ProfileCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 15.w,
      ),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: kLightGreyColor,
            highlightColor: Colors.white,
            child: Container(
              color: Colors.white,
              height: 25.h,
              width: 200.w,
            ),
          ),
          10.verticalSpace,
          Shimmer.fromColors(
            baseColor: kLightGreyColor,
            highlightColor: Colors.white,
            child: Container(
              height: 103.h,
              width: 103.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          5.verticalSpace,
          Shimmer.fromColors(
            baseColor: kLightGreyColor,
            highlightColor: Colors.white,
            child: Container(
              color: Colors.white,
              height: 18.h,
              width: 130.w,
            ),
          ),
          5.verticalSpace,
          Shimmer.fromColors(
            baseColor: kLightGreyColor,
            highlightColor: Colors.white,
            child: Container(
              color: Colors.white,
              height: 18.h,
              width: 130.w,
            ),
          ),
          15.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: kLightGreyColor,
                highlightColor: Colors.white,
                child: Container(
                  height: 64.h,
                  width: 114.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: kLightGreyColor,
                highlightColor: Colors.white,
                child: Container(
                  height: 64.h,
                  width: 114.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: kLightGreyColor,
                highlightColor: Colors.white,
                child: Container(
                  height: 64.h,
                  width: 114.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
