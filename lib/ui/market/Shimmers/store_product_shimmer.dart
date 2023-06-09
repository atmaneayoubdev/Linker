import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class StoreProductListShimmer extends StatelessWidget {
  final bool isFav;
  final bool isVert;

  const StoreProductListShimmer(
      {super.key, required this.isFav, required this.isVert});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: isVert ? Axis.vertical : Axis.horizontal,
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) {
        return isVert ? 11.verticalSpace : 11.horizontalSpace;
      },
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: Shimmer.fromColors(
            baseColor: kLightGreyColor,
            highlightColor: Colors.white,
            child: Container(
              height: 254.h,
              width: isFav ? double.infinity : 327.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        );
      },
    );
  }
}
