import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../../../controllers/market_controller.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';

class ProductIconsWidget extends StatefulWidget {
  const ProductIconsWidget({
    Key? key,
    required this.onShare,
    required this.productId,
    required this.isFav,
    required this.onChanged,
    required this.onChangedBack,
  }) : super(key: key);
  final Function() onShare;
  final String productId;
  final bool isFav;
  final Function(bool) onChanged;
  final Function onChangedBack;

  @override
  State<ProductIconsWidget> createState() => _ProductIconsWidgetState();
}

class _ProductIconsWidgetState extends State<ProductIconsWidget> {
  bool isProductLiked = false;

  @override
  void initState() {
    isProductLiked = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            widget.onChangedBack();
          },
          child: SvgPicture.asset(
            'assets/icons/back_button.svg',
            height: 45.h,
          ),
        ),
        Column(
          children: [
            Container(
              //margin: const EdgeInsets.all(10),
              alignment: Alignment.topRight,
              height: 45.h,
              width: 45.w,
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
                      deviceToken:
                          Provider.of<MessagingProvider>(context, listen: false)
                              .deviceToken,
                      token: Provider.of<UserProvider>(context, listen: false)
                          .user
                          .apiToken,
                      isProducts: true,
                      objectId: widget.productId,
                    ).then((value) {
                      if (value == "تم الإضافه إلي المفضلة") {
                        isProductLiked = true;
                        setState(() {});
                      } else {
                        isProductLiked = false;
                        setState(() {});
                      }
                      widget.onChanged(isProductLiked);
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
                        !isLiked ? Icons.favorite_outline : Icons.favorite,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            24.verticalSpace,
            GestureDetector(
              onTap: () {
                widget.onShare();
              },
              child: ClipOval(
                child: Blur(
                  blur: 3,
                  blurColor: Colors.white,
                  colorOpacity: 0.3,
                  overlay: SvgPicture.asset(
                    'assets/icons/share.svg',
                    fit: BoxFit.cover,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  child: Container(
                    height: 45.h,
                    width: 45.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
