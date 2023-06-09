import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/controllers/post_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/post/post_model.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:linker/ui/home/components/post_input_widget.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../../common/loading_widget.dart';

class PostView extends StatefulWidget {
  const PostView(
      {super.key,
      required this.post,
      required this.isUpdating,
      required this.isFromTherad});
  final PostModel post;
  final bool isUpdating;
  final bool isFromTherad;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _controller = ScrollController();
  // List<File> images = [];
  // List<ImageModel> oldImages = [];
  final List<TextEditingController> _controllers = [TextEditingController()];
  bool isLoading = false;
  int postsNbr = 1;
  void addPost() {
    postsNbr++;
    _controllers.add(TextEditingController());
    if (widget.post.id == '') {
      _scrollDown();
    }
    setState(() {});
  }

  void removePost(int index) {
    postsNbr--;
    _controllers.removeAt(index);
    if (widget.post.id == '') {
      _scrollDown();
    }
    setState(() {});
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future createPost() async {
    setState(() {
      isLoading = true;
    });
    String text = '';
    List<String> threads = [];
    for (var i = 0; i < _controllers.length; i++) {
      String txt = _controllers[i].text;
      txt = txt.padRight(286, ' ');
      threads.add(txt);
      setState(() {});
    }

    for (var txt in threads) {
      text += txt;
    }
    // for (var controller in _controllers) {
    //   text += controller.text;
    // }
    await PostController.createPost(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      description: text,
      //images: images,
    ).then((value) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor:
              value == "تم إضافه منشورك بنجاح" ? kDarkColor : Colors.red,
          content: Text(
            value.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: Colors.white),
          ),
        ),
      );
      if (value == "تم إضافه منشورك بنجاح") {
        Navigator.pop(context, true);
      }
    });
  }

  Future updatePost() async {
    setState(() {
      isLoading = true;
    });
    String text = '';
    for (var controller in _controllers) {
      text += controller.text;
    }
    setState(() {});
    await PostController.updatePost(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      description: text,
      // images: images,
      postId: widget.post.id,
    ).then((value) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor:
              value == "تم تعديل منشورك بنجاح" ? kDarkColor : Colors.red,
          content: Text(
            value.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: Colors.white),
          ),
        ),
      );
      if (value == "تم تعديل منشورك بنجاح") {
        Navigator.pop(context, true);
      }
    });
  }

  bool hasChanged = false;

  @override
  void initState() {
    if (widget.post.description.isNotEmpty) {
      _controllers.first.text = widget.post.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: WillPopScope(
        onWillPop: () {
          return Future.delayed(Duration.zero, () {
            Navigator.pop(context, hasChanged);
            return false;
          });
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: klighSkyBleu,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 77.h,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                'إنشاء مدونة',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, hasChanged);
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/back_button.svg',
                                  height: 45.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 24.h,
                            horizontal: 5.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40.r),
                              bottomRight: Radius.circular(40.r),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(1, 3),
                                blurRadius: 5,
                                spreadRadius: 5,
                                color: Color.fromARGB(10, 0, 0, 0),
                              )
                            ],
                          ),
                          child: SingleChildScrollView(
                            controller: _controller,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  10.verticalSpace,
                                  SizedBox(
                                    height: 40.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40.h,
                                          width: 40.w,
                                          //padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: kLightBlackColor,
                                                width: 2),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .user
                                                      .avatar,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SizedBox(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const SizedBox(),
                                            ),
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        Text(
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user
                                              .userName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .apply(
                                                color: kGreyColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  10.verticalSpace,
                                  ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: postsNbr,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return 10.verticalSpace;
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return PostInputWidtet(
                                        isFirst: index == 0,
                                        isFromThread: widget.isFromTherad,
                                        formKey: _formKey,
                                        controller: _controllers[index],
                                        onRemovePost: () {
                                          if (postsNbr > 0) {
                                            removePost(index);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  15.verticalSpace,
                                  if (!widget.isUpdating)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          addPost();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Center(
                                              child: Icon(
                                                Icons.add_circle_sharp,
                                                color: kBleuColor,
                                                size: 20,
                                              ),
                                            ),
                                            5.horizontalSpace,
                                            Text('إضافة مدونة',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      decoration: TextDecoration
                                                          .underline,
                                                    )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  50.verticalSpace,
                                  GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (widget.post.id.isEmpty) {
                                          createPost();
                                        } else {
                                          updatePost();
                                        }
                                      }
                                    },
                                    child: isLoading
                                        ? LoadingWidget(
                                            color: kDarkColor, size: 40.h)
                                        : LargeButton(
                                            text: widget.isUpdating
                                                ? "تحديث"
                                                : 'نشر',
                                            isButton: false,
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
