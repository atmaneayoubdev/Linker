import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/general/notification_model.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({
    super.key,
    required this.notification,
    required this.onDelete,
  });
  final NotificationModel notification;
  final Function onDelete;

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(widget.notification.id),
      onDismissed: (direction) {
        widget.onDelete();
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: kLightGreyColor),
          borderRadius: BorderRadius.circular(6.r),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            50.horizontalSpace,
          ],
        ),
      ),
      child: Container(
        //width: 383.w,
        decoration: BoxDecoration(
          color: klighSkyBleu,
          border: Border.all(color: kLightGreyColor),
          borderRadius: BorderRadius.circular(6.r),
        ),
        padding: EdgeInsets.all(5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/icons/notification.svg',
              height: 50.h,
            ),
            11.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.notification.body,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 1.5),
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/clock.svg',
                        height: 13.h,
                        colorFilter:
                            const ColorFilter.mode(kGreyColor, BlendMode.srcIn),
                      ),
                      10.horizontalSpace,
                      Text(
                        widget.notification.createdAt,
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color: kGreyColor,
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
