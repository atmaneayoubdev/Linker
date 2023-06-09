import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/controllers/market_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/market/category_model.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:linker/ui/market/components/enum_widget.dart';
import 'package:linker/ui/market/components/market_category_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../helpers/messaging_provider.dart';
import '../../common/loading_widget.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    Key? key,
    required this.priceRange,
    required this.selectedCategory,
    required this.slectedShowType,
    required this.selectedShowRate,
    required this.onSelectShowType,
    required this.onSelectShowRate,
    required this.onSelectCategory,
    required this.onSelectPriceRange,
  }) : super(key: key);
  final SfRangeValues priceRange;
  final MarketCategoryModel selectedCategory;
  final String slectedShowType;
  final String selectedShowRate;
  final Function(String) onSelectShowType;
  final Function(String) onSelectShowRate;
  final Function(MarketCategoryModel) onSelectCategory;
  final Function(SfRangeValues) onSelectPriceRange;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool isLoading = true;
  final List<MarketCategoryModel> _categories = [
    MarketCategoryModel(id: '', name: 'الكل')
  ];
  List<String> showTypeList = ["الكل", "الأعلى تقييماً", "مضاف حديثا"];
  List<String> showRateList = ["الكل", "الاعلي اولا", "الاقل اولا"];
  late String _selectedShowType;
  late String _selectedShowRate;
  late SfRangeValues _selectedPriceRange;
  late MarketCategoryModel _selectedCat;

  Future getCategories() async {
    setState(() {
      isLoading = true;
    });
    await MarketController.getCategories(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storeId: '',
    ).then((value) {
      _categories.addAll(value);
      _selectedCat = _categories.firstWhere(
        (element) =>
            element.name == widget.selectedCategory.name &&
            element.id == widget.selectedCategory.id,
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    _selectedShowRate = widget.selectedShowRate;
    _selectedShowType = widget.slectedShowType;
    _selectedPriceRange = widget.priceRange;
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 812.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(248, 248, 248, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(38.r),
          topRight: Radius.circular(38.r),
        ),
      ),
      child: isLoading
          ? Center(
              child: LoadingWidget(color: kDarkColor, size: 40.h),
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 85.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: klighSkyBleu,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38.r),
                    topRight: Radius.circular(38.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              height: 30.h,
                              width: 30.w,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(27, 255, 17, 0)),
                              child: Center(
                                child: SvgPicture.asset('assets/icons/x.svg'),
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Text(
                            'تصفية حسب',
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedShowType = widget.slectedShowType;
                            _selectedShowRate = widget.selectedShowRate;
                            _selectedCat = _categories.firstWhere((element) =>
                                element.name == widget.selectedCategory.name &&
                                element.id == widget.selectedCategory.id);
                            _selectedPriceRange = widget.priceRange;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 5.h),
                          decoration: BoxDecoration(
                              color: kLightOrangeColor,
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Text(
                            'استعاده',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .apply(color: kOrangeColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              15.verticalSpace,
              Expanded(
                  child: Container(
                color: Colors.white,
                child: Column(children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التقييم',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        17.verticalSpace,
                        SizedBox(
                          height: 50.h,
                          width: double.infinity,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: showRateList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return 10.horizontalSpace;
                            },
                            itemBuilder: (BuildContext context, int index) {
                              String showRate = showRateList[index];
                              return GestureDetector(
                                onTap: () {
                                  _selectedShowRate = showRate;

                                  setState(() {});
                                },
                                child: EnumWidget(
                                  isSelected: _selectedShowRate == showRate,
                                  name: showRate,
                                ),
                              );
                            },
                          ),
                        ),
                        20.verticalSpace,
                        Text(
                          'القسم',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        17.verticalSpace,
                        SizedBox(
                          height: 50.h,
                          width: double.infinity,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: _categories.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return 10.horizontalSpace;
                            },
                            itemBuilder: (BuildContext context, int index) {
                              MarketCategoryModel cat = _categories[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCat = cat;
                                  });
                                },
                                child: MarketCategoryWidget(
                                  isSelected: _selectedCat == cat,
                                  name: cat.name,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        23.verticalSpace,
                        Text(
                          'السعر',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        17.verticalSpace,
                        Row(
                          children: [
                            Text(
                              'من',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Expanded(
                              child: SfRangeSlider(
                                inactiveColor:
                                    const Color.fromRGBO(240, 240, 240, 1),
                                min: 0.0,
                                max: 100000.0,
                                stepSize: 100,
                                values: _selectedPriceRange,
                                activeColor: kBleuColor,
                                showTicks: false,
                                showLabels: false,
                                enableTooltip: false,
                                minorTicksPerInterval: 100,
                                interval: 100,
                                onChanged: (SfRangeValues values) {
                                  setState(() {
                                    _selectedPriceRange = values;
                                  });
                                },
                              ),
                            ),
                            Text(
                              'الي',
                              style: Theme.of(context).textTheme.titleMedium,
                            )
                          ],
                        ),
                        17.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '  ${(_selectedPriceRange.start).toInt()}  ر.س ',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${(_selectedPriceRange.end).toInt()}  ر.س ',
                              style: Theme.of(context).textTheme.titleMedium,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (_selectedShowType != widget.slectedShowType ||
                          _selectedShowRate != widget.selectedShowRate ||
                          _selectedCat.id != widget.selectedCategory.id ||
                          _selectedPriceRange != widget.priceRange) {
                        widget.onSelectShowType(_selectedShowType);
                        widget.onSelectShowRate(_selectedShowRate);
                        widget.onSelectCategory(_selectedCat);
                        widget.onSelectPriceRange(_selectedPriceRange);
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pop(context, false);
                      }
                    },
                    child: const LargeButton(text: 'تصفيه', isButton: false),
                  ),
                  20.verticalSpace,
                ]),
              )),

              //21.verticalSpace,
            ]),
    );
  }
}
