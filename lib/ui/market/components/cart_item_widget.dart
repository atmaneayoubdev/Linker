import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../helpers/constants.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({super.key});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102.h,
      //width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: badges.Badge(
              position: badges.BadgePosition.topStart(),
              badgeContent: FittedBox(
                child: Text(
                  '${count}X',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: Colors.white),
                ),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: kOrangeColor,
                borderSide: BorderSide(color: Colors.white, width: 0.5),
              ),
              child: Container(
                height: 88.h,
                width: 88.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/order_item.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تلفزيون UHD 4K، 43 بوصة، سلسلة UP75 4K اكتيف بخاصية التصوير ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      height: 34.h,
                      decoration: BoxDecoration(
                          color: klighSkyBleu,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                count++;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              height: 34.h,
                              decoration: BoxDecoration(
                                  color: klighSkyBleu,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Center(
                                  child:
                                      SvgPicture.asset('assets/icons/add.svg')),
                            ),
                          ),
                          20.horizontalSpace,
                          Text(
                            count.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: kOrangeColor,
                                ),
                          ),
                          20.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              if (count >= 1) {
                                setState(() {
                                  count--;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              height: 34.h,
                              decoration: BoxDecoration(
                                  color: klighSkyBleu,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Center(
                                  child: SvgPicture.asset(
                                      'assets/icons/substract.svg')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      ' 500  ر.س',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
