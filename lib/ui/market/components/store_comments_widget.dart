import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/market/sub_rate_model.dart';

import '../../../helpers/constants.dart';

class StoreCommentWidget extends StatelessWidget {
  const StoreCommentWidget({
    Key? key,
    required this.rate,
  }) : super(key: key);
  final SubRateModel rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 83.h,
      width: 370.w,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 0.3,
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            height: 65.h,
            width: 65.w,
            decoration: const BoxDecoration(
                color: kLightGreyColor, shape: BoxShape.circle
                //color: const Color.fromRGBO(240, 240, 240, 1),
                //borderRadius: BorderRadius.circular(9.r),
                ),
            child: ClipOval(
              // borderRadius: BorderRadius.circular(9.r),
              child: CachedNetworkImage(
                imageUrl: rate.user.avatar,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(),
                ),
                errorWidget: (context, url, error) => const SizedBox(),
              ),
            ),
          ),
          7.horizontalSpace,
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rate.user.username,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: kLightOrangeColor,
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                    child: Row(children: [
                      Text(
                        double.parse(rate.rate).toStringAsFixed(1),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: kOrangeColor),
                      ),
                      5.horizontalSpace,
                      FittedBox(
                        child: Icon(
                          Icons.star,
                          color: kOrangeColor,
                          size: 20.h,
                        ),
                      )
                    ]),
                  ),
                ],
              ),
              if (rate.feedback != "null")
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16.h,
                      width: 1.w,
                      color: kLightBlackColor,
                    ),
                    5.horizontalSpace,
                    SizedBox(
                      height: 33.h,
                      width: 200.w,
                      child: Text(
                        rate.feedback,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: kLightBlackColor)
                            .copyWith(fontSize: 12.sp),
                      ),
                    )
                  ],
                ),
            ],
          )),
        ],
      ),
    );
  }
}
