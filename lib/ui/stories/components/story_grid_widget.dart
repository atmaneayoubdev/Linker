import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/general/story_model.dart';

import '../../../helpers/constants.dart';

class StoryGridWidget extends StatelessWidget {
  const StoryGridWidget({
    Key? key,
    required this.story,
    required this.onTap,
  }) : super(key: key);

  final StroyModel story;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 328.h,
        width: 185.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            SizedBox.expand(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  //progressIndicatorBuilder: ,
                  imageUrl: story.image,
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
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                gradient: kVerticalGradiant,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            imageUrl: story.user.avatar,
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
                      10.verticalSpace,
                      Text(
                        story.user.username,
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
