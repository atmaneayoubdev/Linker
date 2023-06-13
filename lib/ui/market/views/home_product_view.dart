import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/controllers/market_controller.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/market/product_model.dart';
import 'package:linker/ui/additional/components/cat_shimmer.dart';
import 'package:linker/ui/market/Shimmers/store_product_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../models/market/category_model.dart';
import '../../common/market_product_item_widget.dart';
import '../components/market_category_widget.dart';
import 'all_products_view.dart';

class HomeProductView extends StatefulWidget {
  const HomeProductView({
    super.key,
  });

  @override
  State<HomeProductView> createState() => _HomeProductViewState();
}

class _HomeProductViewState extends State<HomeProductView> {
  TextEditingController searchController = TextEditingController();
  List<ProductModel> _bestRatedProducts = [];
  List<ProductModel> _newProducts = [];
  final List<MarketCategoryModel> _categories = [
    MarketCategoryModel(id: '', name: 'الكل')
  ];
  MarketCategoryModel _selectedCat = MarketCategoryModel(id: '', name: 'الكل');
  bool isBestProductsLoading = false;
  bool isNewProductsLoading = false;
  bool isFilteredProductsLoading = false;
  bool isfilter = false;
  bool iscatLoading = false;

  Future getNewProducts() async {
    setState(() {
      isNewProductsLoading = true;
    });
    await MarketController.getProducts(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      catId: _selectedCat.id,
      menuId: '',
      priceFrom: '',
      priceTo: '',
      rate: "",
      storeId: '',
      title: '',
      type: '',
    ).then((value) {
      setState(() {
        _newProducts = value;
        isNewProductsLoading = false;
      });
    });
  }

  Future getBestRatedProducts() async {
    setState(() {
      isBestProductsLoading = true;
    });
    await MarketController.getProducts(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      catId: _selectedCat.id,
      menuId: '',
      priceFrom: '',
      priceTo: '',
      rate: "desc",
      storeId: '',
      title: '',
      type: '',
    ).then((value) {
      setState(() {
        _bestRatedProducts = value;
        isBestProductsLoading = false;
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
    getBestRatedProducts();
    getNewProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 0,
      onRefresh: () async {
        getCategories();
        getBestRatedProducts();
        getNewProducts();
      },
      child: SingleChildScrollView(
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
                              getBestRatedProducts();
                              getNewProducts();
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              height: 42.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllProductsView(
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
                    ), //,
                  ),
                  5.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllProductsView(
                                    isSearching: false,
                                  )));
                    },
                    child: Container(
                      height: 42.h,
                      width: 49.w,
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
            ),
            20.verticalSpace,
            Column(
              children: [
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
                10.verticalSpace,
                SizedBox(
                  height: 290.h,
                  width: double.infinity,
                  child: isBestProductsLoading
                      ? const StoreProductListShimmer(
                          isFav: false,
                          isVert: false,
                        )
                      : _bestRatedProducts.isEmpty
                          ? SizedBox(
                              height: 254.h,
                              child: Center(
                                child: Text(
                                  "لا توجد منتجات للعرض",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _bestRatedProducts.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return 11.horizontalSpace;
                              },
                              itemBuilder: (BuildContext context, int index) {
                                ProductModel product =
                                    _bestRatedProducts[index];
                                return MarketProductItemWidget(
                                  canNavigat: true,
                                  product: product,
                                  isFav: false,
                                  from: 'products',
                                );
                              },
                            ),
                ),
                10.verticalSpace,
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
                10.verticalSpace,
                SizedBox(
                  height: 290.h,
                  width: double.infinity,
                  child: isNewProductsLoading
                      ? const StoreProductListShimmer(
                          isFav: false,
                          isVert: false,
                        )
                      : _newProducts.isEmpty
                          ? SizedBox(
                              height: 254.h,
                              child: Center(
                                child: Text(
                                  "لا توجد منتجات للعرض",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _newProducts.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return 11.horizontalSpace;
                              },
                              itemBuilder: (BuildContext context, int index) {
                                ProductModel product = _newProducts[index];
                                return MarketProductItemWidget(
                                  canNavigat: true,
                                  product: product,
                                  isFav: false,
                                  from: 'products',
                                );
                              },
                            ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
