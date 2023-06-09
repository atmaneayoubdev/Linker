import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/chat_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/ui/additional/views/profile_view.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../common/loading_widget.dart';

class ShareUserItemWidget extends StatefulWidget {
  const ShareUserItemWidget({
    Key? key,
    required this.user,
    required this.type,
    required this.id,
  }) : super(key: key);
  final OtherUser user;
  final String type;
  final String id;

  @override
  State<ShareUserItemWidget> createState() => _ShareUserItemWidgetState();
}

class _ShareUserItemWidgetState extends State<ShareUserItemWidget> {
  bool hasSend = false;
  bool isLoading = false;

  Future send() async {
    log(widget.type);
    setState(() {
      isLoading = true;
    });
    await ChatController.sendMessage(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      userId: widget.user.id,
      message: widget.id,
      type: widget.type,
      isStore: false,
    ).then((value) {
      if (value["message"] == "تم إرسال رسالتك بنجاح") {
        setState(() {
          hasSend = true;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
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
                  GestureDetector(
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
                    child: Container(
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
                  const Spacer(),
                  GestureDetector(
                    onTap: hasSend
                        ? null
                        : () {
                            send();
                          },
                    child: Container(
                      height: 30.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r),
                        color: hasSend ? kLightGreyColor : kDarkColor,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.w, vertical: 5),
                      child: Center(
                        child: isLoading
                            ? FittedBox(
                                child: LoadingWidget(
                                    color: Colors.white, size: 40.h),
                              )
                            : Text(
                                "إرسال",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .apply(
                                      color: hasSend
                                          ? kLightBlackColor
                                          : Colors.white,
                                    ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
