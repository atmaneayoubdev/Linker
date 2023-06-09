import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/models/market/plan_model.dart';

import '../../../helpers/constants.dart';

class SubscriptionItemWidget extends StatelessWidget {
  const SubscriptionItemWidget({
    Key? key,
    required this.plan,
    required this.isSelected,
    required this.onPress,
  }) : super(key: key);
  final PlanModel plan;
  final bool isSelected;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        height: 83.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kDarkColor : Colors.transparent,
            width: 0.5,
          ),
          color: const Color.fromRGBO(
            249,
            250,
            252,
            1,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 64.h,
              width: 70.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: Colors.white,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/gem.svg',
                  height: 27.h,
                ),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: kTextColor)
                            .copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${plan.price} ر.س',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: kGreyColor),
                      ),
                    ],
                  ),
                  Text(
                    "${plan.days} يوم",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .apply(color: Colors.grey.shade700),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
