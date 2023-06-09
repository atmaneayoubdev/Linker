import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/market/mini_store_model.dart';

import '../../../helpers/constants.dart';

class ProductStoreWidget extends StatelessWidget {
  const ProductStoreWidget({
    Key? key,
    required this.store,
    required this.rate,
    required this.onTap,
  }) : super(key: key);
  final MiniStoreModel store;
  final String rate;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            Container(
              height: 50.h,
              width: 44.w,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.r),
                //color: kDarkColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9.r),
                child: CachedNetworkImage(
                  imageUrl: store.photo,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: SizedBox(),
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        store.storeName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: kLightOrangeColor,
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                        child: Row(children: [
                          Text(
                            double.parse(rate).toStringAsFixed(1).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: kOrangeColor),
                          ),
                          5.horizontalSpace,
                          FittedBox(
                            child: Icon(
                              Icons.star,
                              color: kOrangeColor,
                              size: 20.h,
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                  9.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'المنتجات لدية',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: kLightBlackColor),
                      ),
                      10.horizontalSpace,
                      Text(
                        '(${double.parse(store.productCount).toStringAsFixed(0)})',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: kGreyColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
