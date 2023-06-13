import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/constants.dart';

import '../../../models/general/specialty_model.dart';

class InterestItemWidget extends StatefulWidget {
  const InterestItemWidget(
      {super.key,
      required this.specialtyModel,
      required this.onPress,
      required this.isSelected});
  final SpecialtyModel specialtyModel;
  final Function onPress;
  final bool isSelected;
  @override
  State<InterestItemWidget> createState() => _InterestItemWidgetState();
}

class _InterestItemWidgetState extends State<InterestItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPress();
      },
      child: Container(
        //height: 50.h,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        decoration: BoxDecoration(
          border: Border.all(color: kLightBlackColor, width: 0.5.h),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.specialtyModel.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                widget.isSelected
                    ? GestureDetector(
                        onTap: () {
                          widget.onPress();
                        },
                        child: SvgPicture.asset(
                          'assets/icons/circular_check.svg',
                          height: 20.h,
                          width: 20.w,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          widget.onPress();
                        },
                        child: SvgPicture.asset(
                          'assets/icons/plus.svg',
                          height: 20.h,
                          width: 20.w,
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
