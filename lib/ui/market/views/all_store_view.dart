import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/market/store_model.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/common/market_store_item_widget.dart';
import 'package:linker/ui/market/Shimmers/store_product_shimmer.dart';
import 'package:linker/ui/market/components/store_filter_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../controllers/market_controller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../../models/market/category_model.dart';

class AllStoresView extends StatefulWidget {
  const AllStoresView({super.key, required this.isSearching});
  final bool isSearching;

  @override
  State<AllStoresView> createState() => _AllStoresViewState();
}

class _AllStoresViewState extends State<AllStoresView> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  List<StoreModel> _stores = [];
  MarketCategoryModel _selectedCat = MarketCategoryModel(id: '', name: 'الكل');
  String _selectedShowRate = "الكل";
  bool isLoading = false;

  Future getStores() async {
    setState(() {
      isLoading = true;
    });
    await MarketController.getStoresFilter(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      catId: _selectedCat.id,
      rate: _selectedShowRate == "الكل"
          ? ''
          : _selectedShowRate == "الاعلي اولا"
              ? "desc"
              : "asc",
      storeName: searchController.text,
    ).then((value) {
      setState(() {
        _stores = value;
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
                builder: (context) => StoreFilterBottomSheet(
                      onSelectCategory: (cat) {
                        setState(() {
                          _selectedCat = cat;
                        });
                      },
                      onSelectShowRate: (showrate) {
                        setState(() {
                          _selectedShowRate = showrate;
                        });
                      },
                      selectedCategory: _selectedCat,
                      selectedShowRate: _selectedShowRate,
                    )).then((value) {
              getStores();
            });
          });
    if (widget.isSearching) getStores();
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
                        getStores();
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          getStores();
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
                          builder: (context) => StoreFilterBottomSheet(
                                onSelectCategory: (cat) {
                                  setState(() {
                                    _selectedCat = cat;
                                  });
                                },
                                onSelectShowRate: (showrate) {
                                  setState(() {
                                    _selectedShowRate = showrate;
                                  });
                                },
                                selectedCategory: _selectedCat,
                                selectedShowRate: _selectedShowRate,
                              )).then((value) {
                        if (value == true) {
                          getStores();
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
                    : _stores.isEmpty
                        ? SizedBox(
                            height: 100.h,
                            child: Center(
                              child: Text(
                                "لا توجد متاجر لعرضها",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            displacement: 0,
                            onRefresh: () async {
                              getStores();
                            },
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: false,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: _stores.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return 11.verticalSpace;
                              },
                              itemBuilder: (BuildContext context, int index) {
                                StoreModel store = _stores[index];
                                return MarketStoreItemWidget(
                                    isFav: true,
                                    store: store,
                                    from: "store",
                                    canNavigat: true);
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
