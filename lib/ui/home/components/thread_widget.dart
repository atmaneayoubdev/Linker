import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/ui/home/components/post_header_widget.dart';
import 'package:linker/ui/home/views/thread_model.dart';

import '../../../helpers/constants.dart';
import '../views/show_post_view.dart';

class ThreadWidget extends StatelessWidget {
  const ThreadWidget({
    super.key,
    required this.thread,
    required this.onDelete,
    required this.onEdit,
    required this.showMenue,
    required this.onChanged,
    required this.canNavigate,
  });

  final ThreadModel thread;
  final Function onDelete;
  final Function onEdit;
  final bool showMenue;
  final Function onChanged;
  final bool canNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.r),
        border: Border.all(
          color: const Color.fromRGBO(219, 219, 219, 1),
          width: 0.5,
        ),
      ),
      child: GestureDetector(
        onTap: !canNavigate
            ? null
            : () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => ShowPostView(
                    isFromProfile: false,
                    postId: thread.id,
                  ),
                ))
                    .then((value) {
                  if (value == true) {
                    onChanged();
                  }
                });
              },
        child: Column(
          children: [
            PostHeaderWidget(
              canShowProfile: true,
              userId: thread.user.id,
              image: thread.user.avatar,
              name: thread.user.username,
              jobTitle: thread.user.job,
              createdAt: thread.createdAt,
              onDelete: () {
                onDelete();
              },
              onEdit: () {
                onEdit();
              },
              canEdit: true,
              showMenue: showMenue,
            ),
            12.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: Text(
                thread.description,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: kTextColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
