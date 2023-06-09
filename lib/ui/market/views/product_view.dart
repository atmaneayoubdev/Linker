import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/market_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/market/rate_model.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:linker/ui/market/components/prodcts_tab_widget.dart';
import 'package:linker/ui/market/components/product_card_widget.dart';
import 'package:linker/ui/market/components/product_icons_widget.dart';
import 'package:linker/ui/market/components/share_bottom_sheet.dart';
import 'package:linker/ui/market/views/share_store_product_view.dart';
import 'package:linker/ui/market/views/store_view.dart';
import 'package:linker/ui/market/components/rating_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/messaging_provider.dart';
import '../../../models/market/product_model.dart';
import '../../../models/market/sub_rate_model.dart';
import '../../common/loading_widget.dart';
import '../../common/show_images_widget.dart';
import '../components/prodcut_store_widget.dart';
import '../components/store_comments_card_widget.dart';
import '../components/store_comments_widget.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, required this.productId, required this.from});
  final String productId;
  final String from;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  bool isDetails = true;
  bool isLoading = true;
  bool showCircle = true;
  late ProductModel product;
  late RateModel rate;
  late RateModel storeRate;

  void setComments() {
    setState(() {
      isDetails = false;
    });
  }

  void setDetails() {
    setState(() {
      isDetails = true;
    });
  }

  Future<void> _launchUrl(url) async {
    final Uri url0 = Uri.parse(url);

    if (!await launchUrl(url0, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url0');
    }
  }

  Future showProduct() async {
    setState(() {
      isLoading = true;
    });
    await MarketController.showProduct(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      productId: widget.productId,
    ).then((value) {
      if (value.runtimeType == ProductModel) {
        product = value;
        getStoreRates(product.store.id).then((value) {
          isLoading = false;
          showCircle = false;
          setState(() {});
        });
      }
    });
  }

  Future getProductRates() async {
    await MarketController.getProductsRates(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      productId: widget.productId,
    ).then((value) {
      setState(() {
        rate = value;
      });
    });
  }

  Future getStoreRates(String storeId) async {
    await MarketController.getStoreRates(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      storeId: storeId,
    ).then((value) {
      setState(() {
        storeRate = value;
      });
    });
  }

  @override
  void initState() {
    showProduct();
    getProductRates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      floatingActionButton: isDetails
          ? const SizedBox()
          : GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => RatingBottomSheet(
                          isStore: false,
                          productId: product.id,
                          storeId: '',
                        )).then((value) {
                  if (value == true) {
                    showProduct();
                    getProductRates();
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
              Navigator.of(context).pop(product.isFavorite == "true");
              return false;
            });
          },
          child: Stack(
            children: [
              Column(
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
                          color: const Color.fromRGBO(255, 255, 250, 1),
                        ),
                        child: isLoading && showCircle
                            ? Center(
                                child: LoadingWidget(
                                    color: kDarkColor, size: 40.h),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(38.r),
                                  topRight: Radius.circular(38.r),
                                ),
                                child: RefreshIndicator(
                                  displacement: 0,
                                  onRefresh: () async {
                                    showProduct();
                                    getProductRates();
                                  },
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Stack(
                                      children: [
                                        Stack(
                                          children: [
                                            SizedBox(
                                              height: 327.h,
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(38.r),
                                                  topRight:
                                                      Radius.circular(38.r),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: product.mainImage,
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
                                            GestureDetector(
                                              onTap: () {
                                                showDialog<String>(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (BuildContext ctx) {
                                                    List<String> images = [];
                                                    for (var image
                                                        in product.images) {
                                                      images.add(image.image);
                                                    }
                                                    return ShowImagesWidget(
                                                      images: images,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 327.h,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Color.fromARGB(
                                                          0, 0, 0, 0),
                                                      Color.fromARGB(
                                                          93, 0, 0, 0),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(38.r),
                                                    topRight:
                                                        Radius.circular(38.r),
                                                  ),
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
                                              child: ProductIconsWidget(
                                                onChangedBack: () {
                                                  Navigator.of(context).pop(
                                                      product.isFavorite ==
                                                          "true");
                                                },
                                                onChanged: (isFav) {
                                                  setState(() {
                                                    product.isFavorite = isFav
                                                        ? "true"
                                                        : "false";
                                                  });
                                                },
                                                isFav: product.isFavorite ==
                                                    "true",
                                                productId: product.id,
                                                onShare: () {
                                                  showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder: (context) =>
                                                        ShareBottomSheet(
                                                      id: product.id,
                                                      type: "product",
                                                    ),
                                                  ).then((value) async {
                                                    if (value == "public") {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ShareStoreProductView(
                                                                    type:
                                                                        'product',
                                                                    isUpdating:
                                                                        false,
                                                                    product:
                                                                        product,
                                                                  )));
                                                    }

                                                    if (value == "privat") {}
                                                  });
                                                },
                                              ),
                                            ),
                                            140.verticalSpace,
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 25.w,
                                              ),
                                              child: ProductCardWidget(
                                                description: product.title,
                                                rate: product.rates,
                                              ),
                                            ),
                                            20.verticalSpace,
                                            ProductStoreWidget(
                                              onTap: () {
                                                if (widget.from == 'store') {
                                                  Navigator.of(context).pop(
                                                      product.isFavorite ==
                                                          "true");
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              StoreView(
                                                                storeId: product
                                                                    .store.id,
                                                              ))));
                                                }
                                              },
                                              rate: storeRate.totalRate,
                                              store: product.store,
                                            ),
                                            20.verticalSpace,
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w),
                                              child: ProductTabWidget(
                                                isDetails: isDetails,
                                                setComments: setComments,
                                                setDetails: setDetails,
                                              ),
                                            ),
                                            13.verticalSpace,
                                            if (isDetails)
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w),
                                                child: Text(
                                                  product.description,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .apply(
                                                        color: kLightBlackColor,
                                                      )
                                                      .copyWith(height: 1.5),
                                                ),
                                              ),
                                            if (!isDetails)
                                              Column(
                                                children: [
                                                  rate.rates.isEmpty
                                                      ? SizedBox(
                                                          height: 100.h,
                                                          child: Center(
                                                            child: Text(
                                                              "لا يوجد تقييمات",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                            ),
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      19.w),
                                                          child:
                                                              StoreCommentsCardWidget(
                                                                  rate: rate),
                                                        ),
                                                  11.verticalSpace,
                                                  ListView.separated(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 19.w,
                                                    ),
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
                                                ],
                                              ),
                                            100.verticalSpace,
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
              if (isDetails && !isLoading)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    height: 105.h,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 42.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              _launchUrl(product.url);
                            },
                            child: const LargeButton(
                                text: 'شراء', isButton: false),
                          )),
                          15.horizontalSpace,
                          Text(
                            '${product.price} ر.س',
                            style: Theme.of(context).textTheme.titleMedium,
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
    );
  }
}
