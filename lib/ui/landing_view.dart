import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/additional/views/favorite_view.dart';
import 'package:linker/ui/home/views/home_view.dart';
import 'package:linker/ui/market/views/market_view.dart';
import 'package:linker/ui/messages/views/chats_view.dart';
import 'package:linker/ui/stories/views/story_view.dart';
import 'common/drawer_widget.dart';
import 'home/components/home_sliver_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LandingView extends StatefulWidget {
  const LandingView({
    Key? key,
    this.pageNbr,
    this.isLogging,
  }) : super(key: key);
  static const String routeName = '/tab';
  static GlobalKey<ScaffoldState> akey = GlobalKey();
  final int? pageNbr;
  final bool? isLogging;

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  int _selectedIndex = 2;
  bool logging = false;
  late DateTime currentBackPressTime;
  // ignore: prefer_typing_uninitialized_variables
  var ctime;

  @override
  void initState() {
    super.initState();
    if (widget.isLogging != null) {
      logging = widget.isLogging!;
    }
    if (widget.pageNbr != null) {
      _selectedIndex = widget.pageNbr!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (ctime == null ||
              now.difference(ctime) > const Duration(seconds: 2)) {
            ctime = now;
            Fluttertoast.showToast(
              msg: "انقر مرة أخرى لإغلاق التطبيق",
              backgroundColor: kDarkColor,
              textColor: Colors.white,
            );
            return Future.value(false);
          }

          return Future.value(true);
        },
        child: Scaffold(
            key: LandingView.akey,
            drawer: const DrawerWIdget(),
            appBar: const HomeSliverAppBar(),
            drawerEnableOpenDragGesture: false,
            bottomNavigationBar: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 70.h,
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(17, 0, 0, 0),
                        offset: Offset(0, 3),
                        blurRadius: 20,
                        spreadRadius: 10)
                  ]),
                ),
                Row(
                  children: [
                    buildNavBarItem("assets/icons/messaging.svg", 0),
                    buildNavBarItem("assets/icons/stories.svg", 1),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            //alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            height: 70.h,
                            width: MediaQuery.of(context).size.width / 5,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(247, 249, 250, 1)),
                            child: Center(
                              child: Container(
                                height: 50.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                  color: kDarkColor,
                                  borderRadius: BorderRadius.circular(40.r),
                                ),
                                child: Center(
                                  child: AnimatedContainer(
                                    curve: Curves.fastOutSlowIn,
                                    height: _selectedIndex == 2 ? 30.h : 20.h,
                                    width: _selectedIndex == 2 ? 30.w : 20.w,
                                    duration: const Duration(milliseconds: 300),
                                    child: SvgPicture.asset(
                                      'assets/icons/home.svg',
                                      height: _selectedIndex == 2 ? 25.h : 20.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //5.verticalSpace,
                        ],
                      ),
                    ),
                    buildNavBarItem("assets/icons/market.svg", 3),
                    buildNavBarItem("assets/icons/heart.svg", 4),
                  ],
                ),
                AnimatedPositioned(
                  bottom: 0,
                  left: _selectedIndex == 4
                      ? 0
                      : _selectedIndex == 3
                          ? MediaQuery.of(context).size.width / 5
                          : _selectedIndex == 2
                              ? MediaQuery.of(context).size.width / 5 * 2
                              : _selectedIndex == 1
                                  ? MediaQuery.of(context).size.width / 5 * 3
                                  : MediaQuery.of(context).size.width / 5 * 4,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Center(
                      child: SvgPicture.asset('assets/icons/footer_icon.svg',
                          height: 8.h,
                          width: 25.w,
                          colorFilter: const ColorFilter.mode(
                              kDarkColor, BlendMode.srcIn)),
                    ),
                  ),
                )
              ],
            ),
            body: _selectedIndex == 0
                ? const SafeArea(child: ChatsView())
                : _selectedIndex == 1
                    ? const SafeArea(child: StoryView())
                    : _selectedIndex == 3
                        ? const SafeArea(child: MarketView())
                        : _selectedIndex == 4
                            ? const SafeArea(child: FavoriteView())
                            : SafeArea(child: HomeView(isLogging: logging))),
      ),
    );
  }

  buildNavBarItem(String icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          logging = false;
          _selectedIndex = index;
        });
      },
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 70.h,
              width: MediaQuery.of(context).size.width / 5,
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(247, 249, 250, 1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    //scale: _animation,
                    curve: Curves.fastOutSlowIn,
                    height: _selectedIndex == index ? 35.h : 30.h,
                    width: _selectedIndex == index ? 35.w : 30.w,
                    duration: const Duration(milliseconds: 300),
                    child: SvgPicture.asset(
                      icon,
                      height: _selectedIndex == index ? 35.h : 30.h,
                      width: _selectedIndex == index ? 35.w : 30.w,
                      colorFilter: ColorFilter.mode(
                        _selectedIndex == index
                            ? kDarkColor
                            : const Color.fromRGBO(158, 167, 183, 1),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: index == 2 ? 0.h : 5.h,
                  ),
                  Text(
                    index == 0
                        ? "رسائل"
                        : index == 1
                            ? "القصص"
                            : index == 3
                                ? "سوق"
                                : index == 4
                                    ? "المفضلة"
                                    : "",
                    style: GoogleFonts.tajawal(
                      fontSize: 13.sp,
                      fontWeight: _selectedIndex == index
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: _selectedIndex == index
                          ? kDarkColor
                          : const Color.fromRGBO(158, 167, 183, 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
