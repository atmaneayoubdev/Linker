import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linker/controllers/market_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/market/category_model.dart';
import 'package:linker/models/market/plan_model.dart';
import 'package:linker/ui/additional/components/plan_info_shimmer.dart';
import 'package:linker/ui/additional/components/plan_shimmer_widget.dart';
import 'package:linker/ui/additional/components/subscription_options_item_widget.dart';
import 'package:linker/ui/auth/views/otp_verification_view.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../../common/loading_widget.dart';
import '../components/subscription_item_widget.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView(
      {super.key,
      required this.fullStoreName,
      required this.storeName,
      required this.phone,
      required this.email,
      required this.storeType,
      required this.storeSpecialty,
      required this.categories});
  final String fullStoreName;
  final String storeName;
  final String phone;
  final String email;
  final String storeType;
  final String storeSpecialty;
  final List<MarketCategoryModel> categories;

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  List<PlanModel> _plans = [];
  bool isLoading = true;
  bool isSending = false;
  PlanModel _selectedPlan =
      PlanModel(id: '', days: '', price: '', information: [], name: '');

  Future getPlans() async {
    setState(() {
      isLoading = true;
    });
    await MarketController.getPlans(
            deviceToken: Provider.of<MessagingProvider>(context, listen: false)
                .deviceToken,
            token:
                Provider.of<UserProvider>(context, listen: false).user.apiToken)
        .then((value) {
      setState(() {
        _plans = value;
        _selectedPlan = _plans.first;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkColor,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              76.verticalSpace,
              Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 10.w,
                    right: 10.w,
                    left: 10.w,
                  ),
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
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150.h,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(38.r),
                                topRight: Radius.circular(38.r)),
                            color: klighSkyBleu,
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BackButtonWidget(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 13.w,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  50.verticalSpace,
                                  isLoading
                                      ? const PlanShimmer()
                                      : ListView.separated(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: _plans.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return 8.verticalSpace;
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            PlanModel plan = _plans[index];
                                            return SubscriptionItemWidget(
                                              isSelected: _selectedPlan == plan,
                                              onPress: () {
                                                setState(() {
                                                  _selectedPlan = plan;
                                                });
                                              },
                                              plan: plan,
                                            );
                                          },
                                        ),
                                  12.verticalSpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'مميزات الباقة',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .apply(color: kBleuColor),
                                      ),
                                    ],
                                  ),
                                  10.verticalSpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 67.w,
                                          height: 1.h,
                                          child: const Divider(
                                            color: kLightBlackColor,
                                          )),
                                    ],
                                  ),
                                  13.verticalSpace,
                                  isLoading
                                      ? const PlanInfoShimmer()
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              _selectedPlan.information.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return 11.verticalSpace;
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return SubscriptionOpitonsItemWidget(
                                              name: _selectedPlan
                                                  .information[index],
                                            );
                                          },
                                        ),
                                  // const Spacer(),
                                  20.verticalSpace,
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isSending = true;
                                      });
                                      await MarketController.createStore(
                                        deviceToken:
                                            Provider.of<MessagingProvider>(
                                                    context,
                                                    listen: false)
                                                .deviceToken,
                                        token: Provider.of<UserProvider>(
                                          context,
                                          listen: false,
                                        ).user.apiToken,
                                        categories: widget.categories,
                                        email: widget.email,
                                        fullName: widget.fullStoreName,
                                        phone: widget.phone,
                                        type: widget.storeSpecialty,
                                        planId: _selectedPlan.id,
                                        storeType: widget.storeType,
                                        storename: widget.storeName,
                                      ).then((value) {
                                        setState(() {
                                          isSending = false;
                                        });
                                        if (value.length == 4) {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //         backgroundColor: kDarkColor,
                                          //         content: Text(
                                          //           value.toString(),
                                          //           style: Theme.of(context)
                                          //               .textTheme
                                          //               .bodySmall!
                                          //               .apply(
                                          //                   color:
                                          //                       Colors.white),
                                          //         )));
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: ((context) =>
                                                  const OtpVerificationView(
                                                    isCreatingStroe: true,
                                                  )),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                value,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .apply(color: Colors.white),
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: isSending
                                        ? LoadingWidget(
                                            color: kDarkColor, size: 40.h)
                                        : const LargeButton(
                                            text: 'تسجيل',
                                            isButton: false,
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
          Column(
            children: [
              200.verticalSpace,
              Container(
                height: 65.h,
                width: 200.w,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 5,
                        spreadRadius: 5,
                        color: Color.fromARGB(5, 0, 0, 0),
                      )
                    ]),
                child: Center(
                  child: Text(
                    'نوع الباقة',
                    style: GoogleFonts.almaraiTextTheme().titleMedium,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
