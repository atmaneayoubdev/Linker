import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/models/post/post_model.dart';
import 'package:linker/ui/additional/components/post_shimmer.dart';
import 'package:linker/ui/additional/components/profle_card_shimmer.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../components/post_widget.dart';
import '../components/profile_card_widget.dart';
import '../components/shared_post_widget.dart';
import '../components/shared_product_widget.dart';
import '../components/shared_store_widget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.isMyProfile, this.userId});
  final bool isMyProfile;
  final String? userId;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  OtherUser? user;
  List<PostModel> posts = [];
  bool isLoading = false;
  bool isPostsLoading = false;

  Future getPosts() async {
    setState(() {
      isPostsLoading = true;
    });
    await MyProfileController.getMyPosts(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      setState(() {
        isPostsLoading = false;
      });
      if (value.runtimeType == List<PostModel>) {
        setState(() {
          posts = value;
        });
      }
    });
  }

  Future showProfile() async {
    setState(() {
      isLoading = true;
    });
    await MyProfileController.showProfile(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      userId: widget.userId!,
    ).then((value) {
      if (value.runtimeType == OtherUser) {
        setState(() {
          user = value;
          isLoading = false;
        });
      }
    });
  }

  Future showProfilePosts() async {
    setState(() {
      isPostsLoading = true;
    });
    await MyProfileController.showProfilePosts(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      userId: widget.userId!,
    ).then((value) {
      setState(() {
        isPostsLoading = false;
      });
      if (value.runtimeType == List<PostModel>) {
        setState(() {
          posts = value;
        });
      }
    });
  }

  @override
  void initState() {
    if (widget.isMyProfile) {
      getPosts();
    } else {
      debugPrint(widget.userId.toString());
      showProfile();
      showProfilePosts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kDarkColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //76.verticalSpace,
            0.verticalSpace,
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                // padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(248, 248, 248, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38.r),
                    topRight: Radius.circular(38.r),
                  ),
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  //padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38.r),
                      topRight: Radius.circular(38.r),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 77.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(38.r),
                              topRight: Radius.circular(38.r)),
                          color: klighSkyBleu,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            20.horizontalSpace,
                            const BackButtonWidget(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                isLoading
                                    ? const ProfileCardShimmer()
                                    : ProfileCardWidget(
                                        otherUser:
                                            !widget.isMyProfile ? user! : null,
                                        user: !widget.isMyProfile
                                            ? null
                                            : Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user,
                                        isMyProfile: widget.isMyProfile,
                                      ),
                                10.verticalSpace,
                                if (isPostsLoading)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: const PostShimmer(
                                      isHome: false,
                                    ),
                                  ),
                                if (!isPostsLoading)
                                  posts.isNotEmpty
                                      ? ListView.separated(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: posts.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return 10.verticalSpace;
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            PostModel post = posts[index];
                                            return post.postTypeInfo != null
                                                ? SharedPostWidget(
                                                    canShowProfile: false,
                                                    post: post,
                                                    hasChanged: () {
                                                      if (widget.isMyProfile) {
                                                        getPosts();
                                                      } else {
                                                        showProfilePosts();
                                                      }
                                                    },
                                                  )
                                                : post.postTypeInfoProduct !=
                                                        null
                                                    ? SharedProductWidget(
                                                        canShowProfile: false,
                                                        post: post,
                                                        hasChanged: () {
                                                          if (widget
                                                              .isMyProfile) {
                                                            getPosts();
                                                          } else {
                                                            showProfilePosts();
                                                          }
                                                        },
                                                      )
                                                    : post.postTypeInfoStore !=
                                                            null
                                                        ? SharedStoreWidget(
                                                            canShowProfile:
                                                                false,
                                                            post: post,
                                                            hasChanged: () {
                                                              if (widget
                                                                  .isMyProfile) {
                                                                getPosts();
                                                              } else {
                                                                showProfilePosts();
                                                              }
                                                            })
                                                        : PostWidget(
                                                            canShowProfile:
                                                                false,
                                                            hasChanged: () {
                                                              if (widget
                                                                  .isMyProfile) {
                                                                getPosts();
                                                              } else {
                                                                showProfilePosts();
                                                              }
                                                            },
                                                            post: post,
                                                          );
                                          },
                                        )
                                      : SizedBox(
                                          height: 500.h,
                                          child: Center(
                                            child: Text(
                                              "ليس لديك منشورات",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .apply(
                                                    color: kTextColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
