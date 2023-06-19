import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/general/story_model.dart';

import '../../../helpers/constants.dart';

class HomeStoryWidget extends StatelessWidget {
  const HomeStoryWidget({
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
        height: 200.h,
        width: 113.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Stack(
          children: [
            Container(
              height: 200.h,
              width: 113.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  imageUrl: story.images.first.image,
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
              height: 200.h,
              width: 113.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                gradient: kVerticalGradiant,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 25.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.r),
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
                      2.verticalSpace,
                      Text(
                        story.user.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
