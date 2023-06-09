import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../helpers/constants.dart';

class CircleMaxlength extends StatelessWidget {
  const CircleMaxlength({
    super.key,
    required this.length,
  });
  final int length;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: SizedBox(
        height: 50.h,
        width: 50.w,
        child: CircularPercentIndicator(
          backgroundColor: kLightGreyColor,
          radius: 15.h,
          lineWidth: 2.w,
          percent: length / 286,
          animation: false,
          animationDuration: 0,
          restartAnimation: false,
          center: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text(
                length.toString(),
                style: Theme.of(context).textTheme.bodySmall!.apply(
                      color: length == 286 ? Colors.red : kOrangeColor,
                    ),
              ),
            ),
          ),
          progressColor: length == 286 ? Colors.red : kOrangeColor,
        ),
      ),
    );
  }
}
