import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/ui/common/show_image_view.dart';

class ShowImagesWidget extends StatefulWidget {
  const ShowImagesWidget({super.key, required this.images});
  final List<String> images;

  @override
  State<ShowImagesWidget> createState() => _ShowImagesWidgetState();
}

class _ShowImagesWidgetState extends State<ShowImagesWidget> {
  PageController controller = PageController();
  void nextPage() {
    controller.animateToPage(controller.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    controller.animateToPage(controller.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
        ),
        height: 700.h,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.images.length != 1)
              GestureDetector(
                onTap: () => previousPage(),
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 50.h,
                  color: Colors.white,
                ),
              ),
            5.horizontalSpace,
            Expanded(
              child: PageView.builder(
                controller: controller,
                padEnds: false,
                itemCount: widget.images.length,
                itemBuilder: (context, index) => Hero(
                  transitionOnUserGestures: true,
                  tag: widget.images.first.toString(),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ShowImageView(
                                  imageUrl: widget.images[index],
                                )),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index],
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
              ),
            ),
            5.horizontalSpace,
            if (widget.images.length != 1)
              GestureDetector(
                onTap: () => nextPage(),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 50.h,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
