import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/market/product_model.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/market/Shimmers/store_product_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../controllers/market_controller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../../models/market/category_model.dart';
import '../../common/market_product_item_widget.dart';
import '../components/filter_bottom_sheet.dart';

class AllProductsView extends StatefulWidget {
  const AllProductsView({super.key, required this.isSearching});
  final bool isSearching;

  @override
  State<AllProductsView> createState() => _AllProductsViewState();
}

class _AllProductsViewState extends State<AllProductsView> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  List<ProductModel> _products = [];
  bool isLoading = false;
  MarketCategoryModel _selectedCat = MarketCategoryModel(id: '', name: 'الكل');
  String _selectedShowType = "الكل";
  String _selectedShowRate = "الكل";
  SfRangeValues _selectedPriceRange = const SfRangeValues(0, 100000);

  Future getProducts() async {
    setState(() {
      isLoading = true;
    });
    await MarketController.getProducts(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      catId: _selectedCat.id,
      menuId: '',
      priceFrom:
          _selectedPriceRange.start == 0 && _selectedPriceRange.end == 100000
              ? ''
              : _selectedPriceRange.start.toString(),
      priceTo:
          _selectedPriceRange.end == 100000 && _selectedPriceRange.start == 0
              ? ''
              : _selectedPriceRange.end.toString(),
      rate: _selectedShowRate == "الكل"
          ? ''
          : _selectedShowRate == "الاعلي اولا"
              ? "desc"
              : "asc",
      storeId: '',
      title: searchController.text,
      // type: _selectedShowType == "الكل"
      //     ? ''
      //     : _selectedShowType == "الأعلى تقييماً"
      //         ? "best_rate"
      //         : "new",
      type: '',
    ).then((value) {
      setState(() {
        _products = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    widget.isSearching
        ? _focusNode.requestFocus()
        : WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => FilterBottomSheet(
                      onSelectCategory: (cat) {
                        setState(() {
                          _selectedCat = cat;
                        });
                      },
                      onSelectPriceRange: (range) {
                        setState(() {
                          _selectedPriceRange = range;
                        });
                      },
                      onSelectShowRate: (showrate) {
                        setState(() {
                          _selectedShowRate = showrate;
                        });
                      },
                      onSelectShowType: (showtype) {
                        setState(() {
                          _selectedShowType = showtype;
                        });
                      },
                      priceRange: _selectedPriceRange,
                      selectedCategory: _selectedCat,
                      selectedShowRate: _selectedShowRate,
                      slectedShowType: _selectedShowType,
                    )).then((value) {
              getProducts();
            });
          });
    if (widget.isSearching) getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButtonWidget(),
                  Expanded(
                    child: TextField(
                      autofocus: false,
                      focusNode: _focusNode,
                      style: Theme.of(context).textTheme.bodySmall,
                      controller: searchController,
                      scrollPadding: EdgeInsets.zero,
                      maxLines: 1,
                      onEditingComplete: () {
                        getProducts();
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          getProducts();
                        }
                      },
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
                  8.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => FilterBottomSheet(
                                onSelectCategory: (cat) {
                                  setState(() {
                                    _selectedCat = cat;
                                  });
                                },
                                onSelectPriceRange: (range) {
                                  setState(() {
                                    _selectedPriceRange = range;
                                  });
                                },
                                onSelectShowRate: (showrate) {
                                  setState(() {
                                    _selectedShowRate = showrate;
                                  });
                                },
                                onSelectShowType: (showtype) {
                                  setState(() {
                                    _selectedShowType = showtype;
                                  });
                                },
                                priceRange: _selectedPriceRange,
                                selectedCategory: _selectedCat,
                                selectedShowRate: _selectedShowRate,
                                slectedShowType: _selectedShowType,
                              )).then((value) {
                        if (value == true) {
                          getProducts();
                        }
                      });
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
              20.verticalSpace,
              Expanded(
                child: isLoading
                    ? const StoreProductListShimmer(isFav: true, isVert: true)
                    : _products.isEmpty
                        ? SizedBox(
                            height: 100.h,
                            child: Center(
                              child: Text(
                                "لا توجد منتجات للعرض",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            displacement: 0,
                            onRefresh: () async {
                              getProducts();
                            },
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: false,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: _products.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return 11.verticalSpace;
                              },
                              itemBuilder: (BuildContext context, int index) {
                                ProductModel product = _products[index];
                                return MarketProductItemWidget(
                                  canNavigat: true,
                                  isFav: true,
                                  product: product,
                                  from: "store",
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
