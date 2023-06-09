import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';

class LargeButton extends StatefulWidget {
  const LargeButton({
    Key? key,
    required this.text,
    required this.isButton,
  }) : super(key: key);
  final String text;
  final bool isButton;

  @override
  State<LargeButton> createState() => _LargeButtonState();
}

class _LargeButtonState extends State<LargeButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.maxFinite,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              14.r,
            ),
            color: kDarkColor,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: Colors.white),
                ),
                if (widget.isButton) 5.horizontalSpace,
                if (widget.isButton)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 20.h,
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
