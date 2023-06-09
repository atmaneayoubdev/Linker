import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/controllers/post_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/post/one_post_model.dart';
import 'package:linker/ui/common/market_store_item_widget.dart';
import 'package:linker/ui/home/components/post_header_widget.dart';
import 'package:linker/ui/home/components/post_interatction_widget.dart';
import 'package:provider/provider.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../models/post/comment_model.dart';
import '../../common/loading_widget.dart';
import '../../common/market_product_item_widget.dart';
import '../components/comment_widget.dart';
import '../components/right_widget.dart';

class ShowSharedPostView extends StatefulWidget {
  const ShowSharedPostView(
      {super.key, required this.postId, required this.isFromProfile});
  final String postId;
  final bool isFromProfile;

  @override
  State<ShowSharedPostView> createState() => _ShowSharedPostViewState();
}

class _ShowSharedPostViewState extends State<ShowSharedPostView> {
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

  Future deletePost() async {
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
      postId: post.id,
    ).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value == "تم حذف منشورك") {
        Navigator.of(context).pop(true);
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

  @override
  void initState() {
    showPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kDarkColor,
      body: WillPopScope(
        onWillPop: () {
          return Future.delayed(Duration.zero, () {
            Navigator.pop(context, hasChanged);
            return false;
          });
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
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
                  padding:
                      EdgeInsets.only(left: 10.w, bottom: 10.w, right: 10.w),
                  child: isLoading
                      ? Center(
                          child: LoadingWidget(color: kDarkColor, size: 40.h),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: RefreshIndicator(
                                displacement: 0,
                                color: kDarkColor,
                                onRefresh: () async {
                                  showPost();
                                },
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //20.verticalSpace,
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 15.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9.r),
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                219, 219, 219, 1),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            PostHeaderWidget(
                                              canShowProfile:
                                                  !widget.isFromProfile,
                                              showMenue: post.user.id ==
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .user
                                                      .id,
                                              canEdit: false,
                                              onDelete: () {
                                                deletePost();
                                              },
                                              onEdit: () {},
                                              userId: post.user.id,
                                              createdAt: post.createdAt,
                                              image: post.user.avatar,
                                              jobTitle: post.user.job,
                                              name: post.user.username,
                                            ),
                                            12.verticalSpace,
                                            post.postTypeInfoProduct != null
                                                ? MarketProductItemWidget(
                                                    canNavigat: true,
                                                    isFav: true,
                                                    product: post
                                                        .postTypeInfoProduct!,
                                                    from: "post",
                                                  )
                                                : MarketStoreItemWidget(
                                                    isFav: true,
                                                    store:
                                                        post.postTypeInfoStore!,
                                                    from: "post",
                                                    canNavigat: true),
                                          ],
                                        ),
                                      ),
                                      // 12.verticalSpace,
                                      // post.postTypeInfo != null
                                      //     ? GestureDetector(
                                      //         onTap: () {
                                      //           Navigator.of(context)
                                      //               .push(MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 ShowPostView(
                                      //               isFromProfile: false,
                                      //               postId:
                                      //                   post.postTypeInfo!.id,
                                      //             ),
                                      //           ))
                                      //               .then((value) {
                                      //             if (value == true) {
                                      //               showPost();
                                      //               setState(() {
                                      //                 hasChanged = true;
                                      //               });
                                      //             }
                                      //           });
                                      //         },
                                      //         child: Container(
                                      //           padding: EdgeInsets.symmetric(
                                      //               horizontal: 15.w,
                                      //               vertical: 15.h),
                                      //           decoration: BoxDecoration(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(
                                      //                     9.r),
                                      //             border: Border.all(
                                      //               color: const Color.fromRGBO(
                                      //                   219, 219, 219, 1),
                                      //               width: 0.5,
                                      //             ),
                                      //           ),
                                      //           child: Column(
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment.start,
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment.start,
                                      //             children: [
                                      //               PostHeaderWidget(
                                      //                 canShowProfile: true,
                                      //                 showMenue: false,
                                      //                 canEdit:
                                      //                     post.postTypeInfo ==
                                      //                         null,
                                      //                 onDelete: () {},
                                      //                 onEdit: () {},
                                      //                 userId: post.postTypeInfo!
                                      //                     .user.id,
                                      //                 createdAt: post
                                      //                     .postTypeInfo!
                                      //                     .createdAt,
                                      //                 image: post.postTypeInfo!
                                      //                     .user.avatar,
                                      //                 jobTitle: post
                                      //                     .postTypeInfo!
                                      //                     .user
                                      //                     .username,
                                      //                 name: post.postTypeInfo!
                                      //                     .user.username,
                                      //               ),
                                      //               12.verticalSpace,
                                      //               Text(
                                      //                 post.postTypeInfo!
                                      //                     .description,
                                      //                 textAlign:
                                      //                     TextAlign.start,
                                      //                 style: Theme.of(context)
                                      //                     .textTheme
                                      //                     .bodyMedium!
                                      //                     .apply(
                                      //                       color: kTextColor,
                                      //                     ),
                                      //               ),
                                      //               10.verticalSpace,
                                      //               if (post.postTypeInfo!
                                      //                   .images.isNotEmpty)
                                      //                 GestureDetector(
                                      //                   onTap: () {
                                      //                     Navigator.of(context)
                                      //                         .push(
                                      //                             MaterialPageRoute(
                                      //                       builder: (context) =>
                                      //                           ShowPostView(
                                      //                         isFromProfile:
                                      //                             false,
                                      //                         postId: post
                                      //                             .postTypeInfo!
                                      //                             .id,
                                      //                       ),
                                      //                     ))
                                      //                         .then((value) {
                                      //                       if (value == true) {
                                      //                         showPost();
                                      //                         setState(() {
                                      //                           hasChanged =
                                      //                               true;
                                      //                         });
                                      //                       }
                                      //                     });
                                      //                   },
                                      //                   child: Container(
                                      //                     height: 200.h,
                                      //                     width:
                                      //                         double.infinity,
                                      //                     decoration:
                                      //                         BoxDecoration(
                                      //                       borderRadius:
                                      //                           BorderRadius
                                      //                               .circular(
                                      //                         9.r,
                                      //                       ),
                                      //                     ),
                                      //                     child: SizedBox(
                                      //                       height: 200.h,
                                      //                       child: Stack(
                                      //                         children: [
                                      //                           ClipRRect(
                                      //                             borderRadius:
                                      //                                 BorderRadius
                                      //                                     .circular(
                                      //                                         9.r),
                                      //                             child: Blur(
                                      //                               alignment:
                                      //                                   Alignment
                                      //                                       .center,
                                      //                               blur: 20,
                                      //                               blurColor:
                                      //                                   Colors
                                      //                                       .black,
                                      //                               colorOpacity:
                                      //                                   0.4,
                                      //                               child:
                                      //                                   CachedNetworkImage(
                                      //                                 width: double
                                      //                                     .infinity,
                                      //                                 imageUrl: post
                                      //                                     .postTypeInfo!
                                      //                                     .images
                                      //                                     .first
                                      //                                     .image,
                                      //                                 fit: BoxFit
                                      //                                     .cover,
                                      //                                 placeholder:
                                      //                                     (context, url) =>
                                      //                                         const Center(
                                      //                                   child:
                                      //                                       SizedBox(),
                                      //                                 ),
                                      //                                 errorWidget: (context,
                                      //                                         url,
                                      //                                         error) =>
                                      //                                     const SizedBox(),
                                      //                               ),
                                      //                             ),
                                      //                           ),
                                      //                           Container(
                                      //                             height: 200.h,
                                      //                             width: double
                                      //                                 .infinity,
                                      //                             decoration:
                                      //                                 BoxDecoration(
                                      //                               borderRadius:
                                      //                                   BorderRadius.circular(
                                      //                                       9.r),
                                      //                             ),
                                      //                             child:
                                      //                                 ClipRRect(
                                      //                               borderRadius:
                                      //                                   BorderRadius
                                      //                                       .circular(9),
                                      //                               child:
                                      //                                   CachedNetworkImage(
                                      //                                 imageUrl: post
                                      //                                     .postTypeInfo!
                                      //                                     .images
                                      //                                     .first
                                      //                                     .image,
                                      //                                 fit: BoxFit
                                      //                                     .contain,
                                      //                                 placeholder:
                                      //                                     (context, url) =>
                                      //                                         const Center(
                                      //                                   child:
                                      //                                       SizedBox(),
                                      //                                 ),
                                      //                                 errorWidget: (context,
                                      //                                         url,
                                      //                                         error) =>
                                      //                                     const Center(
                                      //                                   child:
                                      //                                       SizedBox(),
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               if (post.images.isNotEmpty)
                                      //                 10.verticalSpace,
                                      //               if (post.postTypeInfo!
                                      //                   .threads.isNotEmpty)
                                      //                 Column(
                                      //                   children: [
                                      //                     SizedBox(
                                      //                       width: 40.h,
                                      //                       child: Center(
                                      //                         child: Container(
                                      //                           width: 0.5.w,
                                      //                           height: 80.h,
                                      //                           color:
                                      //                               kLightBlackColor,
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                     10.verticalSpace,
                                      //                   ],
                                      //                 ),
                                      //               if (post.postTypeInfo!
                                      //                   .threads.isNotEmpty)
                                      //                 /////////////////////////////////////////////////////////
                                      //                 /////////////////////////////////////////////////////////
                                      //                 ListView.separated(
                                      //                   itemCount: post
                                      //                       .postTypeInfo!
                                      //                       .threads
                                      //                       .length,
                                      //                   shrinkWrap: true,
                                      //                   padding:
                                      //                       EdgeInsets.zero,
                                      //                   physics:
                                      //                       const NeverScrollableScrollPhysics(),
                                      //                   separatorBuilder:
                                      //                       (BuildContext
                                      //                               context,
                                      //                           int index) {
                                      //                     return Column(
                                      //                       crossAxisAlignment:
                                      //                           CrossAxisAlignment
                                      //                               .start,
                                      //                       children: [
                                      //                         10.verticalSpace,
                                      //                         SizedBox(
                                      //                           width: 40.h,
                                      //                           child: Center(
                                      //                             child:
                                      //                                 Container(
                                      //                               width:
                                      //                                   0.5.w,
                                      //                               height:
                                      //                                   80.h,
                                      //                               color:
                                      //                                   kLightBlackColor,
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                         10.verticalSpace,
                                      //                       ],
                                      //                     );
                                      //                   },
                                      //                   itemBuilder:
                                      //                       (BuildContext
                                      //                               context,
                                      //                           int index) {
                                      //                     ThreadModel thread =
                                      //                         post.postTypeInfo!
                                      //                                 .threads[
                                      //                             index];
                                      //                     return ThreadWidget(
                                      //                         canNavigate: true,
                                      //                         onChanged: () {},
                                      //                         showMenue: false,
                                      //                         onDelete: () {},
                                      //                         onEdit: () {},
                                      //                         thread: thread);
                                      //                   },
                                      //                 ),
                                      //               10.verticalSpace,
                                      //               PostInteractionWidget(
                                      //                 canChange: true,
                                      //                 hideShare: false,
                                      //                 comments: post
                                      //                     .postTypeInfo!
                                      //                     .comments,
                                      //                 isLiked: post
                                      //                     .postTypeInfo!
                                      //                     .isLiked,
                                      //                 likes: post
                                      //                     .postTypeInfo!.likes,
                                      //                 postId:
                                      //                     post.postTypeInfo!.id,
                                      //                 shares: post
                                      //                     .postTypeInfo!.shares,
                                      //                 isClickable: false,
                                      //                 canShare: false,
                                      //                 hasChanged: () {
                                      //                   setState(() {
                                      //                     hasChanged = true;
                                      //                   });
                                      //                   log(hasChanged
                                      //                       .toString());
                                      //                 },
                                      //               )
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       )
                                      //     : post.postTypeInfoProduct != null
                                      //         ? MarketProductItemWidget(
                                      //             canNavigat: true,
                                      //             isFav: true,
                                      //             product:
                                      //                 post.postTypeInfoProduct!,
                                      //             from: "post",
                                      //           )
                                      //         : MarketStoreItemWidget(
                                      //             isFav: true,
                                      //             store:
                                      //                 post.postTypeInfoStore!,
                                      //             from: "post",
                                      //             canNavigat: true),
                                      /////////////////////////////////////////////////////////
                                      ////////////////////////////////////////////////////////////

                                      10.verticalSpace,
                                      ListView.separated(
                                        itemCount: post.commentsList.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              10.verticalSpace,
                                              const Divider(
                                                color: Color.fromRGBO(
                                                    219, 219, 219, 1),
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
                                      // 100.verticalSpace,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                    // canShare: post.user.id !=
                                    //     Provider.of<UserProvider>(
                                    //             context)
                                    //         .user
                                    //         .id,
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
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
