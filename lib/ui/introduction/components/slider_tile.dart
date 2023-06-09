import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SlideTile extends StatefulWidget {
  String imagePath, desc;

  SlideTile({Key? key, required this.imagePath, required this.desc})
      : super(key: key);

  @override
  State<SlideTile> createState() => _SlideTileState();
}

class _SlideTileState extends State<SlideTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: CachedNetworkImage(
          imageUrl: widget.imagePath,
          fit: BoxFit.fill,
          placeholder: (context, url) => const Center(
            child: SizedBox(),
          ),
          errorWidget: (context, url, error) => const Center(
            child: SizedBox(),
          ),
        ));
  }
}
