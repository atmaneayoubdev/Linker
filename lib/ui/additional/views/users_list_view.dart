import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/ui/additional/components/user_list_item_shimmer.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:provider/provider.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../home/components/user_list_item_widget.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key, required this.title});
  final String title;

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  List<OtherUser> _users = [];
  bool isLoading = false;

  Future getFollowers() async {
    isLoading = true;
    setState(() {});
    await MyProfileController.getFollowers(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      type: widget.title == "المتصلون" ? "get-followers" : "get-following",
    ).then((value) {
      _users = value;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    getFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          76.verticalSpace,
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              // padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(248, 248, 248, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38.r),
                  topRight: Radius.circular(38.r),
                ),
              ),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                //padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38.r),
                    topRight: Radius.circular(38.r),
                  ),
                  color: const Color.fromRGBO(250, 250, 250, 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 77,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 23.h),
                      decoration: BoxDecoration(
                        color: klighSkyBleu,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(38.r),
                            topRight: Radius.circular(38.r)),
                      ),
                      child: Stack(children: [
                        Center(
                          child: Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: BackButtonWidget(),
                        )
                      ]),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: const Color.fromRGBO(250, 250, 250, 1),
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          //horizontal: 13.w,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: isLoading
                                ? const UserItemShimmer()
                                : ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: _users.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return 11.verticalSpace;
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      OtherUser user = _users[index];
                                      return UserListItemWidget(
                                        user: user,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
