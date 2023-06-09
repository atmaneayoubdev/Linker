import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class ProductTabWidget extends StatefulWidget {
  const ProductTabWidget({
    super.key,
    required this.isDetails,
    required this.setComments,
    required this.setDetails,
  });
  final void Function() setComments;
  final void Function() setDetails;
  final bool isDetails;

  @override
  State<ProductTabWidget> createState() => _ProductTabWidgetState();
}

class _ProductTabWidgetState extends State<ProductTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      //width: 380.w,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Center(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      widget.setDetails();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 54.h,
                      width: 180.w,
                      decoration: BoxDecoration(
                        color:
                            widget.isDetails ? kDarkColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          'تفاصيل المنتج',
                          style: Theme.of(context).textTheme.bodySmall!.apply(
                                color: widget.isDetails
                                    ? Colors.white
                                    : kDarkColor,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.setComments();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                      color: widget.isDetails ? Colors.transparent : kDarkColor,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(
                        'التقييمات',
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color:
                                  !widget.isDetails ? Colors.white : kDarkColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
