import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class MessagesItemShimmer extends StatelessWidget {
  const MessagesItemShimmer({
    super.key,
    required this.isNew,
  });
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: isNew ? 10 : 10,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return 10.verticalSpace;
      },
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: kLightGreyColor,
          highlightColor: Colors.white,
          child: Container(
            height: 75.h,
            width: 377.w,
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
