import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/controllers/post_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/post/one_post_model.dart';
import 'package:linker/ui/home/components/post_header_widget.dart';
import 'package:linker/ui/home/components/thread_widget.dart';
import 'package:linker/ui/home/views/post_view.dart';
import 'package:linker/ui/home/views/thread_model.dart';
import 'package:provider/provider.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../models/post/comment_model.dart';
import '../../../models/post/post_model.dart';
import '../../common/loading_widget.dart';
import '../components/comment_widget.dart';
import '../components/post_interatction_widget.dart';
import '../components/right_widget.dart';

class ShowPostView extends StatefulWidget {
  const ShowPostView(
      {super.key, required this.postId, required this.isFromProfile});
  final String postId;
  final bool isFromProfile;

  @override
  State<ShowPostView> createState() => _ShowPostViewState();
}

class _ShowPostViewState extends State<ShowPostView> {
  TextEditingController controller = TextEditingController();

  bool hasChanged = false;
  bool isLoading = false;
  late OnePostModel post;
  Future showPost() async {
    setState(() {
      isLoading = true;
    });

    await PostController.showPost(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      postId: widget.postId,
    ).then((value) {
      setState(() {
        post = value;
        log(value.postTypeInfo.toString());
        isLoading = false;
      });
    });
  }

  Future deletePost(String id) async {
    setState(() {
      isLoading = true;
    });
    await PostController.deletePost(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(
        context,
        listen: false,
      ).user.apiToken,
      postId: id,
    ).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value == "تم حذف منشورك") {
        id == post.id ? Navigator.of(context).pop(true) : showPost();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              value.toString(),
              style: Theme.of(context).textTheme.bodySmall!.apply(
                    color: Colors.white,
                  ),
            ),
          ),
        );
      }
    });
  }

  void onEdit() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
          builder: (context) => PostView(
                isFromTherad: false,
                isUpdating: true,
                post: PostModel(
                  postTypeInfoStore: null,
                  postTypeInfoProduct: null,
                  id: post.id,
                  user: post.user,
                  description: post.description,
                  likes: post.likes,
                  comments: post.comments,
                  shares: post.shares,
                  images: post.images,
                  createdAt: post.createdAt,
                  postType: post.postType,
                  isLiked: post.likes,
                  threads: post.threads,
                  postTypeInfo: post.postTypeInfo,
                ),
              )),
    )
        .then((value) {
      if (value == true) {
        showPost();
      }
    });
  }

  @override
  void initState() {
    showPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            return Future.delayed(Duration.zero, () {
              Navigator.pop(context, hasChanged);
              return false;
            });
          },
          child: isLoading
              ? const Center(
                  child: LoadingWidget(color: kDarkColor, size: 30),
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 20.h),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.pop(context, hasChanged);
                          }
                        },
                        child: SvgPicture.asset(
                          'assets/icons/back_button.svg',
                          height: 45.h,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: RefreshIndicator(
                          displacement: 0,
                          color: kDarkColor,
                          onRefresh: () async {
                            showPost();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //20.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 15.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.r),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          219, 219, 219, 1),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PostHeaderWidget(
                                        canShowProfile: !widget.isFromProfile,
                                        showMenue: post.user.id ==
                                            Provider.of<UserProvider>(
                                              context,
                                              listen: false,
                                            ).user.id,
                                        canEdit: true,
                                        onDelete: () {
                                          deletePost(post.id);
                                        },
                                        onEdit: () {
                                          onEdit();
                                        },
                                        userId: post.user.id,
                                        createdAt: post.createdAt,
                                        image: post.user.avatar,
                                        jobTitle: post.user.job,
                                        name: post.user.username,
                                      ),
                                      12.verticalSpace,
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          post.description,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .apply(
                                                color: kTextColor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //10.verticalSpace,
                                if (post.threads.isNotEmpty)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40.h,
                                          child: Center(
                                            child: Container(
                                              width: 0.5.w,
                                              height: 80.h,
                                              color: kLightBlackColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (post.threads
                                    .isNotEmpty) /////////////////////////////////////////////////////////
                                  /////////////////////////////////////////////////////////
                                  ListView.separated(
                                    itemCount: post.threads.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 40.h,
                                              child: Center(
                                                child: Container(
                                                  width: 0.5.w,
                                                  height: 80.h,
                                                  color: kLightBlackColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      ThreadModel thread = post.threads[index];
                                      return ThreadWidget(
                                          canNavigate: true,
                                          onChanged: () {
                                            showPost();
                                          },
                                          showMenue: thread.user.id ==
                                              Provider.of<UserProvider>(
                                                context,
                                                listen: false,
                                              ).user.id,
                                          onDelete: () {
                                            deletePost(
                                              thread.id,
                                            );
                                          },
                                          onEdit: () {
                                            Navigator.of(context)
                                                .push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostView(
                                                        isFromTherad: true,
                                                        isUpdating: true,
                                                        post: PostModel(
                                                          postTypeInfoStore:
                                                              null,
                                                          postTypeInfoProduct:
                                                              null,
                                                          id: thread.id,
                                                          user: thread.user,
                                                          description: thread
                                                              .description,
                                                          likes: thread.likes,
                                                          comments:
                                                              thread.comments,
                                                          shares: thread.shares,
                                                          images: [],
                                                          createdAt:
                                                              thread.createdAt,
                                                          postType: '',
                                                          isLiked: thread.likes,
                                                          threads: [],
                                                          postTypeInfo: null,
                                                        ),
                                                      )),
                                            )
                                                .then((value) {
                                              if (value == true) {
                                                showPost();
                                              }
                                            });
                                          },
                                          thread: thread);
                                    },
                                  ),
                                20.verticalSpace,

                                ListView.separated(
                                  itemCount: post.commentsList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        10.verticalSpace,
                                        const Divider(
                                          color:
                                              Color.fromRGBO(219, 219, 219, 1),
                                        ),
                                        10.verticalSpace,
                                      ],
                                    );
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    CommentModel comment =
                                        post.commentsList[index];
                                    return CommentWidget(
                                      comment: comment,
                                    );
                                  },
                                ),
                                10.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        bottom: 10.w + MediaQuery.of(context).viewInsets.bottom,
                        right: 10.w,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //20.verticalSpace,
                          SizedBox(
                            width: double.infinity,
                            height: 1.h,
                            child: const Divider(
                              color: kLightBlackColor,
                            ),
                          ),
                          15.verticalSpace,
                          PostInteractionWidget(
                            canChange: true,
                            comments: post.comments,
                            isLiked: post.isLiked,
                            likes: post.likes,
                            postId: post.id,
                            shares: post.shares,
                            isClickable: true,
                            hideShare: true,
                            canShare: false,
                            hasChanged: () {
                              setState(() {
                                hasChanged = true;
                              });
                            },
                          ),
                          15.verticalSpace,
                          SizedBox(
                            width: double.infinity,
                            height: 1.h,
                            child: const Divider(
                              color: kLightBlackColor,
                            ),
                          ),
                          10.verticalSpace,
                          RightWidget(
                              postId: post.id,
                              afterSendingComment: () {
                                showPost();
                              }),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
