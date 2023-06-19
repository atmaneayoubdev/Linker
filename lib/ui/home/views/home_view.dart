import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/controllers/post_controller.dart';
import 'package:linker/controllers/story_controller.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/general/pagination.dart';
import 'package:linker/models/general/story_model.dart';
import 'package:linker/models/post/post_model.dart';
import 'package:linker/ui/additional/components/post_shimmer.dart';
import 'package:linker/ui/additional/components/post_widget.dart';
import 'package:linker/ui/additional/components/shared_post_widget.dart';
import 'package:linker/ui/additional/components/shared_product_widget.dart';
import 'package:linker/ui/additional/components/shared_store_widget.dart';
import 'package:linker/ui/auth/views/additional_info_view.dart';
import 'package:linker/ui/home/views/post_view.dart';
import 'package:linker/ui/home/views/search_view.dart';
import 'package:linker/ui/home/views/stories_page_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/my_profile_controller.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../models/auth/user_model.dart';
import '../../../models/post/small_user_model.dart';
import '../components/home_make_post_widget.dart';
import '../components/home_story_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.isLogging});
  final bool? isLogging;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();
  final List<PostModel> _posts = [];
  List<StroyModel> _stories = [];
  final focusNode = FocusNode();
  bool isLoading = true;
  bool isPostsLoading = true;
  bool isPosts = true;
  Pagination postsPagination =
      Pagination(currentPage: 0, lastPage: 0, perPage: 0, total: 0);
  bool paginateLoading = false;
  late ScrollController _controller;

  Future getMyProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await MyProfileController.getMyProfile(
      token: prefs.getString('api_token')!,
      deviceToken:
          // ignore: use_build_context_synchronously
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) {
      if (value.runtimeType == User) {
        Provider.of<UserProvider>(context, listen: false).setUser(value);
      }
    });
  }

  Future getPostsList() async {
    setState(() {
      postsPagination.currentPage == 0
          ? isPostsLoading = true
          : paginateLoading = true;
    });
    await PostController.getMyPosts(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      page: postsPagination.currentPage + 1,
    ).then((value) {
      setState(() {
        _posts.addAll(value['posts']);
        postsPagination = value['pagination'];
        postsPagination.currentPage == 1
            ? isPostsLoading = false
            : paginateLoading = false;
      });
    });
  }

  Future getStories() async {
    setState(() {
      isLoading = true;
    });
    await StoryController.getFollowingStories(
            deviceToken: Provider.of<MessagingProvider>(context, listen: false)
                .deviceToken,
            token:
                Provider.of<UserProvider>(context, listen: false).user.apiToken)
        .then((value) {
      if (mounted) {
        setState(() {
          _stories = value;
          isLoading = false;
        });
      }
    });
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent * 1.00 &&
        !_controller.position.outOfRange) {
      if (postsPagination.currentPage != postsPagination.lastPage) {
        getPostsList();
      }
    }
  }

  Future getNotificationsCount() async {
    await MyProfileController.getNotificationsCount(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      if (value == "برجاء إستكمال بيانات الحساب اولا") {
        String phone =
            Provider.of<UserProvider>(context, listen: false).user.phoneNumber;
        String token =
            Provider.of<UserProvider>(context, listen: false).user.apiToken;
        deleteUserFromPrefs();
        Provider.of<UserProvider>(context, listen: false).clearUser();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          content: Text(
            value.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: Colors.white),
          ),
        ));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionalInfoView(
              phone: phone,
              token: token,
            ),
          ),
          (route) => false,
        );
      } else {
        Provider.of<UserProvider>(context, listen: false)
            .setUserNotifications(value);
      }
    });
  }

  Future deleteUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    getMyProfile().then((value) {
      getNotificationsCount();
      getStories();
      getPostsList();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: GestureDetector(
        onTap: () async {
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
                        postTypeInfo: null))),
          ).then((value) {
            if (value == true) {
              postsPagination.currentPage = 0;
              _posts.clear();
              getPostsList();
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
          //height: 60.h,
          //width: 100.w,
          decoration: BoxDecoration(
              color: kBleuColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(5, 0, 0, 0),
                  blurRadius: 10,
                  spreadRadius: 10,
                  offset: Offset(0, 0),
                )
              ]),
          child: Text(
            "دون يومياتك",
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          displacement: 0,
          onRefresh: () async {
            setState(() {
              _stories.clear();
              _posts.clear();
              postsPagination =
                  Pagination(currentPage: 0, lastPage: 0, perPage: 0, total: 0);
            });
            getNotificationsCount();
            getStories();
            getPostsList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                16.verticalSpace,

                //////////////////Search widget///////////////////
                ///
                ///
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchView()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    //height: 60.h,
                    child: TextField(
                      enabled: false,
                      showCursor: false,
                      style: Theme.of(context).textTheme.bodySmall,
                      // controller: searchController,
                      scrollPadding: EdgeInsets.zero,
                      maxLines: 1,

                      autofocus: false,
                      decoration: formFieldDecoration!.copyWith(
                        enabled: false,
                        isDense: true,
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        hintText: 'ماذا تريد ان تبحث عن …',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(219, 219, 219, 1),
                          ),
                        ),
                        prefixIcon: SizedBox(
                          height: 10.h,
                          width: 15.w,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/loop.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ), //
                ///
                /////
                ////////////////////////////////////////////////////////////////

                Column(
                  children: [
                    10.verticalSpace,
                    if (isLoading)
                      SizedBox(
                        height: 200.h,
                        width: double.infinity,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          separatorBuilder: (BuildContext context, int index) {
                            return 6.horizontalSpace;
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Shimmer.fromColors(
                              baseColor: kLightGreyColor,
                              highlightColor: Colors.white,
                              child: Container(
                                height: 200.h,
                                width: 113.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14.r),
                                    color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    if (!isLoading)
                      _stories.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: 200.h,
                              width: double.infinity,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: _stories.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return 6.horizontalSpace;
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  StroyModel story = _stories[index];
                                  return HomeStoryWidget(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StoriesPageView(
                                              stories: _stories,
                                              initialIndex: index,
                                            ),
                                          )).then((value) {
                                        if (value == true) {
                                          getStories();
                                        }
                                      });
                                    },
                                    story: story,
                                  );
                                },
                              ),
                            ),
                    12.verticalSpace,
                    HomeMakePostWidget(onPostCreated: () {
                      getPostsList();
                    }),
                    12.verticalSpace,
                    if (isPostsLoading) const PostShimmer(isHome: true),
                    if (!isPostsLoading)
                      _posts.isEmpty
                          ? SizedBox(
                              height: 300.h,
                              child: Center(
                                child: Text(
                                  "لا توجد منشورات...",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                        color: kTextColor,
                                      ),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _posts.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return 10.verticalSpace;
                              },
                              itemBuilder: (BuildContext context, int index) {
                                PostModel post = _posts[index];
                                return post.postTypeInfo != null
                                    ? SharedPostWidget(
                                        canShowProfile: true,
                                        post: post,
                                        hasChanged: () {
                                          _posts.clear();
                                          postsPagination.currentPage = 0;
                                          getPostsList();
                                        },
                                      )
                                    : post.postTypeInfoProduct != null
                                        ? SharedProductWidget(
                                            canShowProfile: true,
                                            post: post,
                                            hasChanged: () {
                                              _posts.clear();
                                              postsPagination.currentPage = 0;
                                              getPostsList();
                                            },
                                          )
                                        : post.postTypeInfoStore != null
                                            ? SharedStoreWidget(
                                                canShowProfile: true,
                                                post: post,
                                                hasChanged: () {
                                                  _posts.clear();
                                                  postsPagination.currentPage =
                                                      0;
                                                  getPostsList();
                                                })
                                            : PostWidget(
                                                canShowProfile: true,
                                                hasChanged: () {
                                                  _posts.clear();
                                                  postsPagination.currentPage =
                                                      0;
                                                  getPostsList();
                                                },
                                                post: post,
                                              );
                              },
                            ),
                    // 100.verticalSpace,
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: paginateLoading
                            ? const CircularProgressIndicator(
                                color: kBleuColor,
                              )
                            : const SizedBox(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
