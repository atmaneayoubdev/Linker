import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/ui/market/views/product_view.dart';

import '../../../helpers/constants.dart';

class MessageProductWidget extends StatefulWidget {
  const MessageProductWidget({
    Key? key,
    required this.isFav,
    required this.from,
    required this.canNavigat,
    required this.cover,
    required this.name,
    required this.id,
  }) : super(key: key);
  final bool isFav;
  final String from;
  final String cover;
  final String name;
  final bool canNavigat;
  final String id;

  @override
  State<MessageProductWidget> createState() => _MessageProductWidgetState();
}

class _MessageProductWidgetState extends State<MessageProductWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.canNavigat
            ? () {
                Navigator.of(context).push<bool>(MaterialPageRoute(
                  builder: ((context) => ProductView(
                        from: widget.from,
                        productId: widget.id,
                      )),
                ));
              }
            : null,
        child: Container(
          height: 200.h,
          width: double.infinity,
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
            children: [
              Container(
                height: 163.w,
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
                          imageUrl: widget.cover.toString(),
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
                  ],
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
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
