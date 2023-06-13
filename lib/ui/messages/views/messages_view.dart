import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/controllers/chat_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/models/chats/message_model.dart';
import 'package:linker/models/chats/user_receiver_model.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/common/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../components/chat_bubble_widget.dart';
import '../components/send_chat_widget.dart';

class MessagesView extends StatefulWidget {
  const MessagesView(
      {super.key, required this.chatId, this.user, required this.isStore});
  final String chatId;
  final OtherUser? user;
  final bool isStore;

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  List<MessageModel> _chats = [];
  UserReceiverModel userReceiver =
      UserReceiverModel(id: '', name: '', avatar: '', createdAt: '');
  final TextEditingController _controller = TextEditingController();
  String finalChatId = '';
  bool isSending = false;
  bool isLoading = false;
  bool showLoading = true;

  Future getReloadChats() async {
    setState(() {
      isLoading = true;
    });
    await ChatController.getReloadChat(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      chatId: finalChatId,
    ).then((value) {
      setState(() {
        _chats = value["chats"];
        userReceiver = value["user"];
        isLoading = false;
      });
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    finalChatId = widget.chatId;
    if (widget.chatId != '0') {
      getReloadChats().then((value) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      });
    } else {
      userReceiver = UserReceiverModel(
        id: widget.user!.id,
        name: widget.user!.username,
        avatar: widget.user!.avatar,
        createdAt: widget.user!.lastActionAt,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              height: 90.h,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const BackButtonWidget(),
                      11.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userReceiver.name,
                            style: Theme.of(context).textTheme.bodySmall!.apply(
                                  color: Colors.white,
                                ),
                          ),
                          10.verticalSpace,
                          Row(
                            children: [
                              Container(
                                height: 7.h,
                                width: 7.w,
                                decoration: const BoxDecoration(
                                  color: kGreenColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                userReceiver.createdAt,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .apply(
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (finalChatId != ("0")) {
                        getReloadChats().then((value) {
                          _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        });
                      }
                    },
                    child: Container(
                      height: 30.h,
                      width: 30.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(100, 240, 240, 240),
                      ),
                      child: Center(
                          child: SvgPicture.asset('assets/icons/refresh.svg')),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 22.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: isLoading && showLoading
                          ? Center(
                              child:
                                  LoadingWidget(color: kDarkColor, size: 40.h),
                            )
                          : ListView.separated(
                              controller: _scrollController,
                              reverse: true,
                              itemCount: _chats.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return 15.verticalSpace;
                              },
                              itemBuilder: (BuildContext context, int index) {
                                MessageModel message = _chats[index];
                                return ChatBubbleWidget(
                                  message: message,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SendChatWidget(
                contoller: _controller,
                isSending: isSending,
                onSend: () async {
                  FocusScope.of(context).unfocus();
                  if (_controller.text.isNotEmpty) {
                    setState(() {
                      isSending = true;
                      showLoading = true;
                    });
                    await ChatController.sendMessage(
                            deviceToken: Provider.of<MessagingProvider>(context,
                                    listen: false)
                                .deviceToken,
                            token: Provider.of<UserProvider>(context,
                                    listen: false)
                                .user
                                .apiToken,
                            userId: widget.chatId == '0'
                                ? widget.user!.id.toString()
                                : userReceiver.id,
                            message: _controller.text,
                            type: "text",
                            isStore: widget.isStore)
                        .then((value) {
                      if (value["message"] == "تم إرسال رسالتك بنجاح") {
                        setState(() {
                          finalChatId = value["chat_id"];
                        });
                        getReloadChats().then((value) {
                          _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        });
                        setState(() {
                          isSending = false;
                          showLoading = false;
                        });
                      }
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
