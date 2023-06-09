import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class PostMenuWidget extends StatelessWidget {
  const PostMenuWidget({
    super.key,
    required this.onDelete,
    required this.onEdit,
    required this.canEdit,
  });
  final Function onDelete;
  final Function onEdit;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: PopupMenuButton(
        initialValue: 2,
        onSelected: (value) {
          if (value == 0) {
            onEdit();
          } else if (value == 1) {
            onDelete();
          }
        },
        itemBuilder: (context) {
          return [
            if (canEdit)
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit,
                      color: kDarkColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "تعديل المنشور",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
              ),
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  const Icon(
                    Icons.delete,
                    color: kDarkColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "حذف المنشور",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          ];
        },
        child: SizedBox(
          width: 50.w,
          height: 10.h,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kLightBlackColor),
                ),
              ),
              Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kLightBlackColor),
                ),
              ),
              Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kLightBlackColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
