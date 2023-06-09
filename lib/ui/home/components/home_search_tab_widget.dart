import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/constants.dart';

class HomeSearchTabWidget extends StatefulWidget {
  const HomeSearchTabWidget({
    super.key,
    required this.isPosts,
    required this.setUsers,
    required this.setPosts,
  });
  final void Function() setUsers;
  final void Function() setPosts;
  final bool isPosts;

  @override
  State<HomeSearchTabWidget> createState() => _HomeSearchTabWidgetState();
}

class _HomeSearchTabWidgetState extends State<HomeSearchTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      //width: 380.w,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Center(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      widget.setPosts();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 54.h,
                      width: 180.w,
                      decoration: BoxDecoration(
                        color: widget.isPosts ? kDarkColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          'المنشورات',
                          style: Theme.of(context).textTheme.bodySmall!.apply(
                                color:
                                    widget.isPosts ? Colors.white : kDarkColor,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.setUsers();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                      color: widget.isPosts ? Colors.transparent : kDarkColor,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(
                        'المستخدمين',
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color:
                                  !widget.isPosts ? Colors.white : kDarkColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
