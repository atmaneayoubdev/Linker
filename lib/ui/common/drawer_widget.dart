import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/additional/views/create_store_view.dart';
import 'package:linker/ui/additional/views/profile_view.dart';
import 'package:linker/ui/settings/views/settings_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/auth_controller.dart';
import '../../helpers/messaging_provider.dart';
import '../../helpers/user_provider.dart';
import '../auth/views/fields_and_interesrets_view.dart';
import '../auth/views/signin_view.dart';
import '../settings/views/account_settings_view.dart';
import 'loading_widget.dart';

class DrawerWIdget extends StatefulWidget {
  const DrawerWIdget({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerWIdget> createState() => _DrawerWIdgetState();
}

class _DrawerWIdgetState extends State<DrawerWIdget> {
  bool isLoading = false;

  Future deleteUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: 30.h),
        width: 300.w,
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(38.r),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 45.h,
                      width: 45.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: kDarkColor, width: 0.5),
                          shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        'assets/icons/back_button.svg',
                        height: 45.h,
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileView(isMyProfile: true),
                  ),
                );
              },
              child: Container(
                height: 103.h,
                width: 103.w,
                //padding: const EdgeInsets.all(1),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(211, 211, 211, 1)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: CachedNetworkImage(
                    imageUrl: Provider.of<UserProvider>(context, listen: true)
                        .user
                        .avatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
            5.verticalSpace,
            Text(
              Provider.of<UserProvider>(context, listen: false).user.userName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              Provider.of<UserProvider>(context, listen: false).user.jobTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .apply(color: kLightBlackColor),
            ),
            21.verticalSpace,
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileView(isMyProfile: true),
                  ),
                );
              },
              child: Text(
                'عرض الملف الشخصي',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            21.verticalSpace,
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const AccountSettingsView())));
              },
              child: Container(
                height: 50.h,
                width: 274.w,
                //padding: const EdgeInsets.all(1),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(252, 252, 252, 1),
                  borderRadius: BorderRadius.circular(35.r),
                  border: Border.all(
                      width: 0.5,
                      color: const Color.fromRGBO(112, 112, 112, 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: SvgPicture.asset('assets/icons/contact.svg')),
                    10.horizontalSpace,
                    Text(
                      'حسابي',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            9.verticalSpace,
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) =>
                      const FieldsAndInterestView(isFromDrawer: true)))),
              child: Container(
                height: 50.h,
                width: 274.w,
                //padding: const EdgeInsets.all(1),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(252, 252, 252, 1),
                  borderRadius: BorderRadius.circular(35.r),
                  border: Border.all(
                      width: 0.5,
                      color: const Color.fromRGBO(112, 112, 112, 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: SvgPicture.asset('assets/icons/interest.svg')),
                    10.horizontalSpace,
                    Text(
                      'المدارات المختارة سابقاً',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            9.verticalSpace,
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const SettingsView())));
              },
              child: Container(
                height: 50.h,
                width: 274.w,
                //padding: const EdgeInsets.all(1),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(252, 252, 252, 1),
                  borderRadius: BorderRadius.circular(35.r),
                  border: Border.all(
                      width: 0.5,
                      color: const Color.fromRGBO(112, 112, 112, 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: SvgPicture.asset('assets/icons/settings.svg')),
                    10.horizontalSpace,
                    Text(
                      'الإعدادات',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            9.verticalSpace,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const CreateStoreView()),
                  ),
                );
              },
              child: Container(
                height: 50.h,
                width: 274.w,
                //padding: const EdgeInsets.all(1),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(252, 252, 252, 1),
                  borderRadius: BorderRadius.circular(35.r),
                  border: Border.all(
                      width: 0.5,
                      color: const Color.fromRGBO(112, 112, 112, 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child:
                            SvgPicture.asset('assets/icons/create_store.svg')),
                    10.horizontalSpace,
                    Text(
                      "إنشاء واجهة تسويقية",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                isLoading = true;
                setState(() {});
                // Provider.of<MessagingProvider>(context, listen: false)
                //     .deleteToken();
                await AuthController.logout(
                  deviceToken:
                      Provider.of<MessagingProvider>(context, listen: false)
                          .deviceToken,
                  token: Provider.of<UserProvider>(context, listen: false)
                      .user
                      .apiToken,
                ).then((value) async {
                  setState(() {
                    isLoading = false;
                  });
                  if (value == "تم تسجيل الخروج بنجاح") {
                    debugPrint(value);
                    Provider.of<UserProvider>(context, listen: false)
                        .clearUser();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInView()),
                        (route) => false);
                  } else {
                    deleteUserFromPrefs();
                    Provider.of<UserProvider>(context, listen: false)
                        .clearUser();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInView()),
                        (route) => false);
                  }
                });
              },
              child: isLoading
                  ? LoadingWidget(color: Colors.red, size: 40.h)
                  : Container(
                      height: 65.h,
                      width: 65.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Center(
                          child: SvgPicture.asset('assets/icons/logout.svg')),
                    ),
            ),
            9.verticalSpace,
            Text(
              'تسجيل خروج',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
