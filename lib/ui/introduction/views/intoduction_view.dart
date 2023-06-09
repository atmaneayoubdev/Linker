import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/intros_provider.dart';
import 'package:linker/models/general/intro_model.dart';
import 'package:linker/ui/auth/views/signin_view.dart';
import 'package:provider/provider.dart';
import '../../common/large_button.dart';
import '../components/slider_model.dart';
import 'package:percent_indicator/percent_indicator.dart';

class IntrodictionView extends StatefulWidget {
  const IntrodictionView({super.key});

  @override
  State<IntrodictionView> createState() => _IntrodictionViewState();
}

class _IntrodictionViewState extends State<IntrodictionView> {
  List<SliderModel> mySLides = <SliderModel>[];
  int slideIndex = 0;
  PageController? controller;
  List<IntroModel> intros = [];

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: !isCurrentPage ? 10.h : 23.h,
      width: 5.w,
      decoration: isCurrentPage
          ? BoxDecoration(
              color: kBleuColor,
              borderRadius: BorderRadius.circular(12),
            )
          : BoxDecoration(
              color: kLightGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    mySLides = getSlides();
    controller = PageController();
    intros = Provider.of<IntroProvider>(context, listen: false).intros;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        SizedBox(
          //height: 510.h,
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 5 / 6,
            child: PageView(
              padEnds: false,
              pageSnapping: true,
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  slideIndex = index;
                });
              },
              children: [
                for (var i in intros)
                  Container(
                      color: kDarkColor,
                      child: CachedNetworkImage(
                        imageUrl: i.image,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: SizedBox(),
                        ),
                      ))
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                controller!.animateToPage(intros.length,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.linear);
              },
              child: Container(
                height: 33.h,
                margin: EdgeInsets.symmetric(vertical: 75.h, horizontal: 30.w),
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: kDarkGreyColor,
                  borderRadius: BorderRadius.circular(17.r),
                ),
                child: Text(
                  'تخطي',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            300.verticalSpace,
            Center(
              child: Container(
                alignment: Alignment.center,
                width: 367.w,
                height: 200.h,
                padding: EdgeInsets.all(20.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(7, 0, 0, 0),
                        offset: Offset(0, 3),
                        blurRadius: 5,
                        spreadRadius: 5,
                      )
                    ]),
                child: Text(
                  intros[slideIndex].description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            // 51.verticalSpace,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < intros.length; i++)
                        i == slideIndex
                            ? _buildPageIndicator(true)
                            : _buildPageIndicator(false),
                    ],
                  ),
                  34.verticalSpace,
                  if (slideIndex < intros.length - 1)
                    Center(
                      child: SizedBox(
                        height: 80.h,
                        width: 80.w,
                        child: Stack(
                          children: [
                            CircularPercentIndicator(
                              radius: 40.h,
                              lineWidth: 2.h,
                              percent: (((slideIndex + 1) * 100) /
                                  intros.length *
                                  .01),
                              animation: true,
                              addAutomaticKeepAlive: true,
                              animateFromLastPercent: true,
                              backgroundColor: kLighLightGreyColor,
                              center: Container(
                                height: 60.h,
                                width: 60.w,
                                padding: EdgeInsets.all(5.h),
                                decoration: const BoxDecoration(
                                  color: kDarkColor,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (slideIndex < intros.length) {
                                        slideIndex++;
                                        controller!.animateToPage(
                                          slideIndex,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.linear,
                                        );
                                      }
                                    });
                                  },
                                  child: const FittedBox(
                                    child: Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              progressColor: kDarkColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (slideIndex == intros.length - 1)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInView()),
                            (route) => false);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 45.w),
                        child: const LargeButton(
                          text: "ابدأ الآن",
                          isButton: false,
                        ),
                      ),
                    ),
                  20.verticalSpace,
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
