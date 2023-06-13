import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/post/post_model.dart';
import 'package:linker/ui/common/market_store_item_widget.dart';
import 'package:linker/ui/home/components/post_header_widget.dart';
import 'package:linker/ui/home/views/show_shared_post_view.dart';

import '../../../helpers/constants.dart';
import '../../home/components/post_interatction_widget.dart';

class SharedStoreWidget extends StatefulWidget {
  const SharedStoreWidget({
    Key? key,
    required this.post,
    required this.hasChanged,
    required this.canShowProfile,
  }) : super(key: key);
  final PostModel post;
  final Function hasChanged;
  final bool canShowProfile;

  @override
  State<SharedStoreWidget> createState() => _SharedStoreWidgetState();
}

class _SharedStoreWidgetState extends State<SharedStoreWidget> {
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
          log(value.toString());

          if (value) {
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
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.post.description,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: kTextColor,
                    ),
              ),
            ),
            10.verticalSpace,
            MarketStoreItemWidget(
              isFav: true,
              store: widget.post.postTypeInfoStore!,
              from: "post",
              canNavigat: false,
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
