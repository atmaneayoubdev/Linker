import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../helpers/constants.dart';

class SendChatWidget extends StatelessWidget {
  const SendChatWidget({
    Key? key,
    required this.onSend,
    required this.contoller,
    required this.isSending,
  }) : super(key: key);
  final Function onSend;
  final TextEditingController contoller;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 0),
      ),
      //margin: EdgeInsets.symmetric(vertical: 25.h),
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: TextField(
        controller: contoller,
        style: Theme.of(context).textTheme.bodyMedium!.apply(color: kTextColor),
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'اكتب رسالتك هنا',
          hintStyle:
              Theme.of(context).textTheme.bodyMedium!.apply(color: kGreyColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusColor: kGreyColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.r)),
            borderSide: BorderSide(width: 0.5.h, color: kDarkColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.r)),
            borderSide: BorderSide(width: 0.5.h, color: kDarkColor),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(252, 252, 252, 1),
          contentPadding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 10.h),
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
            child: GestureDetector(
              onTap: () {
                onSend();
                contoller.clear();
              },
              child: SizedBox(
                height: 51.h,
                width: 51.w,
                child: Stack(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/icons/send.svg',
                        height: 46.h,
                        width: 46.w,
                      ),
                    ),
                    isSending
                        ? SizedBox.expand(
                            child: CircularProgressIndicator(
                              color: kBleuColor,
                              strokeWidth: 2.w,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
