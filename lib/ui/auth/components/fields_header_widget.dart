import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../helpers/constants.dart';

class FieldsHeaderWidget extends StatelessWidget {
  const FieldsHeaderWidget({
    Key? key,
    required this.index,
    required this.page,
  }) : super(key: key);

  final int index;
  final int page;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 25.h,
                  width: 1.h,
                  color: page == 1 ? kBleuColor : kOrangeColor,
                ),
                7.horizontalSpace,
                SizedBox(
                  width: 300.w,
                  child: Text(
                    page == 1
                        ? 'مدارات بمجال تخصصك المهني أو نشاطك التجاري'
                        : 'مدارات بمجال إهتمامك',
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: page == 1 ? kBleuColor : kOrangeColor),
                  ),
                )
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                10.horizontalSpace,
                Text(
                  'بإمكانك ثلاثة إختيارات فقط',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .apply(color: const Color.fromRGBO(150, 150, 150, 1)),
                ),
              ],
            )
          ],
        ),
        Center(
          child: SizedBox(
            height: 50.h,
            width: 50.w,
            child: CircularPercentIndicator(
              radius: 25.h,
              lineWidth: 1.h,
              percent: (index * 1) / 3,
              animation: true,
              addAutomaticKeepAlive: true,
              animateFromLastPercent: true,
              backgroundColor: kLighLightGreyColor,
              center: Center(
                child: Text(
                  index.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: page == 1 ? kBleuColor : kOrangeColor),
                ),
              ),
              progressColor: page == 1 ? kBleuColor : kOrangeColor,
            ),
          ),
        )
      ],
    );
  }
}
