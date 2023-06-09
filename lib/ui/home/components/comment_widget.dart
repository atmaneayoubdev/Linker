import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/post/comment_model.dart';
import 'package:provider/provider.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/user_provider.dart';
import '../../additional/views/profile_view.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
    required this.comment,
  });
  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileView(
                          userId: comment.user.id,
                          isMyProfile: comment.user.id.toString() ==
                              Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).user.id,
                        ),
                      ));
                },
                child: Container(
                  height: 40.h,
                  width: 40.w,
                  //padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kLightBlackColor, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: comment.user.avatar,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: SizedBox(),
                      ),
                    ),
                  ),
                ),
              ),
              5.horizontalSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.user.username,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(
                          color: kTextColor,
                        )
                        .copyWith(fontSize: 15.sp),
                  ),
                  Text(
                    comment.user.job,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(
                          color: kLightBlackColor,
                        )
                        .copyWith(fontSize: 12.sp),
                  )
                ],
              )
            ],
          ),
          8.verticalSpace,
          Text(comment.comment,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: kTextColor,
                  ))
        ],
      ),
    );
  }
}
