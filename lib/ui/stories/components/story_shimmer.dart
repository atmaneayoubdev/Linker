import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class StoryShimmer extends StatelessWidget {
  final bool isHome;

  const StoryShimmer({super.key, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return isHome
        ? SizedBox(
            height: 328.h,
            width: double.infinity,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (BuildContext context, int index) {
                return 6.horizontalSpace;
              },
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: kLightGreyColor,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 328.h,
                    width: 113.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        color: Colors.white),
                  ),
                );
              },
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 9.w,
                mainAxisSpacing: 16.h,
                mainAxisExtent: 247.h,
              ),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: kLightGreyColor,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 328.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
