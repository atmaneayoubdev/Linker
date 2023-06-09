import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/ui/landing_view.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../models/auth/user_model.dart';
import '../../notifications/views/notifiactions_view.dart';

class HomeSliverAppBar extends StatelessWidget implements PreferredSize {
  const HomeSliverAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // this will hide Drawer hamburger icon

      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      shadowColor: const Color.fromARGB(57, 0, 0, 0),
      // floating: true,
      // snap: true,
      // elevation: 0,
      // expandedHeight: 80.h,
      toolbarHeight: 80.h,
      titleSpacing: 25.w,
      elevation: 3,

      title: SizedBox(
        height: 45.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    LandingView.akey.currentState!.openDrawer();
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    //padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kLightBlackColor, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: CachedNetworkImage(
                        imageUrl:
                            Provider.of<UserProvider>(context, listen: true)
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
                10.horizontalSpace,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "أهلاً بعودتك",
                      style: Theme.of(context).textTheme.bodySmall!.apply(
                            color: kLightBlackColor,
                          ),
                    ),
                    Text(
                      Provider.of<UserProvider>(context, listen: true)
                          .user
                          .userName,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                )
              ],
            ),
            badges.Badge(
              position: badges.BadgePosition.topStart(),
              badgeContent: Padding(
                padding: const EdgeInsets.all(2),
                child: Center(
                  child: Consumer<UserProvider>(
                      builder: (context, userprovider, _) => Text(
                            userprovider.user.notifications,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: Colors.white),
                          )),
                ),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: kBleuColor,
                borderSide: BorderSide(color: Colors.white, width: 0.5),
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsView(),
                    ),
                  ).then((value) async {
                    await MyProfileController.deleteAllNotification(
                      deviceToken:
                          Provider.of<MessagingProvider>(context, listen: false)
                              .deviceToken,
                      token: Provider.of<UserProvider>(context, listen: false)
                          .user
                          .apiToken,
                    ).then((value) async {
                      if (value == "0") {
                        debugPrint("I am here");
                        final prefs = await SharedPreferences.getInstance();

                        await MyProfileController.getMyProfile(
                                // ignore: use_build_context_synchronously
                                deviceToken: Provider.of<MessagingProvider>(
                                        context,
                                        listen: false)
                                    .deviceToken,
                                token: prefs.getString('api_token')!)
                            .then((value) {
                          if (value.runtimeType == User) {
                            Provider.of<UserProvider>(context, listen: false)
                                .setUser(value);
                          }
                        });
                      }
                    });
                  });
                },
                child: Center(
                  child: Container(
                    height: 30.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(88, 68, 166, 212),
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/bell.svg',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget get child => throw UnimplementedError();
}
