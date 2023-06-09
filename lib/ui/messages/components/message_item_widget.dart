import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/chats/chat_model.dart';

import '../../../helpers/constants.dart';

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({
    super.key,
    required this.isStoreMessages,
    required this.message,
    required this.isNew,
  });

  final bool isStoreMessages;
  final ChatModel message;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // height: 75.h,
          // width: 390.w,
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: isNew ? klighSkyBleu : Colors.white,
              border:
                  Border.all(color: const Color.fromRGBO(112, 112, 112, 0.1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isStoreMessages
                  ? Container(
                      height: 60.h,
                      width: 60.w,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r),
                        color: klighColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9.r),
                        child: CachedNetworkImage(
                          imageUrl: message.user.avatar,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: SizedBox(),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 60.h,
                      width: 60.w,
                      //padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kLightBlackColor, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: message.user.avatar,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: SizedBox()),
                          errorWidget: (context, url, error) =>
                              const Center(child: SizedBox()),
                        ),
                      ),
                    ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          message.user.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(
                                color: kTextColor,
                              )
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          message.lastDate,
                          style: Theme.of(context).textTheme.bodySmall!.apply(
                                color: klighTextColor,
                              ),
                        )
                      ],
                    ),
                    10.verticalSpace,
                    Text(
                      message.lastMessage.type == "text"
                          ? message.lastMessage.message
                          : 'شارك منتجًا معك',
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall!.apply(
                            color: kLightBlackColor,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (message.lastMessage.seen == "false" &&
            message.lastMessage.sendBy != "you")
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 15.w,
              height: 15.h,
              decoration: const BoxDecoration(
                  color: kBleuColor, shape: BoxShape.circle),
            ),
          )
      ],
    );
  }
}
