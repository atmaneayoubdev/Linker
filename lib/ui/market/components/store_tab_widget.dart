import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class StoreTabWidget extends StatefulWidget {
  const StoreTabWidget({
    super.key,
    required this.isProducts,
    required this.setComments,
    required this.setProduct,
  });
  final void Function() setComments;
  final void Function() setProduct;
  final bool isProducts;

  @override
  State<StoreTabWidget> createState() => _StoreTabWidgetState();
}

class _StoreTabWidgetState extends State<StoreTabWidget> {
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
                      widget.setProduct();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 54.h,
                      width: 180.w,
                      decoration: BoxDecoration(
                        color:
                            widget.isProducts ? kDarkColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          'المنتجات',
                          style: Theme.of(context).textTheme.bodySmall!.apply(
                                color: widget.isProducts
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
                      color:
                          widget.isProducts ? Colors.transparent : kDarkColor,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(
                        'التقييمات',
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color: !widget.isProducts
                                  ? Colors.white
                                  : kDarkColor,
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
