// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:linker/helpers/constants.dart';

// class PayementSuccesfullBottomSheet extends StatelessWidget {
//   const PayementSuccesfullBottomSheet({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 430.h,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(38.r),
//           topRight: Radius.circular(38.r),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           33.verticalSpace,
//           Container(
//             height: 5.h,
//             width: 54.w,
//             color: kLightGreyColor,
//           ),
//           56.verticalSpace,
//           Image.asset(
//             'assets/icons/big_check.png',
//             fit: BoxFit.cover,
//             height: 160.h,
//           ),
//           15.verticalSpace,
//           Text(
//             'تم الدفع بنجاح',
//             style: Theme.of(context)
//                 .textTheme
//                 .titleSmall!
//                 .copyWith(fontWeight: FontWeight.bold),
//           ),
//           15.verticalSpace,
//           Text(
//             'لمتابعة طلبك اذهب الي شاشة طلباتي',
//             style: Theme.of(context).textTheme.bodyLarge!.apply(
//                   color: kGreyColor,
//                 ),
//           )
//         ],
//       ),
//     );
//   }
// }
