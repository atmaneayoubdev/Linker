import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/market/views/home_store_view.dart';
import 'package:linker/ui/market/views/home_product_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/my_profile_controller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    getNotificationsCount();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: kDarkColor,
            toolbarHeight: 0.h,
            bottom: TabBar(
                isScrollable: false,
                indicatorColor: Colors.white,
                indicatorPadding: const EdgeInsets.all(2),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5.h,
                enableFeedback: false,
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return states.contains(MaterialState.focused)
                        ? null
                        : Colors.transparent;
                  },
                ),
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: Colors.white),
                tabs: const [
                  Tab(
                    text: 'منتجات',
                  ),
                  Tab(
                    text: 'متاجر',
                  ),
                ]),
          ),
          body: const TabBarView(children: [
            HomeProductView(),
            HomeStoreView(),
          ]),
        ),
      ),
    );
  }
}
