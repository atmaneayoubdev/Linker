import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/auth/other_user_model.dart';
import 'package:linker/models/market/category_model.dart';
import 'package:linker/models/market/menu_model.dart';
import 'package:linker/models/market/rate_model.dart';
import 'package:linker/models/market/store_model.dart';
import 'package:linker/models/market/sub_rate_model.dart';
import 'package:linker/ui/market/Shimmers/store_product_shimmer.dart';
import 'package:linker/ui/market/components/store_categories_widget.dart';
import 'package:linker/ui/market/components/store_menue_widget.dart';
import 'package:linker/ui/market/components/store_tab_widget.dart';
import 'package:linker/ui/market/views/share_store_product_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/market_controller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../../models/market/product_model.dart';
import '../../common/loading_widget.dart';
import '../../common/market_product_item_widget.dart';
import '../../messages/views/messages_view.dart';
import '../components/rating_bottom_sheet.dart';
import '../components/store_card_widget.dart';
import '../components/store_comments_card_widget.dart';
import '../components/store_comments_widget.dart';
import '../components/store_icons_widget.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key, required this.storeId});
  final String storeId;

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  TextEditingController searchController = TextEditingController();
  MarketCategoryModel firstCategory = MarketCategoryModel(id: '', name: 'الكل');
  MarketCategoryModel _selectedCat = MarketCategoryModel(id: '', name: 'الكل');
  MenuModel _selectedMenu = MenuModel(id: "", name: "");
  List<ProductModel> _bestRatedProducts = [];
  List<ProductModel> _products = [];
  List<MenuModel> _menues = [];
  final List<MarketCategoryModel> _categories = [];

  late StoreModel store;
  late RateModel rate;
  bool isProducts = true;
  bool isLoading = true;
  bool showCircle = true;
  bool isProductsLoading = false;

  void setComments() {
    setState(() {
      isProducts = false;
    });
  }

  void setProduct() {
    setState(() {
      isProducts = true;
    });
  }

  Future getCategories() async {
    await MarketController.getCategories(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storeId: widget.storeId,
    ).then((value) {
      _selectedCat = firstCategory;
      _categories.add(firstCategory);
      _categories.addAll(value);
      setState(() {});
    });
  }

  Future getProducts() async {
    setState(() {
      isProductsLoading = true;
    });
    await MarketController.getProducts(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      catId: _selectedCat.id,
      menuId: _selectedMenu.id == '' ? '' : _selectedMenu.id,
      priceFrom: '',
      priceTo: '',
      rate: '',
      storeId: widget.storeId,
      title: '',
      type: '',
    ).then((value) {
      setState(() {
        _products = value;
        isProductsLoading = false;
      });
    });
  }

  Future getBestRatedProducts() async {
    setState(() {});
    await MarketController.getBestRatedProducts(
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storeId: widget.storeId,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) {
      setState(() {
        _bestRatedProducts = value;
      });
    });
  }

  Future showStore() async {
    setState(() {
      isLoading = true;
    });
    await MarketController.showStore(
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storeId: widget.storeId,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) {
      if (value.runtimeType == StoreModel) {
        setState(() {
          store = value;
          isLoading = false;
          showCircle = false;
        });
      }
    });
  }

  Future getStoreRates() async {
    await MarketController.getStoreRates(
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storeId: widget.storeId,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) {
      setState(() {
        rate = value;
      });
    });
  }

  Future getMenues(bool first) async {
    await MarketController.getMenueList(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storeId: widget.storeId,
      catId: _selectedCat.id,
    ).then((value) {
      _menues = value;
      debugPrint('this is the menues : $_menues');
      if (!first) {
        _selectedMenu = value.first;
      }
      setState(() {});
      getProducts();
    });
  }

  @override
  void initState() {
    showStore();
    getBestRatedProducts();
    getProducts();
    getCategories();
    getStoreRates();
    getMenues(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      floatingActionButton: isProducts
          ? const SizedBox()
          : GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => RatingBottomSheet(
                          isStore: true,
                          productId: '',
                          storeId: store.id,
                        )).then((value) {
                  if (value == true) {
                    showStore();
                    getStoreRates();
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                height: 60.h,
                width: 60.w,
                decoration: const BoxDecoration(
                    color: kOrangeColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(5, 0, 0, 0),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: Offset(0, 0),
                      )
                    ]),
                child: const FittedBox(
                  child: Icon(
                    Icons.add_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            return Future.delayed(Duration.zero, () {
              Navigator.pop(context, store.isFavorite == "true");
              return false;
            });
          },
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
                      color: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: isLoading && showCircle
                        ? Center(
                            child: LoadingWidget(color: kDarkColor, size: 40.h),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(38.r),
                              topRight: Radius.circular(38.r),
                            ),
                            child: RefreshIndicator(
                              displacement: 0,
                              onRefresh: () async {
                                showStore();
                                getStoreRates();
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Stack(
                                  children: [
                                    Stack(
                                      children: [
                                        SizedBox(
                                          height: 327.h,
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(38.r),
                                              topRight: Radius.circular(38.r),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: store.cover,
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SizedBox(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Center(
                                                child: SizedBox(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 327.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Color.fromARGB(0, 0, 0, 0),
                                                Color.fromARGB(212, 0, 0, 0),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(38.r),
                                              topRight: Radius.circular(38.r),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        20.verticalSpace,
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.w),
                                          child: StoreIconsWidget(
                                            canChat: Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .user
                                                    .id !=
                                                store.id,
                                            onChat: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) =>
                                                      MessagesView(
                                                        isStore: true,
                                                        user: OtherUser(
                                                            id: store.id,
                                                            username:
                                                                store.storeName,
                                                            jobTitle: '',
                                                            phoneNumber: '',
                                                            avatar: store.cover,
                                                            email: '',
                                                            bio: '',
                                                            followers: '',
                                                            following: '',
                                                            lastActionAt: '',
                                                            followHim: '',
                                                            chatId: ''),
                                                        chatId: store.chatId,
                                                      )),
                                                ),
                                              );
                                            },
                                            onChangedBack: () {
                                              Navigator.pop(context,
                                                  store.isFavorite == "true");
                                            },
                                            onChanged: (isFav) {
                                              store.isFavorite =
                                                  isFav ? "true" : "false";
                                            },
                                            isFav: store.isFavorite == "true",
                                            productId: store.id,
                                            onShare: () async {
                                              showDialog<bool>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    //title: const Text('Basic dialog title'),
                                                    content: const Text(
                                                        "هل ترغب في مشاركة هذا المتجر"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                        child:
                                                            const Text('موافق'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                      ),
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                        child: const Text('لا'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(false);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ).then((value) async {
                                                if (value == true) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShareStoreProductView(
                                                        type: 'store',
                                                        store: store,
                                                        isUpdating: false,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        70.verticalSpace,
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.w),
                                          child: StoreCardWidget(
                                            store: store,
                                          ),
                                        ),
                                        21.verticalSpace,
                                        if (_bestRatedProducts.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                        if (_bestRatedProducts.isNotEmpty)
                                          SizedBox(
                                            height: 290.h,
                                            width: double.infinity,
                                            child: ListView.separated(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  _bestRatedProducts.length,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return 11.horizontalSpace;
                                              },
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                ProductModel product =
                                                    _bestRatedProducts[index];
                                                return MarketProductItemWidget(
                                                  canNavigat: true,
                                                  isFav: false,
                                                  product: product,
                                                  from: "store",
                                                );
                                              },
                                            ),
                                          ),
                                        21.verticalSpace,
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w),
                                          child: StoreTabWidget(
                                            isProducts: isProducts,
                                            setComments: setComments,
                                            setProduct: setProduct,
                                          ),
                                        ),
                                        21.verticalSpace,
                                        if (isProducts)
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 30.h,
                                                width: double.infinity,
                                                child: ListView.separated(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.w),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: _categories.length,
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return 30.horizontalSpace;
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    MarketCategoryModel cat =
                                                        _categories[index];
                                                    return GestureDetector(
                                                        onTap: () {
                                                          if (_selectedCat !=
                                                              cat) {
                                                            _selectedCat = cat;
                                                            getMenues(false);
                                                          }
                                                          setState(() {});
                                                        },
                                                        child:
                                                            StoreCategoriesWidget(
                                                          isSelected:
                                                              _selectedCat ==
                                                                  cat,
                                                          name: cat.name,
                                                        ));
                                                  },
                                                ),
                                              ),
                                              10.verticalSpace,
                                              SizedBox(
                                                height: 30.h,
                                                width: double.infinity,
                                                child: ListView.separated(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.w),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: _menues.length,
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return 30.horizontalSpace;
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    MenuModel menue =
                                                        _menues[index];
                                                    return GestureDetector(
                                                        onTap: () {
                                                          if (_selectedMenu !=
                                                              menue) {
                                                            _selectedMenu =
                                                                menue;
                                                            getProducts();
                                                          }
                                                          setState(() {});
                                                        },
                                                        child: StoreMenueWidget(
                                                          isSelected:
                                                              _selectedMenu ==
                                                                  menue,
                                                          name: menue.name,
                                                        ));
                                                  },
                                                ),
                                              ),
                                              25.verticalSpace,
                                              isProductsLoading
                                                  ? const StoreProductListShimmer(
                                                      isFav: true, isVert: true)
                                                  : _products.isEmpty
                                                      ? SizedBox(
                                                          height: 254.h,
                                                          child: Center(
                                                            child: Text(
                                                              "لا توجد منتجات للعرض",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                            ),
                                                          ),
                                                        )
                                                      : ListView.separated(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.w),
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              _products.length,
                                                          separatorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return 11
                                                                .verticalSpace;
                                                          },
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            ProductModel
                                                                product =
                                                                _products[
                                                                    index];
                                                            return MarketProductItemWidget(
                                                              canNavigat: true,
                                                              isFav: true,
                                                              product: product,
                                                              from: "store",
                                                            );
                                                          },
                                                        ),
                                            ],
                                          ),
                                        10.verticalSpace,
                                        if (!isProducts)
                                          rate.rates.isEmpty
                                              ? SizedBox(
                                                  height: 100.h,
                                                  child: Center(
                                                    child: Text(
                                                      "لا يوجد تقييمات",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 19.w),
                                                      child:
                                                          StoreCommentsCardWidget(
                                                              rate: rate),
                                                    ),
                                                    11.verticalSpace,
                                                    ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 19.w),
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          rate.rates.length,
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return 8.verticalSpace;
                                                      },
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        SubRateModel rate = this
                                                            .rate
                                                            .rates[index];
                                                        return StoreCommentWidget(
                                                          rate: rate,
                                                        );
                                                      },
                                                    ),
                                                    50.verticalSpace,
                                                  ],
                                                ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
