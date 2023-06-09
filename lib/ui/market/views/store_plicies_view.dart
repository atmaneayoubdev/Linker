import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/common/back_button_widget.dart';

class StoreInfoView extends StatefulWidget {
  const StoreInfoView(
      {super.key, required this.isPolicies, required this.info});
  final bool isPolicies;
  final String info;

  @override
  State<StoreInfoView> createState() => _StoreInfoViewState();
}

class _StoreInfoViewState extends State<StoreInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          76.verticalSpace,
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(248, 248, 248, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38.r),
                  topRight: Radius.circular(38.r),
                ),
              ),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                //padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38.r),
                    topRight: Radius.circular(38.r),
                  ),
                  color: const Color.fromRGBO(250, 250, 250, 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 77,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 23.h),
                      decoration: BoxDecoration(
                        color: klighSkyBleu,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(38.r),
                            topRight: Radius.circular(38.r)),
                      ),
                      child: Stack(children: [
                        Center(
                          child: Text(
                            widget.isPolicies
                                ? "سياسات المتجر"
                                : 'معلومات المتجر',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: BackButtonWidget(),
                        )
                      ]),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: const Color.fromRGBO(250, 250, 250, 1),
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 13.w,
                        ),
                        child: SingleChildScrollView(
                          child: Text(widget.info),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
