import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/models/market/product_model.dart';
import 'package:linker/models/market/store_model.dart';
import 'package:linker/ui/additional/components/favorite_tab_widget.dart';
import 'package:linker/ui/common/market_store_item_widget.dart';
import 'package:provider/provider.dart';

import '../../../controllers/market_controller.dart';
import '../../../controllers/my_profile_controller.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../common/market_product_item_widget.dart';
import '../../market/Shimmers/store_product_shimmer.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  bool isStore = false;
  List<ProductModel> _products = [];
  List<StoreModel> _stores = [];
  bool isProductLoading = false;
  bool isStoresLoading = false;

  void setStore() {
    setState(() {
      isStore = true;
    });
  }

  void setProduct() {
    setState(() {
      isStore = false;
    });
  }

  Future getNotificationsCount() async {
    await MyProfileController.getNotificationsCount(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      Provider.of<UserProvider>(context, listen: false)
          .setUserNotifications(value);
    });
  }

  Future getFavoriteProducts() async {
    setState(() {
      isProductLoading = true;
    });
    setState(() {});
    await MarketController.getFavoriteProducts(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      setState(() {
        _products = value;
        isProductLoading = false;
      });
    });
  }

  Future getFavoriteStores() async {
    setState(() {
      isStoresLoading = true;
    });
    setState(() {});
    await MarketController.getFavoriteStores(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      setState(() {
        _stores = value;
        isStoresLoading = false;
      });
    });
  }

  @override
  void initState() {
    getNotificationsCount();
    getFavoriteProducts();
    getFavoriteStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return RefreshIndicator(
              displacement: 0,
              onRefresh: () async {
                getNotificationsCount();
                getFavoriteProducts();
                getFavoriteStores();
              },
              color: kDarkColor,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //18.verticalSpace,
                      FavoriteTabView(
                        isStore: isStore,
                        setStore: setStore,
                        setProduct: setProduct,
                      ),
                      11.verticalSpace,
                      if (isStore)
                        isStoresLoading
                            ? const StoreProductListShimmer(
                                isFav: true,
                                isVert: true,
                              )
                            : _stores.isEmpty
                                ? SizedBox(
                                    height: 600.h,
                                    child: Center(
                                      child: Text(
                                        "لا توجد متاجر لعرضها",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: _stores.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return 11.verticalSpace;
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      StoreModel store = _stores[index];
                                      return MarketStoreItemWidget(
                                        canNavigat: true,
                                        isFav: true,
                                        store: store,
                                        from: 'favorite',
                                      );
                                    },
                                  ),
                      if (!isStore)
                        isStoresLoading
                            ? const StoreProductListShimmer(
                                isFav: true,
                                isVert: true,
                              )
                            : _products.isEmpty
                                ? SizedBox(
                                    height: 600.h,
                                    child: Center(
                                      child: Text(
                                        "لا توجد منتجات للعرض",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: _products.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return 11.verticalSpace;
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      ProductModel product = _products[index];
                                      return MarketProductItemWidget(
                                        canNavigat: true,
                                        isFav: true,
                                        product: product,
                                        from: "FavoriteProduct",
                                      );
                                    },
                                  ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
