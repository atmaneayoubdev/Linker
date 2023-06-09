// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:like_button/like_button.dart';
// import 'package:linker/controllers/post_controller.dart';
// import 'package:linker/helpers/constants.dart';
// import 'package:linker/models/post/post_model.dart';
// import 'package:linker/ui/additional/views/profile_view.dart';
// import 'package:linker/ui/home/views/show_post_view.dart';
// import 'package:provider/provider.dart';
// import 'package:readmore/readmore.dart';

// import '../../../helpers/user_provider.dart';

// class HomePostWidget extends StatefulWidget {
//   const HomePostWidget({
//     Key? key,
//     required this.post,
//     required this.hasChanged,
//   }) : super(key: key);
//   final PostModel post;
//   final Function hasChanged;

//   @override
//   State<HomePostWidget> createState() => _HomePostWidgetState();
// }

// class _HomePostWidgetState extends State<HomePostWidget> {
//   bool isPostLiked = false;
//   int likeCount = 1;

//   @override
//   void initState() {
//     likeCount = int.parse(widget.post.likes);
//     isPostLiked = widget.post.isLiked == 'true';
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context)
//             .push(MaterialPageRoute(
//                 builder: (context) => ShowPostView(
//                       postId: widget.post.id,
//                     )))
//             .then((value) {
//           if (value == true) {
//             widget.hasChanged();
//           }
//         });
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 25.w),
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
//           decoration: BoxDecoration(
//             border: Border.all(
//                 color: const Color.fromRGBO(219, 219, 219, 1), width: 0.5),
//             borderRadius: BorderRadius.circular(9.r),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 40.h,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ProfileView(
//                                     userId: widget.post.user.id,
//                                     isMyProfile:
//                                         widget.post.user.id.toString() ==
//                                             Provider.of<UserProvider>(
//                                               context,
//                                               listen: false,
//                                             ).user.id,
//                                   ),
//                                 ));
//                           },
//                           child: Container(
//                             height: 40.h,
//                             width: 40.w,
//                             //padding: const EdgeInsets.all(1),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border:
//                                   Border.all(color: kLightBlackColor, width: 2),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(100),
//                               child: CachedNetworkImage(
//                                 imageUrl: widget.post.user.avatar,
//                                 fit: BoxFit.cover,
//                                 placeholder: (context, url) => const Center(
//                                   child: SizedBox(),
//                                 ),
//                                 errorWidget: (context, url, error) =>
//                                     const SizedBox(),
//                               ),
//                             ),
//                           ),
//                         ),
//                         10.horizontalSpace,
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.post.user.username,
//                               style:
//                                   Theme.of(context).textTheme.bodyLarge!.apply(
//                                         color: kTextColor,
//                                       ),
//                             ),
//                             Text(
//                               widget.post.user.username,
//                               style:
//                                   Theme.of(context).textTheme.bodySmall!.apply(
//                                         color: kLightBlackColor,
//                                       ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   Text(
//                     widget.post.createdAt,
//                     style: Theme.of(context).textTheme.bodySmall!.apply(
//                           color: kLightBlackColor,
//                         ),
//                   ),
//                 ],
//               ),
//               12.verticalSpace,
//               ReadMoreText(
//                 widget.post.description,
//                 trimLines: 100,
//                 trimLength: 9999,
//                 colorClickableText: kLightBlackColor,
//                 trimMode: TrimMode.Length,
//                 trimCollapsedText: '   عرض المزيد',
//                 trimExpandedText: '   إخفاء',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodySmall!
//                     .apply(
//                       color: kTextColor,
//                     )
//                     .copyWith(height: 1.5),
//                 moreStyle: Theme.of(context).textTheme.bodySmall!.apply(
//                       color: kLightBlackColor,
//                     ),
//               ),
//               10.verticalSpace,
//               if (widget.post.images.isNotEmpty)
//                 Container(
//                   height: 200.h,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(9.r),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(9),
//                     child: CachedNetworkImage(
//                       imageUrl: widget.post.images.first.image,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => const Center(
//                         child: Icon(
//                           Icons.person,
//                           color: kDarkColor,
//                         ),
//                       ),
//                       errorWidget: (context, url, error) => const Center(
//                         child: Icon(
//                           Icons.person,
//                           color: kDarkColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               10.verticalSpace,
//               SizedBox(
//                 height: 20.h,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         LikeButton(
//                           size: 20.h,
//                           circleColor: const CircleColor(
//                             start: Colors.red,
//                             end: Colors.red,
//                           ),
//                           bubblesColor: const BubblesColor(
//                             dotPrimaryColor: kBleuColor,
//                             dotSecondaryColor: kBleuColor,
//                           ),
//                           isLiked: isPostLiked,
//                           onTap: (like) async {
//                             await PostController.likeUnlikePost(
//                               token: Provider.of<UserProvider>(context,
//                                       listen: false)
//                                   .user
//                                   .apiToken,
//                               postId: widget.post.id,
//                             ).then((value) {
//                               if (value == "تم تغير حاله الإعجاب") {
//                                 isPostLiked ? likeCount-- : likeCount++;
//                                 setState(() {
//                                   isPostLiked = !isPostLiked;
//                                 });
//                               }
//                             });
//                             return true;
//                           },
//                           likeBuilder: (bool isLiked) {
//                             return isLiked
//                                 ? SvgPicture.asset(
//                                     'assets/icons/like.svg',
//                                   )
//                                 : SvgPicture.asset(
//                                     'assets/icons/like_outile.svg',
//                                   );
//                           },
//                         ),
//                         // Center(
//                         //   child: GestureDetector(
//                         //     onTap: () {
//                         //       setState(() {
//                         //         isLiked = !isLiked;
//                         //       });
//                         //     },
//                         //     child: isLiked
//                         //         ? SvgPicture.asset(
//                         //             'assets/icons/like.svg',
//                         //             color: Colors.red,
//                         //           )
//                         //         : SvgPicture.asset(
//                         //             'assets/icons/like.svg',
//                         //           ),
//                         //   ),
//                         // ),
//                         5.horizontalSpace,
//                         Text(
//                           likeCount.toString(),
//                           style: Theme.of(context).textTheme.bodySmall,
//                         )
//                       ],
//                     ),
//                     35.horizontalSpace,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Center(
//                           child: SvgPicture.asset('assets/icons/comment.svg'),
//                         ),
//                         5.horizontalSpace,
//                         Text(
//                           widget.post.comments,
//                           style: Theme.of(context).textTheme.bodySmall,
//                         )
//                       ],
//                     ),
//                     35.horizontalSpace,
//                     if (widget.post.user.username !=
//                         Provider.of<UserProvider>(context, listen: false)
//                             .user
//                             .userName)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: GestureDetector(
//                                 onTap: (() {}),
//                                 child:
//                                     SvgPicture.asset('assets/icons/share.svg')),
//                           ),
//                           5.horizontalSpace,
//                           Text(
//                             widget.post.shares,
//                             style: Theme.of(context).textTheme.bodySmall,
//                           )
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//               15.verticalSpace,
//               // Container(
//               //   //height: 43.h,
//               //   padding: EdgeInsets.symmetric(horizontal: 7.w),
//               //   decoration: BoxDecoration(
//               //     borderRadius: BorderRadius.circular(22.r),
//               //     color: kLighLightGreyColor,
//               //   ),
//               //   child: Row(
//               //     crossAxisAlignment: CrossAxisAlignment.center,
//               //     children: [
//               //       Expanded(
//               //         child: TextField(
//               //           //maxLines: 4,
//               //           maxLength: 250,
//               //           maxLines: null,
//               //           textAlign: TextAlign.start,
//               //           style: Theme.of(context).textTheme.titleMedium,
//               //           decoration: const InputDecoration(
//               //             contentPadding: EdgeInsets.all(2),
//               //             border: InputBorder.none,
//               //             counter: SizedBox(),
//               //           ),
//               //         ),
//               //       ),
//               //       10.horizontalSpace,
//               //       Container(
//               //         height: 31.h,
//               //         width: 31.w,
//               //         decoration: BoxDecoration(
//               //           color: Colors.white,
//               //           shape: BoxShape.circle,
//               //           border: Border.all(
//               //             color: const Color.fromARGB(115, 95, 167, 208),
//               //             width: 1.w,
//               //           ),
//               //         ),
//               //         child: Center(
//               //           child: SvgPicture.asset(
//               //             'assets/icons/images.svg',
//               //           ),
//               //         ),
//               //       ),
//               //       10.horizontalSpace,
//               //       Container(
//               //         height: 31.h,
//               //         width: 31.w,
//               //         decoration: const BoxDecoration(
//               //           color: kDarkColor,
//               //           shape: BoxShape.circle,
//               //         ),
//               //         child: Center(
//               //           child: SvgPicture.asset(
//               //             'assets/icons/send_comment.svg',
//               //             height: 15.h,
//               //           ),
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               //15.verticalSpace,
//               // ListView.separated(
//               //   itemCount: 3,
//               //   shrinkWrap: true,
//               //   physics: const NeverScrollableScrollPhysics(),
//               //   separatorBuilder: (BuildContext context, int index) {
//               //     return 13.verticalSpace;
//               //   },
//               //   itemBuilder: (BuildContext context, int index) {
//               //     return const CommentWidget();
//               //   },
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
