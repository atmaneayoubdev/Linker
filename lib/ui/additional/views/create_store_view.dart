import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:linker/controllers/market_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/market/category_model.dart';
import 'package:linker/ui/additional/components/store_activiy_item_widget.dart';
import 'package:linker/ui/additional/views/subscription_view.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';

class CreateStoreView extends StatefulWidget {
  const CreateStoreView({super.key});

  @override
  State<CreateStoreView> createState() => _CreateStoreViewState();
}

class _CreateStoreViewState extends State<CreateStoreView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController storeNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController registerNumberController = TextEditingController();
  TextEditingController registerDateController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  bool isSeller = true;
  bool isCompany = true;
  bool agreeOnTerms = false;
  String finalPhone = '';

  List<MarketCategoryModel> _categories = [];
  final List<MarketCategoryModel> _selectedCategories = [];

  Future getCategories() async {
    await MarketController.getCategories(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storeId: '',
    ).then((value) {
      _categories = value;
      setState(() {});
    });
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

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
                    color: Colors.white,
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
                              "إنشاء واجهة تسويقية",
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
                          color: const Color.fromARGB(255, 251, 251, 251),
                          padding: EdgeInsets.symmetric(
                            vertical: 15.h,
                            horizontal: 13.w,
                          ),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  22.verticalSpace,
                                  TextFormField(
                                    style: GoogleFonts.tajawal(
                                        fontSize: 16.sp,
                                        color: kTextColor,
                                        fontWeight: FontWeight.normal),
                                    controller: fullNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال الاسم الكامل لمتجرك';
                                      }
                                      return null;
                                    },
                                    decoration: formFieldDecoration!.copyWith(
                                      label: Text(
                                        'اسم التاجر كاملا',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace,
                                  TextFormField(
                                    style: GoogleFonts.tajawal(
                                        fontSize: 16.sp,
                                        color: kTextColor,
                                        fontWeight: FontWeight.normal),
                                    controller: storeNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال اسم متجرك';
                                      }
                                      return null;
                                    },
                                    decoration: formFieldDecoration!.copyWith(
                                      label: Text(
                                        'اسم المتجر',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace,
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: IntlPhoneField(
                                      controller: phoneController,
                                      decoration: formFieldDecoration!,
                                      initialCountryCode: 'SA',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      dropdownTextStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      keyboardType: TextInputType.phone,
                                      showDropdownIcon: true,
                                      dropdownIconPosition:
                                          IconPosition.leading,
                                      disableLengthCheck: true,
                                      dropdownIcon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.transparent,
                                        size: 10,
                                      ),
                                      onChanged: (value) {
                                        var temp =
                                            value.countryCode + value.number;
                                        finalPhone = temp.replaceFirst("+", "");
                                      },
                                      onCountryChanged: (value) {
                                        finalPhone = '';

                                        phoneController.clear();
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        String pattern = r'[0-9]';
                                        RegExp regExp = RegExp(pattern);

                                        if (value == null ||
                                            value.number.isEmpty ||
                                            !regExp.hasMatch(value.number)) {
                                          return 'الرجاء إدخال رقم الهاتف';
                                        }
                                        if (value.number.length != 9) {
                                          return 'الرجاء إدخال رقم الهاتف';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                  20.verticalSpace,
                                  TextFormField(
                                    style: GoogleFonts.tajawal(
                                        fontSize: 16.sp,
                                        color: kTextColor,
                                        fontWeight: FontWeight.normal),
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'رجاءا أدخل بريدك الإلكتروني';
                                      }
                                      return null;
                                    },
                                    decoration: formFieldDecoration!.copyWith(
                                      label: Text(
                                        'البريد الالكتروني ',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace,
                                  // TextFormField(
                                  //   style: GoogleFonts.tajawal(
                                  //       fontSize: 16.sp,
                                  //       color: kTextColor,
                                  //       fontWeight: FontWeight.normal),
                                  //   controller: registerNumberController,
                                  //   validator: (value) {
                                  //     if (value == null || value.isEmpty) {
                                  //       return 'Please enter the register number';
                                  //     }
                                  //     return null;
                                  //   },
                                  //   decoration: formFieldDecoration!.copyWith(
                                  //     label: Text(
                                  //       ' وثيقة العمل الحر / رقم السجل التجاري',
                                  //       textAlign: TextAlign.center,
                                  //       style:
                                  //           Theme.of(context).textTheme.titleMedium,
                                  //     ),
                                  //   ),
                                  // ),
                                  //20.verticalSpace,
                                  // TextFormField(
                                  //   style: GoogleFonts.tajawal(
                                  //       fontSize: 16.sp,
                                  //       color: kTextColor,
                                  //       fontWeight: FontWeight.normal),
                                  //   controller: registerDateController,
                                  //   validator: (value) {
                                  //     if (value == null || value.isEmpty) {
                                  //       return 'Please enter the register date';
                                  //     }
                                  //     return null;
                                  //   },
                                  //   decoration: formFieldDecoration!.copyWith(
                                  //     label: Text(
                                  //       'تاريخ انتهاء السجل التجاري / وثيقة العمل الحر',
                                  //       textAlign: TextAlign.center,
                                  //       style:
                                  //           Theme.of(context).textTheme.titleMedium,
                                  //     ),
                                  //   ),
                                  // ),
                                  //20.verticalSpace,

                                  //20.verticalSpace,
                                  Text(
                                    'ترخيص المتجر',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  20.verticalSpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isCompany = true;
                                          });
                                        },
                                        child: Container(
                                          width: 117.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14.r,
                                            ),
                                            color: !isCompany
                                                ? const Color.fromRGBO(
                                                    249, 250, 252, 1)
                                                : kDarkColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'سجل تجاري',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .apply(
                                                      color: isCompany
                                                          ? Colors.white
                                                          : kDarkColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isCompany = false;
                                          });
                                        },
                                        child: Container(
                                          width: 117.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14.r,
                                            ),
                                            color: isCompany
                                                ? const Color.fromRGBO(
                                                    249, 250, 252, 1)
                                                : kDarkColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'وثيقة عمل حر',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .apply(
                                                    color: isCompany
                                                        ? kDarkColor
                                                        : Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  20.verticalSpace,
                                  Text(
                                    'تخصص المتجر',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  20.verticalSpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isSeller = true;
                                          });
                                        },
                                        child: Container(
                                          width: 117.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14.r,
                                            ),
                                            color: !isSeller
                                                ? const Color.fromRGBO(
                                                    249, 250, 252, 1)
                                                : kDarkColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'ورشة عمل',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .apply(
                                                      color: isSeller
                                                          ? Colors.white
                                                          : kDarkColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isSeller = false;
                                          });
                                        },
                                        child: Container(
                                          width: 117.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14.r,
                                            ),
                                            color: isSeller
                                                ? const Color.fromRGBO(
                                                    249, 250, 252, 1)
                                                : kDarkColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'بيع تجزئة',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .apply(
                                                      color: isSeller
                                                          ? kDarkColor
                                                          : Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  20.verticalSpace,
                                  // DottedBorder(
                                  //   radius: Radius.circular(14.r),
                                  //   borderType: BorderType.RRect,
                                  //   color: kDarkColor,
                                  //   // borderPadding: EdgeInsets.zero,
                                  //   // padding: EdgeInsets.zero,
                                  //   strokeWidth: 0.5,
                                  //   dashPattern: const [7, 7],
                                  //   child: Container(
                                  //     height: 150.h,
                                  //     decoration: const BoxDecoration(
                                  //       color: Color.fromRGBO(249, 250, 252, 1),
                                  //     ),
                                  //     child: Center(
                                  //       child: Column(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: [
                                  //           SvgPicture.asset(
                                  //             'assets/icons/upload_file.svg',
                                  //             height: 47.h,
                                  //             width: 62.w,
                                  //           ),
                                  //           20.verticalSpace,
                                  //           Text(
                                  //             'وثيقة العمل الحر / رفع السجل التجاري',
                                  //             style: Theme.of(context)
                                  //                 .textTheme
                                  //                 .bodyLarge,
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  //20.verticalSpace,
                                  Text(
                                    'نشاط المتجر',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  20.verticalSpace,
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(14.r)),
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: _categories.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w),
                                          child: const Divider(
                                            color: Colors.black12,
                                          ),
                                        );
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        MarketCategoryModel cat =
                                            _categories[index];
                                        return StoreActiviyItemWidget(
                                          category: cat,
                                          isSelected:
                                              _selectedCategories.contains(cat),
                                          onPress: () {
                                            _selectedCategories.contains(cat)
                                                ? _selectedCategories
                                                    .remove(cat)
                                                : _selectedCategories.add(cat);
                                            setState(() {});
                                            log(_selectedCategories.length
                                                .toString());
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  32.verticalSpace,
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            agreeOnTerms = !agreeOnTerms;
                                          });
                                        }),
                                        child: Container(
                                          height: 23.h,
                                          width: 23.w,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: kBleuColor,
                                                width: 1.h,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6.r)),
                                          child: FittedBox(
                                              child: Icon(
                                            Icons.check,
                                            color: agreeOnTerms
                                                ? kBleuColor
                                                : Colors.transparent,
                                          )),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        'الموافقه علي الشروط والاحكام',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .apply(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: kTextColor),
                                      ),
                                    ],
                                  ),
                                  32.verticalSpace,
                                  GestureDetector(
                                    onTap: () {
                                      if (_formKey.currentState!.validate() &&
                                          _selectedCategories.isNotEmpty &&
                                          agreeOnTerms) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SubscriptionView(
                                              categories: _selectedCategories,
                                              email: emailController.text,
                                              fullStoreName:
                                                  fullNameController.text,
                                              phone: phoneController.text,
                                              storeName:
                                                  storeNameController.text,
                                              storeSpecialty: isSeller
                                                  ? "retail"
                                                  : "workshops",
                                              storeType: isCompany
                                                  ? "company"
                                                  : "personal",
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: const LargeButton(
                                        text: 'استمرار', isButton: true),
                                  ),
                                ],
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
      ),
    );
  }
}
