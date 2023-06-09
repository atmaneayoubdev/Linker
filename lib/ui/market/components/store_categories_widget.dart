import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class StoreCategoriesWidget extends StatefulWidget {
  const StoreCategoriesWidget({
    Key? key,
    required this.isSelected,
    required this.name,
  }) : super(key: key);
  final bool isSelected;
  final String name;

  @override
  State<StoreCategoriesWidget> createState() => _StoreCategoriesWidgetState();
}

class _StoreCategoriesWidgetState extends State<StoreCategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 30.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: widget.isSelected ? kDarkColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            widget.name,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(
                  color: widget.isSelected ? Colors.white : kDarkColor,
                )
                .copyWith(fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}
