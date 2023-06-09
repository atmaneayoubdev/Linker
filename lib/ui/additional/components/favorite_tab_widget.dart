import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class FavoriteTabView extends StatefulWidget {
  const FavoriteTabView({
    super.key,
    required this.isStore,
    required this.setStore,
    required this.setProduct,
  });
  final void Function() setStore;
  final void Function() setProduct;
  final bool isStore;

  @override
  State<FavoriteTabView> createState() => _FavoriteTabViewState();
}

class _FavoriteTabViewState extends State<FavoriteTabView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      //width: 380.w,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: klighSkyBleu,
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
                        color: !widget.isStore ? kDarkColor : Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          'المنتجات',
                          style: Theme.of(context).textTheme.bodySmall!.apply(
                                color:
                                    !widget.isStore ? Colors.white : kDarkColor,
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
                    widget.setStore();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                      color: !widget.isStore ? Colors.transparent : kDarkColor,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(
                        'المتاجر',
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color: widget.isStore ? Colors.white : kDarkColor,
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
