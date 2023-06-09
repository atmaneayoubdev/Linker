import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/ui/home/components/circle_max_length.dart';

import '../../../helpers/constants.dart';

class PostInputWidtet extends StatefulWidget {
  const PostInputWidtet({
    super.key,
    required this.formKey,
    required this.controller,
    required this.onRemovePost,
    required this.isFromThread,
    required this.isFirst,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final Function onRemovePost;
  final bool isFromThread;
  final bool isFirst;

  @override
  State<PostInputWidtet> createState() => _PostInputWidtetState();
}

class _PostInputWidtetState extends State<PostInputWidtet> {
  int currentLength = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 200.h,
            width: double.infinity,
            child: Stack(
              children: [
                TextFormField(
                  controller: widget.controller,
                  expands: true,
                  maxLines: null,
                  maxLength: 286,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  onChanged: (value) {
                    setState(() {
                      currentLength = value.length;
                    });
                    widget.formKey.currentState!.validate();
                  },
                  decoration: formFieldDecoration!.copyWith(
                    errorStyle: const TextStyle(height: 0),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'ماذا تريد أن تدون',
                    hintStyle: Theme.of(context).textTheme.bodyLarge!.apply(
                          color: kGreyColor,
                        ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }

                    return null;
                  },
                ),
                CircleMaxlength(
                  length: widget.controller.value.text.length,
                ),
              ],
            ),
          ),
        ),
        if (!widget.isFirst)
          GestureDetector(
            onTap: () {
              widget.onRemovePost();
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 20.h,
                width: 20.w,
                //padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 5,
                          spreadRadius: 5,
                          color: kLighLightGreyColor),
                    ]),
                child: Center(
                  child: Icon(
                    Icons.clear,
                    color: Colors.red,
                    size: 15.h,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
