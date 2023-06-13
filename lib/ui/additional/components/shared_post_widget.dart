import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/post/post_model.dart';
import 'package:linker/ui/home/components/post_header_widget.dart';
import 'package:linker/ui/home/views/show_shared_post_view.dart';
import 'package:readmore/readmore.dart';

import '../../home/components/post_interatction_widget.dart';

class SharedPostWidget extends StatefulWidget {
  const SharedPostWidget({
    Key? key,
    required this.post,
    required this.hasChanged,
    required this.canShowProfile,
  }) : super(key: key);
  final PostModel post;
  final Function hasChanged;
  final bool canShowProfile;

  @override
  State<SharedPostWidget> createState() => _SharedPostWidgetState();
}

class _SharedPostWidgetState extends State<SharedPostWidget> {
  bool isPostLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    likeCount = int.parse(widget.post.likes);
    isPostLiked = widget.post.isLiked == 'true';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => ShowSharedPostView(
            isFromProfile: !widget.canShowProfile,
            postId: widget.post.id,
          ),
        ))
            .then((value) {
          if (value == true) {
            widget.hasChanged();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(
            color: const Color.fromRGBO(219, 219, 219, 1),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            PostHeaderWidget(
              canShowProfile: widget.canShowProfile,
              canEdit: false,
              showMenue: false,
              onDelete: () {},
              onEdit: () {},
              userId: widget.post.user.id,
              createdAt: widget.post.createdAt,
              image: widget.post.user.avatar,
              jobTitle: widget.post.user.job,
              name: widget.post.user.username,
            ),
            10.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.r),
                border: Border.all(
                  color: const Color.fromRGBO(219, 219, 219, 1),
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostHeaderWidget(
                    canShowProfile: true,
                    canEdit: false,
                    showMenue: false,
                    onDelete: () {},
                    onEdit: () {},
                    userId: widget.post.postTypeInfo!.user.id,
                    createdAt: widget.post.postTypeInfo!.createdAt,
                    image: widget.post.postTypeInfo!.user.avatar,
                    jobTitle: widget.post.postTypeInfo!.user.username,
                    name: widget.post.postTypeInfo!.user.username,
                  ),
                  12.verticalSpace,
                  ReadMoreText(
                    widget.post.postTypeInfo!.description,
                    trimLines: 100,
                    trimLength: 9999,
                    colorClickableText: kLightBlackColor,
                    trimMode: TrimMode.Length,
                    trimCollapsedText: '   عرض المزيد',
                    trimExpandedText: '   إخفاء',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(
                          color: kTextColor,
                        )
                        .copyWith(height: 1.5),
                    moreStyle: Theme.of(context).textTheme.bodySmall!.apply(
                          color: kLightBlackColor,
                        ),
                  ),
                  10.verticalSpace,
                  PostInteractionWidget(
                    canChange: false,
                    comments: widget.post.postTypeInfo!.comments,
                    isLiked: widget.post.postTypeInfo!.isLiked,
                    likes: widget.post.postTypeInfo!.likes,
                    postId: widget.post.postTypeInfo!.id,
                    shares: widget.post.postTypeInfo!.shares,
                    isClickable: false,
                    hideShare: true,
                    // canShare: widget.post.postTypeInfo!.id !=
                    //     Provider.of<UserProvider>(context).user.id,
                    canShare: false,
                    hasChanged: () {
                      widget.hasChanged();
                    },
                  )
                ],
              ),
            ),
            12.verticalSpace,
            PostInteractionWidget(
              canChange: false,
              hideShare: true,
              comments: widget.post.comments,
              isLiked: widget.post.isLiked,
              likes: widget.post.likes,
              postId: widget.post.id,
              shares: widget.post.shares,
              isClickable: true,
              // canShare: widget.post.user.id !=
              //     Provider.of<UserProvider>(context).user.id,
              canShare: false,
              hasChanged: () {
                widget.hasChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}
