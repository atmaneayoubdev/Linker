import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/helpers/messaging_provider.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/models/auth/user_model.dart';
import 'package:linker/ui/common/show_images_widget.dart';
import 'package:provider/provider.dart';

import '../../../helpers/constants.dart';
import '../../common/loading_widget.dart';
import '../../messages/views/messages_view.dart';
import '../views/users_list_view.dart';

class ProfileCardWidget extends StatefulWidget {
  const ProfileCardWidget({
    Key? key,
    required this.isMyProfile,
    required this.user,
    this.otherUser,
  }) : super(key: key);
  final bool isMyProfile;
  final User? user;
  final OtherUser? otherUser;

  @override
  State<ProfileCardWidget> createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends State<ProfileCardWidget> {
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    if (!widget.isMyProfile) {
      isFollowing =
          widget.otherUser!.followHim.toString() == "true" ? true : false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 15.w,
      ),
      decoration: BoxDecoration(
        color: klighSkyBleu,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text(
          //   widget.isMyProfile
          //       ? "${widget.user!.userName}@"
          //       : "${widget.otherUser!.username}@",
          //   style: Theme.of(context).textTheme.titleLarge,
          // ),
          // 12.verticalSpace,
          GestureDetector(
            onTap: () {
              showDialog<String>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext ctx) {
                  return ShowImagesWidget(
                    images: [
                      widget.isMyProfile
                          ? widget.user!.avatar
                          : widget.otherUser!.avatar
                    ],
                  );
                },
              );
            },
            child: Container(
              height: 103.h,
              width: 103.w,
              //padding: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(211, 211, 211, 1)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: widget.isMyProfile
                      ? widget.user!.avatar
                      : widget.otherUser!.avatar,
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
          10.verticalSpace,
          Text(
            widget.isMyProfile
                ? "${widget.user!.userName}@"
                : "${widget.otherUser!.username}@",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            widget.isMyProfile
                ? widget.user!.jobTitle
                : widget.otherUser!.jobTitle,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .apply(color: kLightBlackColor),
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.user != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserListView(
                                  title: "الواصلون",
                                )));
                  }
                },
                child: Container(
                  color: klighSkyBleu,
                  height: 64.h,
                  width: 80.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "الواصلون",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: kLightBlackColor),
                      ),
                      Text(
                        widget.isMyProfile
                            ? widget.user!.following
                            : widget.otherUser!.following,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 40.h,
                width: 1.w,
                color: kDarkColor,
              ),
              GestureDetector(
                onTap: () {
                  if (widget.user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserListView(
                          title: "المتصلون",
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  color: klighSkyBleu,
                  height: 64.h,
                  width: 80.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "المتصلون",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: kLightBlackColor),
                      ),
                      Text(
                        widget.isMyProfile
                            ? widget.user!.followers
                            : widget.otherUser!.followers,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          if (!widget.isMyProfile)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                15.verticalSpace,
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await MyProfileController.followUnfollow(
                      deviceToken:
                          Provider.of<MessagingProvider>(context, listen: false)
                              .deviceToken,
                      token: Provider.of<UserProvider>(context, listen: false)
                          .user
                          .apiToken,
                      userId: widget.otherUser!.id,
                    ).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      if (value == "تم المتابعة هذا المستخدم" ||
                          value == "تم إلغاء المتابعة") {
                        value == "تم المتابعة هذا المستخدم"
                            ? setState(() {
                                isFollowing = true;
                              })
                            : setState(() {
                                isFollowing = false;
                              });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              value.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .apply(color: Colors.white),
                            )));
                      }
                    });
                  },
                  child: Container(
                    width: 150.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        14.r,
                      ),
                      color: kLightGreyColor,
                    ),
                    child: isLoading
                        ? Center(
                            child: LoadingWidget(color: kDarkColor, size: 40.h),
                          )
                        : Center(
                            child: Text(
                              isFollowing ? "فك الإرتباط" : 'إرتباط',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                  ),
                ),
                10.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => MessagesView(
                              isStore: false,
                              user: widget.otherUser!,
                              chatId: widget.otherUser!.chatId,
                            )),
                      ),
                    );
                  },
                  child: Container(
                    width: 150.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          14.r,
                        ),
                        color: Colors.transparent,
                        border: Border.all(width: 0.3, color: kDarkColor)),
                    child: Center(
                      child: Text(
                        'مراسلة',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                )
              ],
            ),
          12.verticalSpace,
          SizedBox(
            width: 330.w,
            child: Center(
              child: Text(
                widget.isMyProfile ? widget.user!.bio : widget.otherUser!.bio,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
