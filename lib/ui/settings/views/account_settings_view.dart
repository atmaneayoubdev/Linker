import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/ui/auth/views/signin_view.dart';

import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/common/loading_widget.dart';
import 'package:linker/ui/settings/views/account_info_view.dart';
import 'package:linker/ui/settings/views/edit_password_view.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../components/settings_item_widget.dart';

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: EdgeInsets.all(10.w),
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
                                  'إعدادات حسابي',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                                horizontal: 13.w,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const AccountInfoView())));
                                      },
                                      child: const SettingsItemWidget(
                                        isMenue: false,
                                        svg: 'assets/icons/contact.svg',
                                        title: 'معلومات الحساب',
                                      ),
                                    ),
                                    12.verticalSpace,
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const EditPasswordView())));
                                      },
                                      child: const SettingsItemWidget(
                                        isMenue: false,
                                        svg: 'assets/icons/support.svg',
                                        title: 'تعديل كلمة المرور',
                                      ),
                                    ),
                                    12.verticalSpace,
                                    GestureDetector(
                                      onTap: () {
                                        showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              //title: const Text('Basic dialog title'),
                                              content: const Text(
                                                  "هل توافق على حذف حسابك نهائيا"),
                                              actions: <Widget>[
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: const Text('موافق'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: const Text('لا'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((value) async {
                                          if (value == true) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await MyProfileController.deleteAccount(
                                                    deviceToken: Provider.of<
                                                                MessagingProvider>(
                                                            context,
                                                            listen: false)
                                                        .deviceToken,
                                                    token: Provider.of<
                                                                UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .apiToken)
                                                .then((value) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              if (value ==
                                                  "لا يمكنك مسح هذا الحساب لانه متعلق بحساب تاجر") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text(
                                                          value.toString(),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .apply(
                                                                  color: Colors
                                                                      .white),
                                                        )));
                                              } else if (value ==
                                                  "تم مسح الحساب") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            kDarkColor,
                                                        content: Text(
                                                          value.toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .apply(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                        )));
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .clearUser();
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const SignInView()),
                                                        (route) => false);
                                              }
                                            });
                                          }
                                        });
                                      },
                                      child: const SettingsItemWidget(
                                        isMenue: false,
                                        svg: 'assets/icons/trash.svg',
                                        title: 'حذف الحساب',
                                      ),
                                    )
                                  ],
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
            if (isLoading)
              Container(
                color: const Color.fromARGB(48, 0, 0, 0),
                child: const Center(
                  child: LoadingWidget(color: kDarkColor, size: 40),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
