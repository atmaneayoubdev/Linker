import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/ui/home/components/post_menue_widget.dart';
import 'package:provider/provider.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/user_provider.dart';
import '../../additional/views/profile_view.dart';

class PostHeaderWidget extends StatelessWidget {
  const PostHeaderWidget(
      {super.key,
      required this.userId,
      required this.image,
      required this.name,
      required this.jobTitle,
      required this.createdAt,
      required this.onDelete,
      required this.onEdit,
      required this.canEdit,
      required this.showMenue,
      required this.canShowProfile});
  final String userId;
  final String image;
  final String name;
  final String jobTitle;
  final String createdAt;
  final Function onDelete;
  final Function onEdit;
  final bool canEdit;
  final bool showMenue;
  final bool canShowProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showMenue)
          PostMenuWidget(
            canEdit: canEdit,
            onDelete: () {
              onDelete();
            },
            onEdit: () {
              onEdit();
            },
          ),
        if (showMenue) 20.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              //height: 40.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (canShowProfile) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileView(
                              userId: userId,
                              isMyProfile: userId ==
                                  Provider.of<UserProvider>(
                                    context,
                                    listen: false,
                                  ).user.id,
                            ),
                          ),
                        );
                      }
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
                        borderRadius: BorderRadius.circular(
                          100,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        jobTitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Text(
              createdAt,
              style: Theme.of(context).textTheme.bodySmall!.apply(
                    color: kLightBlackColor,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
