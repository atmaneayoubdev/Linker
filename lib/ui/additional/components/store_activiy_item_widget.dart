import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/models/market/category_model.dart';

class StoreActiviyItemWidget extends StatefulWidget {
  const StoreActiviyItemWidget(
      {super.key,
      required this.category,
      required this.isSelected,
      required this.onPress});
  final MarketCategoryModel category;
  final bool isSelected;
  final Function onPress;

  @override
  State<StoreActiviyItemWidget> createState() => _StoreActiviyItemWidgetState();
}

class _StoreActiviyItemWidgetState extends State<StoreActiviyItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPress();
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category.name,
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
      ),
    );
  }
}
