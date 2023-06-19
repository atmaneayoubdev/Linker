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
    _controller.dispose();
    super.dispose();
  }

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
