import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../controllers/post_controller.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';

class RightWidget extends StatefulWidget {
  const RightWidget({
    super.key,
    required this.postId,
    required this.afterSendingComment,
  });

  final String postId;
  final Function afterSendingComment;

  @override
  State<RightWidget> createState() => _RightWidgetState();
}

class _RightWidgetState extends State<RightWidget> {
  TextEditingController controller = TextEditingController();
  bool isCommentLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 7.w,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11.r),
          color: klighColor,
          border: Border.all(color: kLightBlackColor, width: 1.w)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLength: 250,
              maxLines: null,
              autofocus: false,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleSmall,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(2),
                border: InputBorder.none,
                counter: SizedBox(),
              ),
            ),
          ),
          10.horizontalSpace,
          GestureDetector(
            onTap: () async {
              setState(() {
                isCommentLoading = true;
              });
              await PostController.sendComment(
                deviceToken:
                    Provider.of<MessagingProvider>(context, listen: false)
                        .deviceToken,
                token: Provider.of<UserProvider>(context, listen: false)
                    .user
                    .apiToken,
                postId: widget.postId,
                comment: controller.text,
              ).then((value) {
                setState(() {
                  isCommentLoading = false;
                });
                widget.afterSendingComment();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: value.toString() == 'تم إضافه تعليق'
                        ? kDarkColor
                        : Colors.red,
                    content: Text(
                      value.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: Colors.white),
                    ),
                  ),
                );
              });
            },
            child: Container(
              height: 31.h,
              width: 31.w,
              decoration: BoxDecoration(
                color: isCommentLoading ? Colors.transparent : kDarkColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCommentLoading
                    ? const CircularProgressIndicator(
                        color: kDarkColor,
                      )
                    : SvgPicture.asset(
                        'assets/icons/send_comment.svg',
                        height: 15.h,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
