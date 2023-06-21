import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/general/story_model.dart';

class StoryGridWidget extends StatefulWidget {
  const StoryGridWidget({
    Key? key,
    required this.story,
    required this.onTap,
  }) : super(key: key);

  final StroyModel story;
  final Function onTap;

  @override
  State<StoryGridWidget> createState() => _StoryGridWidgetState();
}

class _StoryGridWidgetState extends State<StoryGridWidget> {
  late PageController controller;
  int currentIndex = 0;

  @override
  void initState() {
    controller = PageController(initialPage: currentIndex, keepPage: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 328.h,
        width: 185.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            widget.story.images.isEmpty
                ? Container(
                    // height: double.infinity,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: kVerticalGradiant,
                    ),
                  )
                : PageView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    controller: controller,
                    itemCount: int.parse(widget.story.imageCount),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: Stack(
                          children: [
                            SizedBox.expand(
                              child: CachedNetworkImage(
                                imageUrl: widget.story.images[index].image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: kDarkColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: SizedBox(),
                                ),
                              ),
                            ),
                            Container(
                              // height: double.infinity,
                              // width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                gradient: kVerticalGradiant,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                    height: currentIndex == index ? 15.h : 10.h,
                                    width: currentIndex == index ? 15.w : 10.w,
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
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35.h,
                        width: 35.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.story.user.avatar.replaceAll('\\', '/'),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Container(
                                color: kLightBlackColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        widget.story.user.username,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
