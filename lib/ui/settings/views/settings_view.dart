import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/settings/views/privacy_policy_view.dart';

import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/settings/views/support_view.dart';
import 'package:linker/ui/settings/views/terms_and_conditions_view.dart';

import '../components/settings_item_widget.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: SafeArea(
        child: Column(
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
                              'الاعدادات',
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
                            horizontal: 13.w,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.of(context).push(MaterialPageRoute(
                                //         builder: ((context) =>
                                //             const AccountSettingsView())));
                                //   },
                                //   child: const SettingsItemWidget(
                                //     svg: 'assets/icons/contact.svg',
                                //     title: 'إعدادات حسابي',
                                //   ),
                                // ),
                                //12.verticalSpace,
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const SupportView())));
                                  },
                                  child: const SettingsItemWidget(
                                    isMenue: false,
                                    svg: 'assets/icons/support.svg',
                                    title: 'المساعدة والدعم',
                                  ),
                                ),
                                12.verticalSpace,
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const PrivacyPolicyView())));
                                  },
                                  child: const SettingsItemWidget(
                                      isMenue: false,
                                      svg: 'assets/icons/privacy.svg',
                                      title: 'سياسة الخصوصية'),
                                ),
                                12.verticalSpace,
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: ((context) =>
                                            const TermsAndConditionsView())));
                                  },
                                  child: const SettingsItemWidget(
                                      isMenue: false,
                                      svg: 'assets/icons/terms.svg',
                                      title: 'الشروط والأحكام'),
                                ),
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
      ),
    );
  }
}
