import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class EnumWidget extends StatefulWidget {
  const EnumWidget({
    Key? key,
    required this.isSelected,
    required this.name,
  }) : super(key: key);
  final bool isSelected;
  final String name;

  @override
  State<EnumWidget> createState() => _EnumWidgetState();
}

class _EnumWidgetState extends State<EnumWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      //width: 117.w,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      decoration: BoxDecoration(
        color: widget.isSelected ? kDarkColor : kLightGreyColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Center(
        child: Text(
          widget.name,
          style: Theme.of(context).textTheme.bodySmall!.apply(
                color: widget.isSelected ? Colors.white : kTextColor,
              ),
        ),
      ),
    );
  }
}
