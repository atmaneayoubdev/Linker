import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/market_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../common/loading_widget.dart';

class RatingBottomSheet extends StatefulWidget {
  const RatingBottomSheet({
    Key? key,
    required this.isStore,
    required this.productId,
    required this.storeId,
  }) : super(key: key);
  final bool isStore;
  final String productId;
  final String storeId;

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  bool isLoading = false;
  double rate = 4;
  bool hasChanged = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(38.r),
          topRight: Radius.circular(38.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 4.h,
            width: 54.w,
            color: kLightGreyColor,
          ),
          34.verticalSpace,
          Text(
            widget.isStore
                ? 'كيف كانت تجربتك مع المتجر'
                : 'اخبرنا مارايك بالمنتج',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          22.verticalSpace,
          RatingBar.builder(
            initialRating: 4,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            glowColor: kLightGreyColor,
            unratedColor: kLightGreyColor,
            itemBuilder: (context, _) => const Icon(
              Icons.star_rounded,
              color: Color.fromARGB(255, 232, 153, 31),
            ),
            glow: true,
            glowRadius: 5,
            onRatingUpdate: (rating) {
              setState(() {
                rate = rating;
              });
              log(rating.toString());
            },
          ),
          28.verticalSpace,
          Container(
            height: 130.h,
            width: 343.w,
            decoration: BoxDecoration(
              color: kLighLightGreyColor,
              borderRadius: BorderRadius.circular(17.r),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              controller: controller,
              decoration: InputDecoration(
                // labelText: 'اكتب رايك هنا',
                border: InputBorder.none,
                hintText: 'أخبرنا رأيك',
                hintStyle: Theme.of(context).textTheme.bodySmall,
              ),
              style: Theme.of(context).textTheme.bodySmall,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              expands: true, // <-- SEE HERE
            ),
          ),
          17.verticalSpace,
          GestureDetector(
            onTap: () async {
              setState(() {
                isLoading = true;
                hasChanged = true;
              });
              await MarketController.addRate(
                deviceToken:
                    Provider.of<MessagingProvider>(context, listen: false)
                        .deviceToken,
                token: Provider.of<UserProvider>(context, listen: false)
                    .user
                    .apiToken,
                objectId: widget.isStore ? widget.storeId : widget.productId,
                type: widget.isStore ? "store" : "product",
                feedback: controller.text,
                rate: rate.toStringAsFixed(1),
              ).then((value) {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: value == "تم إضافه تقييمك بنجاح"
                        ? kDarkColor
                        : Colors.red,
                    content: Text(
                      value.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: Colors.white),
                    )));
                Navigator.pop(context, hasChanged);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 42.w),
              child: isLoading
                  ? LoadingWidget(color: kDarkColor, size: 40.h)
                  : const LargeButton(text: 'تقييم', isButton: false),
            ),
          ),
        ],
      ),
    );
  }
}
