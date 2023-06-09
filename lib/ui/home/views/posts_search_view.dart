import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';
import '../../../models/general/pagination.dart';
import '../../../models/post/post_model.dart';
import '../../additional/components/post_widget.dart';
import '../../additional/components/shared_post_widget.dart';
import '../../additional/components/shared_product_widget.dart';
import '../../additional/components/shared_store_widget.dart';
import '../../common/loading_widget.dart';

class PostsSearchView extends StatefulWidget {
  const PostsSearchView({
    super.key,
    required this.posts,
    required this.getMorePosts,
    required this.postsPagination,
    required this.getNewSearch,
    required this.isPaginating,
    required this.isLoading,
  });
  final List<PostModel> posts;
  final Function getMorePosts;
  final Pagination postsPagination;
  final Function getNewSearch;
  final bool isPaginating;
  final bool isLoading;

  @override
  State<PostsSearchView> createState() => _PostsSearchViewState();
}

class _PostsSearchViewState extends State<PostsSearchView> {
  late ScrollController _controller;

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent * 1.00 &&
        !_controller.position.outOfRange) {
      debugPrint(
          "The current posts page is: ${widget.postsPagination.currentPage}");
      debugPrint(
          "The total of pages in posts is : ${widget.postsPagination.lastPage}");
      if (widget.postsPagination.currentPage <
          widget.postsPagination.lastPage) {
        widget.getMorePosts();
      }
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    //Focus.of(context).unfocus();
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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: widget.isLoading
                    ? Container(
                        color: Colors.white,
                        child: const Center(
                          child: LoadingWidget(color: kDarkColor, size: 45),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(23.r)),
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              12.verticalSpace,
                              widget.posts.isEmpty
                                  ? SizedBox(
                                      height: 600.h,
                                      child: Center(
                                        child: Text(
                                          "لا توجد منشورات",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: widget.posts.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return 10.verticalSpace;
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        PostModel post = widget.posts[index];
                                        return post.postTypeInfo != null
                                            ? SharedPostWidget(
                                                canShowProfile: true,
                                                post: post,
                                                hasChanged: () {
                                                  widget.getNewSearch();
                                                },
                                              )
                                            : post.postTypeInfoProduct != null
                                                ? SharedProductWidget(
                                                    canShowProfile: true,
                                                    post: post,
                                                    hasChanged: () {
                                                      widget.getNewSearch();
                                                    },
                                                  )
                                                : post.postTypeInfoStore != null
                                                    ? SharedStoreWidget(
                                                        canShowProfile: true,
                                                        post: post,
                                                        hasChanged: () {
                                                          widget.getNewSearch();
                                                        })
                                                    : PostWidget(
                                                        canShowProfile: true,
                                                        hasChanged: () {
                                                          widget.posts.clear();
                                                          widget.getNewSearch();
                                                        },
                                                        post: post,
                                                      );
                                      },
                                    ),
                              10.verticalSpace,
                              if (widget.isPaginating)
                                const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: kBleuColor,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
