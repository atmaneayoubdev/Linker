import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/market/store_model.dart';
import 'package:linker/ui/market/views/store_plicies_view.dart';

import '../../../helpers/constants.dart';

class StoreCardWidget extends StatelessWidget {
  const StoreCardWidget({
    Key? key,
    required this.store,
  }) : super(key: key);
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 214.h,
      width: 372.w,
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 20.w,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17.r),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 5,
                color: Color.fromARGB(17, 0, 0, 0))
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 44.h,
                width: 44.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: klighSkyBleu,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: store.photo,
                    fit: BoxFit.cover,
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
                              double.parse(store.rate).toStringAsFixed(1),
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
                              .apply(color: kGreyColor),
                        ),
                        10.horizontalSpace,
                        Text(
                          '(${double.parse(store.productCount).toStringAsFixed(0)})',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: kBleuColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          17.verticalSpace,
          Text(
            store.shortDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: kGreyColor)
                .copyWith(fontSize: 12.sp, height: 1.5),
          ),
          15.verticalSpace,
          const Divider(
            color: Colors.black26,
          ),
          13.verticalSpace,
          Row(
            children: [
              Container(
                height: 11.h,
                width: 11.w,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(51, 69, 169, 212),
                    shape: BoxShape.circle),
              ),
              12.horizontalSpace,
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoreInfoView(
                              isPolicies: false,
                              info: store.storeInformation)));
                },
                child: Text(
                  'معلومات المتجر',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: kGreyColor)
                      .copyWith(fontSize: 12.sp),
                ),
              ),
              34.horizontalSpace,
              Container(
                height: 11.h,
                width: 11.w,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(51, 69, 169, 212),
                    shape: BoxShape.circle),
              ),
              12.horizontalSpace,
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoreInfoView(
                              isPolicies: true, info: store.storePolicy)));
                },
                child: Text(
                  "سياسات المتجر",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: kGreyColor)
                      .copyWith(
                        fontSize: 12.sp,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
