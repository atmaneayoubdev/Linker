import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/constants.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    Key? key,
    required this.description,
    required this.rate,
  }) : super(key: key);
  final String description;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            30.verticalSpace,
            Container(
              //height: 100.h,
              width: 372.w,
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 11.w,
              ),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(15, 0, 0, 0),
                    offset: Offset(0, 0),
                    blurRadius: 5,
                    spreadRadius: 5,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(17.r),
              ),
              child: Text(
                description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(height: 1.5),
              ),
            ),
          ],
        ),
        Container(
          height: 44.h,
          width: 44.w,
          margin: EdgeInsets.symmetric(horizontal: 25.w),
          decoration: BoxDecoration(
            color: kOrangeColor,
            borderRadius: BorderRadius.circular(11.r),
            boxShadow: const [
              BoxShadow(
                color: klighColor,
                offset: Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/icons/star.svg',
                  height: 14.h,
                ),
              ),
              3.verticalSpace,
              Text(
                double.parse(rate).toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall!.apply(
                      color: Colors.white,
                    ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
