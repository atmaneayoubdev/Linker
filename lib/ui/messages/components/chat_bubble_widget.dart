import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/chats/message_model.dart';

import '../../../helpers/constants.dart';
import 'chat_product_widget.dart';

class ChatBubbleWidget extends StatelessWidget {
  const ChatBubbleWidget({
    Key? key,
    required this.message,
  }) : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.sendByMe == "true"
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 230.w),
          //width: 230.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //width: 230.w,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: klighSkyBleu,
                  border: Border.all(
                      width: 1.w,
                      color: const Color.fromRGBO(112, 112, 112, 0.1)),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                    bottomLeft: message.sendByMe == "true"
                        ? Radius.circular(24.r)
                        : Radius.circular(0.r),
                    bottomRight: message.sendByMe == "true"
                        ? Radius.circular(0.r)
                        : Radius.circular(24.r),
                  ),
                ),
                child: message.type == "text"
                    ? Text(
                        message.message,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(
                              color: kTextColor,
                            )
                            .copyWith(height: 1.5),
                      )
                    : message.type == 'product'
                        ? MessageProductWidget(
                            isFav: false,
                            cover: message.object!.mainImage,
                            id: message.object!.id,
                            name: message.object!.title,
                            from: 'message',
                            canNavigat: true)
                        : message.type == 'store'
                            ? const Text('this is a store')
                            : const Text('this a story'),
              ),
              5.verticalSpace,
              Text(
                "    ${message.createdAt}",
                style: Theme.of(context).textTheme.bodySmall!.apply(
                      color: kLightBlackColor,
                    ),
              ),
              5.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }
}
