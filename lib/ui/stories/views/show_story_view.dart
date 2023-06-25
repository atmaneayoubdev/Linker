import 'dart:async';

import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:linker/models/general/story_model.dart';
import 'package:provider/provider.dart';

import '../../../controllers/story_controller.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../additional/views/profile_view.dart';

class ShowStoryView extends StatefulWidget {
  const ShowStoryView(
      {super.key,
      required this.story,
      required this.didChange,
      required this.canShow});
  final StroyModel story;
  final Function(bool) didChange;
  final bool canShow;

  @override
  State<ShowStoryView> createState() => _ShowStoryViewState();
}

class _ShowStoryViewState extends State<ShowStoryView> {
  bool isStoryLiked = false;
  bool hasChanged = false;
  bool isDialogOpen = false;
  bool canShow = true;
  int likesNbr = 0;
  int currentImgIndex = 0;

  @override
  void initState() {
    isStoryLiked = widget.story.isLiked == "true";
    likesNbr = int.parse(widget.story.likes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: WillPopScope(
        onWillPop: () {
          return Future.delayed(Duration.zero, () {
            Navigator.pop(context, hasChanged);
            return false;
          });
        },
        child: Stack(
          children: [
            SizedBox.expand(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: widget.story.images.isNotEmpty
                      ? widget.story.images[currentImgIndex].image
                      : "",
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  tileMode: TileMode.clamp,
                  radius: 1,
                  focalRadius: 0.5,
                  focal: Alignment.center,
                  colors: [
                    Color.fromARGB(0, 0, 0, 0),
                    Color.fromARGB(141, 0, 0, 0),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (currentImgIndex != 0) {
                        setState(() {
                          currentImgIndex--;
                        });
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.transparent,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (currentImgIndex <
                          int.parse(widget.story.imageCount) - 1) {
                        setState(() {
                          currentImgIndex++;
                        });
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.transparent,
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: widget.canShow,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, top: 50.h, bottom: 15.h),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                      //width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, hasChanged);
                            },
                            child: SvgPicture.asset(
                              'assets/icons/back_button.svg',
                              height: 45.h,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Center(
                                    child: Container(
                                      height: currentImgIndex == index
                                          ? 15.h
                                          : 10.h,
                                      width: currentImgIndex == index
                                          ? 15.w
                                          : 10.w,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return 3.horizontalSpace;
                                },
                                itemCount: widget.story.images.length,
                              ),
                            ),
                          ),
                          Text(
                            widget.story.createdAt,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    27.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileView(
                                          userId: widget.story.user.id,
                                          isMyProfile:
                                              widget.story.user.id.toString() ==
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
                                    border: Border.all(
                                      color: kLightBlackColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.story.user.avatar,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: SizedBox(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const SizedBox(),
                                    ),
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.story.user.username,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .apply(
                                          color: Colors.white,
                                        ),
                                  ),
                                  Text(
                                    widget.story.user.job,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .apply(
                                          color: Colors.white,
                                        ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        if (widget.story.user.id ==
                            Provider.of<UserProvider>(context, listen: false)
                                .user
                                .id)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDialogOpen = true;
                              });
                              showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    //title: const Text('Basic dialog title'),
                                    content:
                                        const Text("هل تريد حذف هذه القصة"),
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
                                setState(() {
                                  isDialogOpen = false;
                                  widget.didChange(true);
                                });
                                if (value == true) {
                                  await StoryController.deleteStory(
                                    deviceToken: Provider.of<MessagingProvider>(
                                            context,
                                            listen: false)
                                        .deviceToken,
                                    token: Provider.of<UserProvider>(
                                      context,
                                      listen: false,
                                    ).user.apiToken,
                                    storyId: widget.story.id,
                                  ).then((value2) {
                                    if (value2 == "تم حذف قصتك") {
                                      Navigator.of(context).pop(true);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: kDarkColor,
                                          content: Text(
                                            value2.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .apply(color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                }
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: Blur(
                                blur: 3,
                                blurColor: Colors.white,
                                colorOpacity: 0.3,
                                overlay: const FaIcon(
                                  FontAwesomeIcons.trashCan,
                                  color: Colors.white,
                                ),
                                child: Container(
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            ClipOval(
                              // borderRadius: BorderRadius.circular(100),
                              child: Blur(
                                blur: 3,
                                blurColor: Colors.white,
                                colorOpacity: 0.3,
                                overlay: LikeButton(
                                  size: 30.h,
                                  circleColor: const CircleColor(
                                    start: Colors.red,
                                    end: Colors.red,
                                  ),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor: kBleuColor,
                                    dotSecondaryColor: kBleuColor,
                                  ),
                                  isLiked: isStoryLiked,
                                  onTap: (like) async {
                                    setState(() {
                                      hasChanged = true;
                                      widget.didChange(true);
                                    });
                                    await StoryController.likeUnlikePost(
                                      deviceToken:
                                          Provider.of<MessagingProvider>(
                                                  context,
                                                  listen: false)
                                              .deviceToken,
                                      token: Provider.of<UserProvider>(
                                        context,
                                        listen: false,
                                      ).user.apiToken,
                                      storyId: widget.story.id,
                                    ).then((value) {
                                      if (value == "تم تغير حاله الإعجاب") {
                                        setState(() {
                                          isStoryLiked = !isStoryLiked;
                                          isStoryLiked
                                              ? likesNbr++
                                              : likesNbr--;
                                        });
                                      }
                                    });
                                    return true;
                                  },
                                  likeBuilder: (bool isLiked) {
                                    return isLiked
                                        ? SvgPicture.asset(
                                            'assets/icons/like.svg',
                                            colorFilter: const ColorFilter.mode(
                                                Colors.white, BlendMode.srcIn),
                                          )
                                        : SvgPicture.asset(
                                            'assets/icons/like_outile.svg',
                                            colorFilter: const ColorFilter.mode(
                                                Colors.white, BlendMode.srcIn),
                                          );
                                  },
                                ),
                                child: Container(
                                  height: 45.h,
                                  width: 45.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              likesNbr.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .apply(color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                    23.verticalSpace,
                    Text(
                      widget.story.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: Colors.white)
                          .copyWith(height: 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
