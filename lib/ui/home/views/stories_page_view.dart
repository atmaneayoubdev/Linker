import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linker/models/general/story_model.dart';

import '../../stories/views/show_story_view.dart';

class StoriesPageView extends StatefulWidget {
  const StoriesPageView(
      {super.key, required this.stories, required this.initialIndex});
  final List<StroyModel> stories;
  final int initialIndex;

  @override
  State<StoriesPageView> createState() => _StoriesPageViewState();
}

class _StoriesPageViewState extends State<StoriesPageView> {
  bool hasChanged = false;
  bool canShow = true;

  late PageController _controller;
  //late Timer timer;
  @override
  void initState() {
    super.initState();
    _controller =
        PageController(initialPage: widget.initialIndex, keepPage: false);
    // _startTimer();
  }

  @override
  void dispose() {
    //timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  // void _startTimer() {
  //   timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
  //     if (_controller.page == widget.stories.length - 1) {
  //       timer.cancel();
  //       Navigator.pop(context, hasChanged);
  //     } else {
  //       _controller.nextPage(
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   });
  // }

  // void _onPageChanged(int pageIndex) {
  //   resetTimer();
  // }

  // void resetTimer() {
  //   timer.cancel();
  //   _startTimer();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () {
        return Future.delayed(Duration.zero, () {
          Navigator.pop(context, hasChanged);
          return false;
        });
      },
      child: PageView.builder(
          controller: _controller,
          //onPageChanged: _onPageChanged,
          onPageChanged: (d) {},
          itemCount: widget.stories.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return GestureDetector(
              onLongPressEnd: (details) => setState(() {
                canShow = true;
                debugPrint('Press Ended');
              }),
              onLongPressStart: (details) => setState(() {
                canShow = false;
                debugPrint('Press Started');
              }),
              child: ShowStoryView(
                canShow: canShow,
                story: widget.stories.elementAt(index),
                didChange: (state) {
                  setState(() {
                    hasChanged = state;
                    debugPrint(state.toString());
                  });
                },
              ),
            );
          }),
    ));
  }
}
