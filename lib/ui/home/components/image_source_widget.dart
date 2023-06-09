import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class ImageSourceWidget extends StatelessWidget {
  const ImageSourceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            11.r,
          ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context, "camera"),
              child: Container(
                height: 80.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: kDarkColor,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 50.h,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context, "gallery"),
              child: Container(
                height: 80.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: kDarkColor,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 50.h,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
