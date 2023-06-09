import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/ui/additional/views/profile_view.dart';
import 'package:provider/provider.dart';

import '../../../helpers/user_provider.dart';

class UserListItemWidget extends StatefulWidget {
  const UserListItemWidget({
    Key? key,
    required this.user,
  }) : super(key: key);
  final OtherUser user;

  @override
  State<UserListItemWidget> createState() => _UserListItemWidgetState();
}

class _UserListItemWidgetState extends State<UserListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileView(
                userId: widget.user.id,
                isMyProfile: widget.user.id.toString() ==
                    Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).user.id,
              ),
            ));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromRGBO(219, 219, 219, 1), width: 0.5),
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Column(
            children: [
              SizedBox(
                // height: 40.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40.h,
                      width: 40.w,
                      //padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kLightBlackColor, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.avatar,
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
                    10.horizontalSpace,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.username,
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: kTextColor,
                              ),
                        ),
                        Text(
                          widget.user.jobTitle,
                          style: Theme.of(context).textTheme.bodySmall!.apply(
                                color: kLightBlackColor,
                              ),
                        )
                      ],
                    ),
                    // const Spacer(),
                    // FittedBox(
                    //   child: Container(
                    //     height: 30.h,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12.r),
                    //       color: kDarkColor,
                    //     ),
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 10, vertical: 2),
                    //     child: Center(
                    //       child: Text(
                    //         "إتبع",
                    //         style: Theme.of(context).textTheme.bodySmall!.apply(
                    //               color: Colors.white,
                    //             ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              if (widget.user.bio.isNotEmpty) 12.verticalSpace,
              if (widget.user.bio.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.user.bio,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
