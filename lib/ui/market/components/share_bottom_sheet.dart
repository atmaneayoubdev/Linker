import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/common/loading_widget.dart';
import 'package:linker/ui/market/components/share_user_item_widget.dart';
import 'package:provider/provider.dart';

import '../../../controllers/my_profile_controller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../../models/auth/other_user_model.dart';

class ShareBottomSheet extends StatefulWidget {
  const ShareBottomSheet({
    Key? key,
    required this.id,
    required this.type,
  }) : super(key: key);
  final String id;
  final String type;

  @override
  State<ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  double height = 320.h;
  List<OtherUser> _users = [];
  bool isSending = false;
  bool loading = false;

  Future getFollowers() async {
    setState(() {
      loading = true;
    });
    await MyProfileController.getFollowers(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      type: "get-following",
    ).then((value) {
      _users = value;
      loading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    if (widget.type == 'store') {
      height = 300.h;
    }
    getFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 26.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(38.r),
          topRight: Radius.circular(38.r),
        ),
      ),
      child: isSending
          ? loading
              ? const Center(
                  child: LoadingWidget(color: kDarkColor, size: 30),
                )
              : _users.isEmpty
                  ? Center(
                      child: Text(
                        'لا يوجد مستخدمين لعرضهم',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _users.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return 11.verticalSpace;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        OtherUser user = _users[index];
                        return ShareUserItemWidget(
                          user: user,
                          id: widget.id,
                          type: widget.type,
                        );
                      },
                    )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 5.h,
                  width: 54.w,
                  color: const Color.fromRGBO(2, 51, 128, 0.06),
                ),
                28.verticalSpace,
                Text(
                  'مشاركة',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                26.verticalSpace,
                if (widget.type != 'store')
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        height = 800.h;
                        isSending = true;
                      });
                    },
                    child: Container(
                      height: 60.h,
                      width: 350.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: kGreyColor, width: 0.2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          12.horizontalSpace,
                          Container(
                            height: 32.h,
                            width: 32.w,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(19, 69, 169, 212)),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/share2.svg',
                                height: 13.h,
                              ),
                            ),
                          ),
                          12.horizontalSpace,
                          Text(
                            'المشاركة عبر الرسائل الخاصة',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                    ),
                  ),
                11.verticalSpace,
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, "public");
                  },
                  child: Container(
                    height: 60.h,
                    width: 350.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: kGreyColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        12.horizontalSpace,
                        Container(
                          height: 32.h,
                          width: 32.w,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(19, 69, 169, 212)),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/share.svg',
                              height: 13.h,
                            ),
                          ),
                        ),
                        12.horizontalSpace,
                        Text(
                          'المشاركة على صفحتي',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                ),
                30.verticalSpace,
                Container(
                  height: 5.h,
                  width: 86.w,
                  color: const Color.fromRGBO(2, 51, 128, 0.06),
                )
              ],
            ),
    );
  }
}
