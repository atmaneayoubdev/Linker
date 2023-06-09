import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:linker/controllers/market_controller.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/market/product_model.dart';
import 'package:linker/ui/market/views/product_view.dart';
import 'package:provider/provider.dart';

import '../../helpers/constants.dart';
import '../../helpers/messaging_provider.dart';

class MarketProductItemWidget extends StatefulWidget {
  const MarketProductItemWidget({
    Key? key,
    required this.isFav,
    required this.product,
    required this.from,
    required this.canNavigat,
  }) : super(key: key);
  final bool isFav;
  final ProductModel product;
  final String from;
  final bool canNavigat;

  @override
  State<MarketProductItemWidget> createState() =>
      _MarketProductItemWidgetState();
}

class _MarketProductItemWidgetState extends State<MarketProductItemWidget> {
  bool isProductLiked = false;

  @override
  void initState() {
    isProductLiked = widget.product.isFavorite == 'true' ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.canNavigat
            ? () {
                Navigator.of(context)
                    .push<bool>(MaterialPageRoute(
                  builder: ((context) => ProductView(
                        from: widget.from,
                        productId: widget.product.id,
                      )),
                ))
                    .then((value) {
                  setState(() {
                    isProductLiked = value!;
                  });
                });
              }
            : null,
        child: Container(
          //height: 254.h,
          width: widget.isFav ? double.infinity : 327.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9.r),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 5,
                spreadRadius: 5,
                color: kLighLightGreyColor,
              )
            ],
          ),
          child: (Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9.r),
                      topRight: Radius.circular(9.r),
                    ),
                  ),
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9.r),
                          child: CachedNetworkImage(
                            imageUrl: widget.product.mainImage.toString(),
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: SizedBox(),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(9.r),
                              topRight: Radius.circular(9.r),
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(0, 0, 0, 0),
                                Color.fromARGB(53, 0, 0, 0),
                              ],
                            )),
                      ),
                      if (widget.from != 'post')
                        Container(
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.topRight,
                          height: 40.h,
                          width: 40.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(81, 255, 255, 255),
                          ),
                          child: ClipOval(
                            //borderRadius: BorderRadius.circular(1000),
                            child: LikeButton(
                              size: 30.h,
                              //bubblesSize: 50,
                              padding: EdgeInsets.zero,
                              likeCountPadding: EdgeInsets.zero,
                              circleColor: const CircleColor(
                                start: Colors.red,
                                end: Colors.red,
                              ),
                              isLiked: isProductLiked,
                              onTap: (isLiked) async {
                                await MarketController.addRemoveFavorite(
                                  deviceToken: Provider.of<MessagingProvider>(
                                          context,
                                          listen: false)
                                      .deviceToken,
                                  token: Provider.of<UserProvider>(context,
                                          listen: false)
                                      .user
                                      .apiToken,
                                  isProducts: true,
                                  objectId: widget.product.id,
                                ).then((value) {
                                  if (value == "تم الإضافه إلي المفضلة") {
                                    isProductLiked = true;
                                    setState(() {});
                                  } else {
                                    isProductLiked = false;
                                    setState(() {});
                                  }
                                });
                                return true;
                              },
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: kBleuColor,
                                dotSecondaryColor: kBleuColor,
                              ),
                              likeBuilder: (bool isLiked) {
                                return FittedBox(
                                  child: Icon(
                                    !isLiked
                                        ? Icons.favorite_outline
                                        : Icons.favorite,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              9.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(height: 1.5),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: kLightOrangeColor,
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Row(children: [
                        Text(
                          double.parse(widget.product.rates).toStringAsFixed(1),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: kOrangeColor),
                        ),
                        5.horizontalSpace,
                        FittedBox(
                          child: Icon(
                            Icons.star,
                            color: kOrangeColor,
                            size: 20.h,
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
              9.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.product.price} ر.س',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              9.verticalSpace,
            ],
          )),
        ),
      ),
    );
  }
}
