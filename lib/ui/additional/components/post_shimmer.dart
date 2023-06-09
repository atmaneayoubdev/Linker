import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class PostShimmer extends StatelessWidget {
  final bool? isHome;

  const PostShimmer({super.key, this.isHome});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: isHome! ? 15.w : 0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) {
        return 10.verticalSpace;
      },
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: kLightGreyColor,
          highlightColor: Colors.white,
          child: Container(
            height: 200.h,
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
