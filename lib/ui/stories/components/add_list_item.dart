import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AddStoryListItem extends StatelessWidget {
  const AddStoryListItem(
      {super.key, required this.deleteImg, required this.image});
  final Function deleteImg;
  final File image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      width: 70.w,
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 45.h,
              width: 45.w,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                deleteImg();
              },
              child: Container(
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0.5),
                      color: Color.fromARGB(
                        21,
                        0,
                        0,
                        0,
                      ),
                      blurRadius: 1,
                      spreadRadius: 1)
                ]),
                child: SvgPicture.asset(
                  'assets/icons/cancel.svg',
                  height: 25.h,
                  width: 25.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
