import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/models/market/store_model.dart';
import 'package:linker/ui/market/Shimmers/store_product_shimmer.dart';
import 'package:linker/ui/market/views/all_store_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/market_controller.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../../models/market/category_model.dart';
import '../../additional/components/cat_shimmer.dart';
import '../../common/market_store_item_widget.dart';
import '../components/market_category_widget.dart';

class HomeStoreView extends StatefulWidget {
  const HomeStoreView({
    super.key,
  });

  @override
  State<HomeStoreView> createState() => _HomeStoreViewState();
}

class _HomeStoreViewState extends State<HomeStoreView> {
  TextEditingController searchController = TextEditingController();
  List<StoreModel> _bestRatedStores = [];
  List<StoreModel> _newStores = [];
  final List<MarketCategoryModel> _categories = [
    MarketCategoryModel(id: '', name: 'الكل')
  ];
  MarketCategoryModel _selectedCat = MarketCategoryModel(id: '', name: 'الكل');
  bool isBestRatedStoresLoading = false;
  bool isNewStoresLoading = false;
  bool iscatLoading = false;

  Future getBestRatedStores() async {
    setState(() {
      isBestRatedStoresLoading = true;
    });
    setState(() {});
    await MarketController.getStoresFilter(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      catId: _selectedCat.id.toString(),
      rate: 'desc',
      storeName: '',
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      setState(() {
        _bestRatedStores = value;
        isBestRatedStoresLoading = false;
      });
    });
  }

  Future getNewStores() async {
    setState(() {
      isNewStoresLoading = true;
    });
    setState(() {});
    await MarketController.getStoresFilter(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      catId: _selectedCat.id.toString(),
      rate: '',
      storeName: '',
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      setState(() {
        _newStores = value;
        isNewStoresLoading = false;
      });
    });
  }

  Future getCategories() async {
    setState(() {
      iscatLoading = true;
    });
    await MarketController.getCategories(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storeId: '',
    ).then((value) {
      setState(() {
        _categories.addAll(value);
        iscatLoading = false;
      });
    });
  }

  @override
  void initState() {
    getCategories();
    getBestRatedStores();
    getNewStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          10.verticalSpace,
          SizedBox(
            height: 50.h,
            width: double.infinity,
            child: iscatLoading
                ? const CategoryShimmer()
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    itemCount: _categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                      return 10.horizontalSpace;
                    },
                    itemBuilder: (BuildContext context, int index) {
                      MarketCategoryModel cat = _categories[index];
                      return GestureDetector(
                        onTap: () {
                          if (_selectedCat != cat) {
                            _selectedCat = cat;
                            getBestRatedStores();
                            getNewStores();
                          }
                          setState(() {});
                        },
                        child: MarketCategoryWidget(
                          isSelected: _selectedCat == cat,
                          name: cat.name,
                        ),
                      );
                    },
                  ),
          ),
          10.verticalSpace,
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: SizedBox(
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: TextField(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AllStoresView(
                                          isSearching: true,
                                        )));
                          },
                          enabled: true,
                          showCursor: false,
                          style: Theme.of(context).textTheme.bodySmall,
                          controller: searchController,
                          scrollPadding: EdgeInsets.zero,
                          maxLines: 1,
                          autofocus: false,
                          decoration: formFieldDecoration!.copyWith(
                            isDense: true,
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            hintText: 'ماذا تريد ان تبحث عن …',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(219, 219, 219, 1),
                              ),
                            ),
                            prefixIcon: SizedBox(
                              height: 10.h,
                              width: 15.w,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/loop.svg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), //,
                    ),
                    5.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllStoresView(
                                      isSearching: false,
                                    )));
                      },
                      child: Container(
                        height: 50.h,
                        width: 55.w,
                        decoration: BoxDecoration(
                          color: kOrangeColor,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: SvgPicture.asset('assets/icons/filter.svg'),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'الأفضل تقييما',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .apply(color: kBleuColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 290.h,
            width: double.infinity,
            child: isBestRatedStoresLoading
                ? const StoreProductListShimmer(
                    isFav: false,
                    isVert: false,
                  )
                : _bestRatedStores.isEmpty
                    ? SizedBox(
                        height: 254.h,
                        child: Center(
                          child: Text(
                            "لا توجد متاجر لعرضها",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _bestRatedStores.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return 11.horizontalSpace;
                        },
                        itemBuilder: (BuildContext context, int index) {
                          StoreModel store = _bestRatedStores[index];
                          return MarketStoreItemWidget(
                            canNavigat: true,
                            isFav: false,
                            store: store,
                            from: "bestrated",
                          );
                        },
                      ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'مضاف حديثا',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .apply(color: kBleuColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 290.h,
            width: double.infinity,
            child: isNewStoresLoading
                ? const StoreProductListShimmer(
                    isFav: false,
                    isVert: false,
                  )
                : _newStores.isEmpty
                    ? SizedBox(
                        height: 254.h,
                        child: Center(
                          child: Text(
                            "لا توجد متاجر لعرضها",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _newStores.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return 11.horizontalSpace;
                        },
                        itemBuilder: (BuildContext context, int index) {
                          StoreModel store = _newStores[index];
                          return MarketStoreItemWidget(
                            canNavigat: true,
                            isFav: false,
                            store: store,
                            from: "store",
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
