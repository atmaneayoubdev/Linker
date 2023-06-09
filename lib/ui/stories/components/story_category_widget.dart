import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class StoryCategoryWidget extends StatefulWidget {
  const StoryCategoryWidget({
    Key? key,
    required this.isSelected,
    required this.name,
  }) : super(key: key);
  final bool isSelected;
  final String name;

  @override
  State<StoryCategoryWidget> createState() => _StoryCategoryWidgetState();
}

class _StoryCategoryWidgetState extends State<StoryCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: 144.w,
      decoration: BoxDecoration(
        color: widget.isSelected ? kDarkColor : klighSkyBleu,
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
