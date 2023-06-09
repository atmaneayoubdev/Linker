import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../../../controllers/post_controller.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';

class PostInteractionWidget extends StatefulWidget {
  const PostInteractionWidget({
    super.key,
    // required this.post,
    required this.hasChanged,
    required this.isLiked,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.postId,
    required this.isClickable,
    required this.canShare,
    required this.hideShare,
    required this.canChange,
  });
  // final OnePostModel post;
  final Function hasChanged;
  final String isLiked;
  final String likes;
  final String comments;
  final String shares;
  final String postId;
  final bool isClickable;
  final bool canShare;
  final bool hideShare;
  final bool canChange;

  @override
  State<PostInteractionWidget> createState() => _PostInteractionWidgetState();
}

class _PostInteractionWidgetState extends State<PostInteractionWidget> {
  bool isPostLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    isPostLiked = widget.isLiked == 'true';
    likeCount = int.parse(widget.likes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 20.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LikeButton(
                    size: 30.h,
                    circleColor: const CircleColor(
                      start: Colors.red,
                      end: Colors.red,
                    ),
                    bubblesColor: const BubblesColor(
                      dotPrimaryColor: kBleuColor,
                      dotSecondaryColor: kBleuColor,
                    ),
                    isLiked: isPostLiked,
                    onTap: (like) async {
                      if (widget.isClickable) {
                        await PostController.likeUnlikePost(
                          deviceToken: Provider.of<MessagingProvider>(context,
                                  listen: false)
                              .deviceToken,
                          token:
                              Provider.of<UserProvider>(context, listen: false)
                                  .user
                                  .apiToken,
                          postId: widget.postId,
                        ).then((value) {
                          if (value == "تم تغير حاله الإعجاب") {
                            isPostLiked ? likeCount-- : likeCount++;
                            setState(() {
                              isPostLiked = !isPostLiked;
                            });
                            if (widget.canChange) widget.hasChanged();
                          }
                        });
                        return true;
                      }
                      return null;
                    },
                    likeBuilder: (bool isLiked) {
                      if (widget.isClickable) {
                        return isLiked
                            ? SvgPicture.asset(
                                'assets/icons/like.svg',
                              )
                            : SvgPicture.asset(
                                'assets/icons/like_outile.svg',
                              );
                      } else {
                        return SvgPicture.asset(
                          'assets/icons/like_outile.svg',
                          colorFilter: const ColorFilter.mode(
                              kLightBlackColor, BlendMode.srcIn),
                        );
                      }
                    },
                  ),
                  5.horizontalSpace,
                  Text(
                    likeCount.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
              35.horizontalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: widget.isClickable
                        ? SvgPicture.asset(
                            'assets/icons/comment.svg',
                            height: 30.h,
                          )
                        : SvgPicture.asset(
                            'assets/icons/comment.svg',
                            height: 30.h,
                            colorFilter: const ColorFilter.mode(
                                kLightBlackColor, BlendMode.srcIn),
                          ),
                  ),
                  5.horizontalSpace,
                  Text(
                    widget.comments,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
              35.horizontalSpace,
              if (widget.canShare)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (widget.isClickable) {
                            showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //title: const Text('Basic dialog title'),
                                  content: const Text(
                                      "هل ترغب في مشاركة هذا المنشور"),
                                  actions: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('موافق'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: const Text('لا'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).then((value) async {
                              await PostController.sharePost(
                                      description: '',
                                      deviceToken:
                                          Provider.of<MessagingProvider>(
                                                  context,
                                                  listen: false)
                                              .deviceToken,
                                      token: Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user
                                          .apiToken,
                                      postType: "post",
                                      postTypeId: widget.postId)
                                  .then((value) {
                                if (value == "تم المشاركة بنجاح") {
                                  widget.hasChanged();
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: kDarkColor,
                                        content: Text(
                                          value.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .apply(color: Colors.white),
                                        )));
                              });
                            });
                          }
                        },
                        child: widget.isClickable
                            ? SvgPicture.asset(
                                'assets/icons/share.svg',
                              )
                            : SvgPicture.asset(
                                'assets/icons/share.svg',
                                colorFilter: const ColorFilter.mode(
                                    kLightBlackColor, BlendMode.srcIn),
                              ),
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      widget.shares,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              if (!widget.canShare && !widget.hideShare)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: widget.isClickable
                          ? SvgPicture.asset(
                              'assets/icons/share.svg',
                            )
                          : SvgPicture.asset(
                              'assets/icons/share.svg',
                              colorFilter: const ColorFilter.mode(
                                  kLightBlackColor, BlendMode.srcIn),
                            ),
                    ),
                    5.horizontalSpace,
                    Text(
                      widget.shares,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }
}
