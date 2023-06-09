import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/market/product_model.dart';
import 'package:linker/models/market/store_model.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:linker/ui/home/components/post_input_widget.dart';
import 'package:provider/provider.dart';

import '../../../controllers/post_controller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../common/loading_widget.dart';
import '../../common/market_product_item_widget.dart';
import '../../common/market_store_item_widget.dart';

class ShareStoreProductView extends StatefulWidget {
  const ShareStoreProductView({
    super.key,
    required this.type,
    this.store,
    this.product,
    required this.isUpdating,
  });
  final String type;
  final StoreModel? store;
  final ProductModel? product;
  final bool isUpdating;

  @override
  State<ShareStoreProductView> createState() => _ShareStoreProductViewState();
}

class _ShareStoreProductViewState extends State<ShareStoreProductView> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _controller = ScrollController();
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  bool hasChanged = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: WillPopScope(
        onWillPop: () {
          return Future.delayed(Duration.zero, () {
            Navigator.pop(context, hasChanged);
            return false;
          });
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: klighSkyBleu,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 77.h,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                widget.type == 'store'
                                    ? "مشاركة متجر"
                                    : 'مشاركة منتج',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, hasChanged);
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/back_button.svg',
                                  height: 45.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 24.h,
                            horizontal: 5.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40.r),
                              bottomRight: Radius.circular(40.r),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(1, 3),
                                blurRadius: 5,
                                spreadRadius: 5,
                                color: Color.fromARGB(10, 0, 0, 0),
                              )
                            ],
                          ),
                          child: SingleChildScrollView(
                            controller: _controller,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  10.verticalSpace,
                                  SizedBox(
                                    height: 40.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40.h,
                                          width: 40.w,
                                          //padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: kLightBlackColor,
                                                width: 2),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .user
                                                      .avatar,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SizedBox(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const SizedBox(),
                                            ),
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        Text(
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user
                                              .userName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .apply(
                                                color: kGreyColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  10.verticalSpace,
                                  PostInputWidtet(
                                    isFirst: true,
                                    isFromThread: false,
                                    formKey: _formKey,
                                    controller: controller,
                                    onRemovePost: () {},
                                  ),
                                  10.verticalSpace,
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: widget.store == null
                                          ? MarketProductItemWidget(
                                              canNavigat: false,
                                              isFav: true,
                                              product: widget.product!,
                                              from: "post",
                                            )
                                          : MarketStoreItemWidget(
                                              isFav: true,
                                              store: widget.store!,
                                              from: "post",
                                              canNavigat: false)),
                                  50.verticalSpace,
                                  GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await PostController.sharePost(
                                          deviceToken:
                                              Provider.of<MessagingProvider>(
                                                      context,
                                                      listen: false)
                                                  .deviceToken,
                                          token: Provider.of<UserProvider>(
                                            context,
                                            listen: false,
                                          ).user.apiToken,
                                          postType: widget.type,
                                          postTypeId: widget.type == 'store'
                                              ? widget.store!.id
                                              : widget.product!.id,
                                          description: controller.text,
                                        ).then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: kDarkColor,
                                              content: Text(
                                                value.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .apply(color: Colors.white),
                                              ),
                                            ),
                                          );
                                        });
                                      }
                                    },
                                    child: isLoading
                                        ? LoadingWidget(
                                            color: kDarkColor, size: 40.h)
                                        : LargeButton(
                                            text: widget.isUpdating
                                                ? "تحديث"
                                                : 'نشر',
                                            isButton: false,
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
