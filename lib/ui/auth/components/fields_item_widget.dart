import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/general/specialty_model.dart';

class FieldsItemWidget extends StatefulWidget {
  const FieldsItemWidget(
      {super.key,
      required this.specialtyModel,
      required this.onPress,
      required this.isSelected});
  final SpecialtyModel specialtyModel;
  final Function onPress;
  final bool isSelected;

  @override
  State<FieldsItemWidget> createState() => _FieldsItemWidgetState();
}

class _FieldsItemWidgetState extends State<FieldsItemWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPress();
      },
      child: Container(
        //height: 132.h,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        decoration: BoxDecoration(
          border: Border.all(color: kLightBlackColor, width: 0.5.h),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            13.verticalSpace,
            Text(
              widget.specialtyModel.description,
              maxLines: 100,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(
                    color: kLightBlackColor,
                  )
                  .copyWith(
                    height: 1.5.h,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
