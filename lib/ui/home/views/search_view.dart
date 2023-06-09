import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/general/search_model.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/home/views/posts_search_view.dart';
import 'package:linker/ui/home/views/users_search_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/global_contoller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../../models/auth/other_user_model.dart';
import '../../../models/general/pagination.dart';
import '../../../models/post/post_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({
    super.key,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  Pagination postsPagination =
      Pagination(currentPage: 0, lastPage: 0, perPage: 0, total: 0);
  Pagination userPagination =
      Pagination(currentPage: 0, lastPage: 0, perPage: 0, total: 0);
  final List<PostModel> _posts = [];
  final List<OtherUser> _users = [];

  // late ScrollController _controller;
  // late ScrollController _userScrollController;

  bool paginateLoading = false;
  bool usersPaginateLoading = false;

  Future getNewSearch(String text) async {
    _focusNode.unfocus();
    postsPagination =
        Pagination(currentPage: 0, lastPage: 0, perPage: 0, total: 0);
    userPagination =
        Pagination(currentPage: 0, lastPage: 0, perPage: 0, total: 0);
    _posts.clear();
    _users.clear();
    setState(() {
      isLoading = true;
    });
    await GlobalController.getSearch(
            deviceToken: Provider.of<MessagingProvider>(context, listen: false)
                .deviceToken,
            token:
                Provider.of<UserProvider>(context, listen: false).user.apiToken,
            text: text,
            usersPage: userPagination.currentPage + 1,
            postsPage: postsPagination.currentPage + 1,
            isPosts: true)
        .then((value) {
      setState(() {
        SearchModel searchModel = value["results"];
        postsPagination = value["postsPaginate"];
        userPagination = value["usersPaginate"];
        _posts.addAll(searchModel.posts);
        _users.addAll(searchModel.users);
        isLoading = false;
      });
    });
  }

  Future getPaginatedSearch(String text, bool isP) async {
    _focusNode.unfocus();
    setState(() {
      isP ? paginateLoading = true : usersPaginateLoading = true;
    });
    await GlobalController.getSearch(
      isPosts: isP,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      text: text,
      usersPage:
          !isP ? userPagination.currentPage + 1 : userPagination.currentPage,
      postsPage:
          isP ? postsPagination.currentPage + 1 : postsPagination.currentPage,
    ).then((value) {
      setState(() {
        SearchModel searchModel = value["results"];
        postsPagination = value["postsPaginate"];
        userPagination = value["usersPaginate"];
        isP
            ? _posts.addAll(searchModel.posts)
            : _users.addAll(searchModel.users);
        paginateLoading = false;
        usersPaginateLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          //toolbarHeight: 100.h,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
          leading: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            //height: 60.h,
            //margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                const BackButtonWidget(),
                5.horizontalSpace,
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _focusNode,
                    style: Theme.of(context).textTheme.titleMedium,
                    controller: searchController,
                    scrollPadding: EdgeInsets.zero,
                    maxLines: 1,
                    onEditingComplete: () {
                      getNewSearch(searchController.text);
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {}
                    },
                    decoration: formFieldDecoration!.copyWith(
                      isDense: true,
                      hintStyle: Theme.of(context).textTheme.titleMedium,
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
              ],
            ),
          ),
          leadingWidth: double.infinity,

          bottom: TabBar(
              isScrollable: true,
              indicatorColor: kDarkColor,
              indicatorPadding: const EdgeInsets.all(2),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 5.h,
              padding: EdgeInsets.zero,
              enableFeedback: false,
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return states.contains(MaterialState.focused)
                      ? null
                      : Colors.transparent;
                },
              ),
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelColor: kDarkColor,
              tabs: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: const Center(
                    child: Tab(
                      text: 'المنشورات',
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: const Center(
                    child: Tab(
                      text: 'المستخدمين',
                    ),
                  ),
                ),
              ]),
        ),
        body: TabBarView(children: [
          PostsSearchView(
            isLoading: isLoading,
            getMorePosts: () {
              getPaginatedSearch(searchController.text, true);
            },
            getNewSearch: () {
              getNewSearch(searchController.text);
            },
            isPaginating: paginateLoading,
            posts: _posts,
            postsPagination: postsPagination,
          ),
          UsersSearchView(
            isLoading: isLoading,
            isPaginating: usersPaginateLoading,
            usersPagination: userPagination,
            users: _users,
            getMoreUsers: () {
              getPaginatedSearch(searchController.text, false);
            },
          )
          // Container(
          //   color: Colors.red,
          // ),
          // Container(
          //   color: Colors.red,
          // )
        ]),
      ),
    );
  }
}
