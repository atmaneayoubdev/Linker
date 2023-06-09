import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/chats/chat_list_model.dart';
import 'package:linker/ui/messages/components/message_item_shimmer.dart';
import 'package:linker/ui/messages/components/message_item_widget.dart';
import 'package:linker/ui/messages/components/tab_widget.dart';
import 'package:provider/provider.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/my_profile_controller.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../../models/chats/chat_model.dart';
import 'messages_view.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  final List<ChatModel> _userMessages = [];
  final List<ChatModel> _newUserMessages = [];
  final List<ChatModel> _storesMessages = [];
  final List<ChatModel> _newStoreMessages = [];

  String userNewMessagesCount = '';
  String storesNewMessagesCount = '';

  Future getUserChats() async {
    setState(() {
      isLoading = true;
      _userMessages.clear();
      _newUserMessages.clear();
    });
    await ChatController.getChat(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      type: "default",
    ).then((value) {
      if (value.runtimeType == ChatListModel) {
        for (var chat in value.chats) {
          chat.lastMessage.seen == "false" && chat.lastMessage.sendBy != "you"
              ? _newUserMessages.add(chat)
              : _userMessages.add(chat);
        }
        userNewMessagesCount = _newUserMessages.length.toString();
        isLoading = false;
        setState(() {});
      }
    });
  }

  Future getNotificationsCount() async {
    await MyProfileController.getNotificationsCount(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      Provider.of<UserProvider>(context, listen: false)
          .setUserNotifications(value);
    });
  }

  Future getStoreChats() async {
    setState(() {
      isLoading = true;
      _storesMessages.clear();
      _newStoreMessages.clear();
    });
    await ChatController.getChat(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      type: "store",
    ).then((value) {
      if (value.runtimeType == ChatListModel) {
        for (var chat in value.chats) {
          chat.lastMessage.seen == "false" && chat.lastMessage.sendBy != "you"
              ? _newStoreMessages.add(chat)
              : _storesMessages.add(chat);
        }
        storesNewMessagesCount = _newStoreMessages.length.toString();

        isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getNotificationsCount();
    getUserChats();
    getStoreChats();
    super.initState();
  }

  bool _isStoreMessages = false;
  callback(newValue) {
    setState(() {
      _isStoreMessages = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          displacement: 0,
          onRefresh: () async {
            getNotificationsCount();

            getUserChats();
            getStoreChats();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.verticalSpace,
                  MessagesTabWidget(
                    callback: callback,
                    isStoreMessages: _isStoreMessages,
                  ),
                  if ((_isStoreMessages && _newStoreMessages.isNotEmpty) ||
                      (!_isStoreMessages && _newUserMessages.isNotEmpty))
                    20.verticalSpace,
                  if ((_isStoreMessages && _newStoreMessages.isNotEmpty) ||
                      (!_isStoreMessages && _newUserMessages.isNotEmpty))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'محادثات جديده',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color: kBleuColor,
                              ),
                        ),
                        10.horizontalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kBleuColor,
                          ),
                          child: Center(
                            child: Text(
                              _isStoreMessages
                                  ? storesNewMessagesCount
                                  : userNewMessagesCount,
                              style:
                                  Theme.of(context).textTheme.bodyMedium!.apply(
                                        color: Colors.white,
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  15.verticalSpace,
                  if (isLoading) const MessagesItemShimmer(isNew: true),
                  if (!isLoading)
                    ListView.separated(
                      itemCount: _isStoreMessages
                          ? _newStoreMessages.length
                          : _newUserMessages.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) {
                        return 10.verticalSpace;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        ChatModel chat = _isStoreMessages == true
                            ? _newStoreMessages[index]
                            : _newUserMessages[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => MessagesView(
                                isStore: _isStoreMessages,
                                chatId: _isStoreMessages == true
                                    ? _newStoreMessages[index].id
                                    : _newUserMessages[index].id,
                              ),
                            ),
                          )
                              .then((value) {
                            getUserChats();
                            getStoreChats();
                          }),
                          child: ChatItemWidget(
                            isNew: true,
                            message: chat,
                            isStoreMessages: _isStoreMessages,
                          ),
                        );
                      },
                    ),
                  20.verticalSpace,
                  if ((_isStoreMessages && _storesMessages.isNotEmpty) ||
                      (!_isStoreMessages && _userMessages.isNotEmpty))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'جميع المحادثات',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color: kTextColor,
                              ),
                        ),
                      ],
                    ),
                  15.verticalSpace,
                  if (isLoading) const MessagesItemShimmer(isNew: false),
                  if (!isLoading)
                    ListView.separated(
                      itemCount: _isStoreMessages
                          ? _storesMessages.length
                          : _userMessages.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) {
                        return 10.verticalSpace;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        ChatModel chat = _isStoreMessages == true
                            ? _storesMessages[index]
                            : _userMessages[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                                builder: (context) => MessagesView(
                                      isStore: _isStoreMessages,
                                      chatId: _isStoreMessages == true
                                          ? _storesMessages[index].id
                                          : _userMessages[index].id,
                                    )),
                          )
                              .then((value) {
                            getUserChats();
                            getStoreChats();
                          }),
                          child: ChatItemWidget(
                            isNew: false,
                            message: chat,
                            isStoreMessages: _isStoreMessages,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
