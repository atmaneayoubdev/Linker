import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/general/notification_model.dart';
import 'package:linker/models/general/story_model.dart';
import 'package:linker/models/post/post_model.dart';

import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/notifications/components/notification_shimmer.dart';
import 'package:linker/ui/notifications/components/notification_widget.dart';
import 'package:provider/provider.dart';

import '../../../controllers/story_controller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../home/views/show_post_view.dart';
import '../../home/views/show_shared_post_view.dart';
import '../../home/views/stories_page_view.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool isLoading = false;
  List<NotificationModel> _notifications = [];

  Future getNotifications() async {
    setState(() {
      isLoading = true;
    });
    await MyProfileController.getNotifications(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      setState(() {
        _notifications = value;
        isLoading = false;
      });
    });
  }

  Future<void> onStoryTaped(id) async {
    await StoryController.showSingleStory(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storyId: id,
    ).then((value) {
      debugPrint(value.runtimeType.toString());
      if (value.runtimeType == StroyModel) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoriesPageView(stories: [
                      value,
                    ], initialIndex: 0)));
      }
    });
  }

  Future<void> onPostTap(id) async {
    await MyProfileController.showSinglePost(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      postId: id,
    ).then((value) {
      debugPrint(value.runtimeType.toString());
      if (value.runtimeType == PostModel) {
        PostModel post = value;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => post.postTypeInfo != null ||
                        post.postTypeInfoProduct != null ||
                        post.postTypeInfoStore != null
                    ? ShowSharedPostView(
                        isFromProfile: false,
                        postId: post.id,
                      )
                    : ShowPostView(
                        isFromProfile: false,
                        postId: post.id,
                      )));
      }
    });
  }

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.all(10.w),
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
                    color: const Color.fromRGBO(250, 250, 250, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 77,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 23.h),
                        decoration: BoxDecoration(
                          color: klighSkyBleu,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(38.r),
                              topRight: Radius.circular(38.r)),
                        ),
                        child: Stack(children: [
                          Center(
                            child: Text(
                              "الإشعارات",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: BackButtonWidget(),
                          )
                        ]),
                      ),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: const Color.fromRGBO(250, 250, 250, 1),
                          padding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 13.w,
                          ),
                          child: isLoading
                              ? const NotificationShimmer()
                              : _notifications.isEmpty
                                  ? Center(
                                      child: Text(
                                        'ليس لديك أي إشعارات',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: () async {
                                        getNotifications();
                                      },
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: _notifications.length,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return 10.verticalSpace;
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          NotificationModel notification =
                                              _notifications[index];
                                          return GestureDetector(
                                            onTap: () async {
                                              if (notification.modelType ==
                                                  "like_story") {
                                                debugPrint(
                                                    "This is like Story");
                                                debugPrint(
                                                    notification.modelId);
                                                onStoryTaped(
                                                    notification.modelId);
                                              }

                                              if (notification.modelType ==
                                                      "like_post" ||
                                                  notification.modelType ==
                                                      "post_comment") {
                                                debugPrint("This is a comment");
                                                debugPrint(
                                                    notification.modelId);
                                                onPostTap(notification.modelId);
                                              }
                                            },
                                            child: NotificationWidget(
                                              notification: notification,
                                              onDelete: () async {
                                                await MyProfileController
                                                    .deleteNotification(
                                                  deviceToken: Provider.of<
                                                              MessagingProvider>(
                                                          context,
                                                          listen: false)
                                                      .deviceToken,
                                                  token:
                                                      Provider.of<UserProvider>(
                                                    context,
                                                    listen: false,
                                                  ).user.apiToken,
                                                  notificatoinId:
                                                      notification.id,
                                                ).then((value) {
                                                  if (value ==
                                                      "تم حذف الإشعار بنجاح") {
                                                    _notifications
                                                        .remove(notification);
                                                    Provider.of<UserProvider>(
                                                                context,
                                                                listen: false)
                                                            .user
                                                            .notifications =
                                                        _notifications.length
                                                            .toString();
                                                  }
                                                });
                                              },
                                            ),
                                          );
                                        },
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
