import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String baseUrl = "http://linker-beta.tufahatin-sa.com/api/";

const Color kDarkColor = Color.fromRGBO(33, 37, 49, 1);
const Color kBleuColor = Color.fromRGBO(69, 169, 212, 1);
const Color kTextColor = Color.fromRGBO(26, 32, 46, 1);
const Color klighTextColor = Color.fromRGBO(158, 167, 183, 1);

const Color kOrangeColor = Color.fromRGBO(231, 152, 30, 1);
const Color kLightOrangeColor = Color.fromRGBO(252, 244, 231, 1);
const Color kGreenColor = Color.fromRGBO(0, 235, 109, 1);
const Color kGreyColor = Color.fromRGBO(112, 112, 112, 1);

const Color kLightBlackColor = Color.fromRGBO(150, 150, 150, 1);
const Color kDarkGreyColor = Color.fromRGBO(74, 81, 96, 1);
const Color kLightGreyColor = Color.fromRGBO(234, 234, 234, 1);
const Color kLighLightGreyColor = Color.fromRGBO(244, 244, 244, 1);
const Color klighColor = Color.fromARGB(8, 8, 8, 8);
const Color klighSkyBleu = Color.fromRGBO(247, 249, 251, 1);

Gradient kVerticalGradiant = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color.fromARGB(0, 255, 255, 255),
    Color.fromRGBO(0, 0, 0, 0.65),
  ],
);

InputDecoration? formFieldDecoration = InputDecoration(
  errorMaxLines: 3,
  counterText: "",
  filled: true,
  fillColor: Colors.transparent,
  floatingLabelBehavior: FloatingLabelBehavior.always,
  focusColor: kGreyColor,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.r)),
    borderSide: const BorderSide(
      //width: 1,
      color: kGreyColor,
    ),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.r)),
    borderSide: const BorderSide(
      //width: 1,
      color: kLightGreyColor,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.r)),
    borderSide: const BorderSide(
      //width: 1,
      color: kLightGreyColor,
    ),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.r)),
    borderSide: const BorderSide(width: 1, color: kLightGreyColor),
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.r)),
      borderSide: const BorderSide(
        // width: 1,
        color: Colors.red,
      )),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.r)),
    borderSide: const BorderSide(
      width: 1,
      color: Colors.red,
    ),
  ),
);
