import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class MessagesTabWidget extends StatefulWidget {
  const MessagesTabWidget(
      {super.key, required this.callback, required this.isStoreMessages});
  final bool isStoreMessages;
  final Function callback;

  @override
  State<MessagesTabWidget> createState() => _MessagesTabWidgetState();
}

class _MessagesTabWidgetState extends State<MessagesTabWidget> {
  bool isUserMessages = false;
  @override
  void initState() {
    super.initState();
    isUserMessages = !widget.isStoreMessages;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      //width: 380.w,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: klighSkyBleu,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Center(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      isUserMessages = true;
                      widget.callback(false);
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 54.h,
                      width: 180.w,
                      decoration: BoxDecoration(
                        color: isUserMessages ? kDarkColor : Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          'الرسائل الخاصة',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color:
                                    isUserMessages ? Colors.white : kDarkColor,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    isUserMessages = false;
                    widget.callback(true);

                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                      color: isUserMessages ? Colors.white : kDarkColor,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(
                        'رسائل المتاجر',
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color:
                                  !isUserMessages ? Colors.white : kDarkColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
