import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/ui/additional/components/user_list_item_shimmer.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:provider/provider.dart';
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
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 77.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 23.h),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(247, 249, 250, 1),
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
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return RefreshIndicator(
                      displacement: 0,
                      onRefresh: () async {
                        getFollowers();
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: isLoading
                              ? const UserItemShimmer()
                              : ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.h,
                                  ),
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
