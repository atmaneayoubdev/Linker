import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';
import '../../../models/auth/other_user_model.dart';
import '../../../models/general/pagination.dart';
import '../../common/loading_widget.dart';
import '../components/user_list_item_widget.dart';

class UsersSearchView extends StatefulWidget {
  const UsersSearchView(
      {super.key,
      required this.users,
      required this.getMoreUsers,
      required this.usersPagination,
      required this.isPaginating,
      required this.isLoading});
  final List<OtherUser> users;
  final Function getMoreUsers;
  final Pagination usersPagination;
  final bool isPaginating;
  final bool isLoading;

  @override
  State<UsersSearchView> createState() => _UsersSearchViewState();
}

class _UsersSearchViewState extends State<UsersSearchView> {
  late ScrollController _userScrollController;

  void _userScrollListner() {
    if (_userScrollController.offset >=
            _userScrollController.position.maxScrollExtent * 1.00 &&
        !_userScrollController.position.outOfRange) {
      debugPrint(
          "The current users page is: ${widget.usersPagination.currentPage}");
      debugPrint(
          "The total of pages in users is : ${widget.usersPagination.lastPage}");

      if (widget.usersPagination.currentPage <
          widget.usersPagination.lastPage) {
        widget.getMoreUsers();
      }
    }
  }

  @override
  void initState() {
    _userScrollController = ScrollController();
    _userScrollController.addListener(_userScrollListner);
    super.initState();
  }

  @override
  void dispose() {
    _userScrollController.removeListener(_userScrollListner);
    _userScrollController.dispose();
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
                          controller: _userScrollController,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              12.verticalSpace,
                              widget.users.isEmpty
                                  ? SizedBox(
                                      height: 600.h,
                                      child: Center(
                                        child: Text(
                                          "لا يوجد مستخدمون",
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
                                      itemCount: widget.users.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return 10.verticalSpace;
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        OtherUser user = widget.users[index];
                                        return UserListItemWidget(
                                          user: user,
                                        );
                                      },
                                    ),
                              10.verticalSpace,
                              if (widget.isPaginating)
                                SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: widget.isPaginating
                                        ? const CircularProgressIndicator(
                                            color: kBleuColor,
                                          )
                                        : const SizedBox(),
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
