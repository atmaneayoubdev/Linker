import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/post/post_model.dart';
import 'package:linker/models/post/small_user_model.dart';
import 'package:linker/ui/home/views/post_view.dart';
import 'package:provider/provider.dart';

import '../../../helpers/user_provider.dart';

class HomeMakePostWidget extends StatelessWidget {
  const HomeMakePostWidget({
    Key? key,
    required this.onPostCreated,
  }) : super(key: key);
  final Function onPostCreated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostView(
                    isFromTherad: false,
                    isUpdating: false,
                    post: PostModel(
                      postTypeInfoStore: null,
                      postTypeInfoProduct: null,
                      id: '',
                      user: SmallUserModel(
                          id: '', username: '', avatar: '', job: ""),
                      description: '',
                      likes: '',
                      comments: '',
                      shares: '',
                      images: [],
                      createdAt: '',
                      postType: '',
                      isLiked: '',
                      threads: [],
                      postTypeInfo: null,
                    ),
                  )),
        ).then((value) {
          if (value == true) {
            onPostCreated();
          }
        });
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
          child: Row(
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
                    imageUrl: Provider.of<UserProvider>(context, listen: true)
                        .user
                        .avatar,
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
              Text(
                'دون يومياتك...',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: kGreyColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
