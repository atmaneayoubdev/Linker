import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class StoreMenueWidget extends StatefulWidget {
  const StoreMenueWidget({
    Key? key,
    required this.isSelected,
    required this.name,
  }) : super(key: key);
  final bool isSelected;
  final String name;

  @override
  State<StoreMenueWidget> createState() => _StoreMenueWidgetState();
}

class _StoreMenueWidgetState extends State<StoreMenueWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 30.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? const Color.fromARGB(46, 69, 169, 212)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            widget.name,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(
                  color: widget.isSelected ? kBleuColor : kGreyColor,
                )
                .copyWith(fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}
