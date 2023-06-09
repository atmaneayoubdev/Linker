import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/ui/landing_view.dart';

import '../../../helpers/constants.dart';
import '../../common/large_button.dart';

class CartFooterWidget extends StatelessWidget {
  const CartFooterWidget({
    Key? key,
    required this.func,
    required this.canAddMore,
    required this.showShippingFees,
  }) : super(key: key);
  final void Function() func;
  final bool canAddMore;
  final bool showShippingFees;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 320.h,
        width: double.infinity,
        //padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 40.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(38.r),
            boxShadow: const [
              BoxShadow(
                color: kLighLightGreyColor,
                offset: Offset(0, 0.5),
                blurRadius: 5,
                spreadRadius: 5,
              )
            ]),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4.h,
                      width: 54.w,
                      color: const Color.fromRGBO(234, 234, 234, 1),
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    'ملخص الدفع',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  22.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'قيمه الطلب',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: kGreyColor),
                      ),
                      Text(
                        '509  ر.س',
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color: kGreyColor,
                            ),
                      )
                    ],
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'القيمه المضافه',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: kGreyColor),
                      ),
                      Text(
                        '100  ر.س',
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color: kGreyColor,
                            ),
                      )
                    ],
                  ),
                  15.verticalSpace,
                  if (showShippingFees)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تكلفة الشحن',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: kGreyColor),
                        ),
                        Text(
                          '20  ر.س',
                          style: Theme.of(context).textTheme.bodySmall!.apply(
                                color: kGreyColor,
                              ),
                        )
                      ],
                    ),
                  15.verticalSpace,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 23.w),
                height: 53.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(27.r),
                  color: klighSkyBleu,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الاجمالي',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '1500  ر.س',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(
                            color: kGreyColor,
                          )
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 40.w),
              child: GestureDetector(
                onTap: func,
                child: const LargeButton(isButton: false, text: 'متابعه'),
              ),
            ),
            //5.verticalSpace,
            if (canAddMore)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: ((context) => const LandingView(
                                pageNbr: 3,
                              ))),
                      (route) => false);
                },
                child: Text(
                  'اضف المزيد',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
          ],
        ),
      ),
    );
  }
}
