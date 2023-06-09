import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/market/rate_model.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

import '../../../helpers/constants.dart';

class StoreCommentsCardWidget extends StatelessWidget {
  const StoreCommentsCardWidget({
    Key? key,
    required this.rate,
  }) : super(key: key);
  final RateModel rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 85.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: kLightOrangeColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'اجمالي التقييمات',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              5.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: SizedBox(
                  height: 23.h,
                  child: SignedSpacingRow(
                    spacing: -8,
                    stackingOrder: StackingOrder.firstOnTop,
                    children: [
                      for (int i = 0; i < rate.count; i++)
                        Container(
                          height: 23.h,
                          width: 23.h,
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: CachedNetworkImage(
                              imageUrl: rate.avatars[i],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              5.verticalSpace,
              Text(
                '${rate.count} مستخدم',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Column(
            children: [
              Container(
                height: 41.h,
                width: 41.w,
                decoration: BoxDecoration(
                  color: kOrangeColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: const Center(
                  child: Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              5.verticalSpace,
              Text(
                double.parse(rate.totalRate).toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
        ],
      ),
    );
  }
}
