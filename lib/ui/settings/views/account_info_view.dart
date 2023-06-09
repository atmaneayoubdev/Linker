import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:provider/provider.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../common/loading_widget.dart';
import 'package:image_cropper/image_cropper.dart';

class AccountInfoView extends StatefulWidget {
  const AccountInfoView({super.key});

  @override
  State<AccountInfoView> createState() => _AccountInfoViewState();
}

class _AccountInfoViewState extends State<AccountInfoView> {
  TextEditingController usernameContoller = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  File? image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future updateAccountInfo() async {
    setState(() {
      isLoading = true;
    });
    await MyProfileController.editAcocuntInfo(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      username: usernameContoller.text,
      jobTitle: jobTitleController.text,
      bio: bioController.text,
    ).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value["result"] == true) {
        Provider.of<UserProvider>(context, listen: false)
            .setUser(value["user"]);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: value["result"] == true ? kDarkColor : Colors.red,
          content: Text(
            value["message"],
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: Colors.white),
          ),
        ),
      );
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future updateAccountImage() async {
    setState(() {
      isLoading = true;
    });
    await MyProfileController.editAccountPicture(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      image: image!,
    ).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value["result"] == true) {
        Provider.of<UserProvider>(context, listen: false)
            .setUser(value["user"]);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: value["result"] == true ? kDarkColor : Colors.red,
          content: Text(
            value["message"],
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context);
    });
  }

  Future cropAndSave(String path) async {
    await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: kBleuColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          statusBarColor: kBleuColor,
          activeControlsWidgetColor: kBleuColor,
        ),
        IOSUiSettings(
          title: '',
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          image = File(value.path);
        });
      }
    });
  }

  @override
  void initState() {
    jobTitleController.text =
        Provider.of<UserProvider>(context, listen: false).user.jobTitle;
    usernameContoller.text =
        Provider.of<UserProvider>(context, listen: false).user.userName;
    bioController.text =
        Provider.of<UserProvider>(context, listen: false).user.bio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(248, 248, 248, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38.r),
                    topRight: Radius.circular(38.r),
                  ),
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  //padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38.r),
                      topRight: Radius.circular(38.r),
                    ),
                    color: const Color.fromRGBO(250, 250, 250, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 77.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 23.h),
                        decoration: BoxDecoration(
                          color: klighSkyBleu,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(38.r),
                              topRight: Radius.circular(38.r)),
                        ),
                        child: Stack(children: [
                          Center(
                            child: Text(
                              'معلومات الحساب',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: BackButtonWidget(),
                          )
                        ]),
                      ),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: const Color.fromRGBO(250, 250, 250, 1),
                          padding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 13.w,
                          ),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  26.verticalSpace,
                                  Container(
                                    height: 141.h,
                                    width: 141.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(223, 228, 232, 1),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Container(
                                            height: 132.h,
                                            width: 132.w,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: kLighLightGreyColor,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: image == null
                                                  ? CachedNetworkImage(
                                                      imageUrl: Provider.of<
                                                          UserProvider>(
                                                        context,
                                                        listen: true,
                                                      ).user.avatar,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              SvgPicture.asset(
                                                        'assets/icons/contact.svg',
                                                        height: 41.h,
                                                        colorFilter:
                                                            const ColorFilter
                                                                    .mode(
                                                                Color.fromRGBO(
                                                                    223,
                                                                    228,
                                                                    232,
                                                                    1),
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Center(
                                                        child: SvgPicture.asset(
                                                          'assets/icons/contact.svg',
                                                          height: 41.h,
                                                          colorFilter:
                                                              const ColorFilter
                                                                      .mode(
                                                                  Color
                                                                      .fromRGBO(
                                                                          223,
                                                                          228,
                                                                          232,
                                                                          1),
                                                                  BlendMode
                                                                      .srcIn),
                                                        ),
                                                      ),
                                                    )
                                                  : Image.file(
                                                      image!,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                        if (image != null)
                                          Positioned(
                                            top: 10.h,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  image = null;
                                                });
                                              },
                                              child: Container(
                                                height: 34.h,
                                                width: 34.w,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    boxShadow: []),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.clear,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        Positioned(
                                            bottom: 10.h,
                                            child: GestureDetector(
                                              onTap: () async {
                                                showDialog<String>(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (BuildContext ctx) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      content: Container(
                                                        padding: EdgeInsets.all(
                                                            10.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            11.r,
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      "camera"),
                                                              child: Container(
                                                                height: 80.h,
                                                                width: 80.w,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      kDarkColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              11.r),
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .camera_alt_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 50.h,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      "gallery"),
                                                              child: Container(
                                                                height: 80.h,
                                                                width: 80.w,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      kDarkColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              11.r),
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .image_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 50.h,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) async {
                                                  if (value.runtimeType ==
                                                      String) {
                                                    if (value == "camera") {
                                                      await _picker
                                                          .pickImage(
                                                        source:
                                                            ImageSource.camera,
                                                      )
                                                          .then((value) {
                                                        if (value != null) {
                                                          cropAndSave(
                                                              value.path);
                                                        }
                                                      });
                                                    }
                                                    if (value == 'gallery') {
                                                      await _picker
                                                          .pickImage(
                                                        source:
                                                            ImageSource.gallery,
                                                      )
                                                          .then((value) {
                                                        if (value != null) {
                                                          cropAndSave(
                                                              value.path);
                                                        }
                                                      });
                                                    }
                                                  } else {
                                                    return;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 34.h,
                                                width: 34.w,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kBleuColor,
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    'assets/icons/pen.svg',
                                                  ),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  36.verticalSpace,
                                  TextFormField(
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    controller: usernameContoller,
                                    decoration: formFieldDecoration!.copyWith(
                                      label: Text(
                                        "اسم المستخدم",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace,
                                  TextFormField(
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    controller: jobTitleController,
                                    decoration: formFieldDecoration!.copyWith(
                                      label: Text(
                                        "تخصصك المهني أو نشاطك التجاري",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace,
                                  SizedBox(
                                    height: 200.h,
                                    child: TextFormField(
                                        expands: true,
                                        maxLines: null,
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        controller: bioController,
                                        decoration:
                                            formFieldDecoration!.copyWith(
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          label: Text(
                                            'السيرة الذاتية',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        )),
                                  ),
                                  100.verticalSpace,
                                  GestureDetector(
                                    onTap: () {
                                      if (image != null) {
                                        updateAccountImage().then((value) {
                                          setState(() {
                                            image = null;
                                          });
                                          if (jobTitleController.text !=
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .user
                                                      .jobTitle ||
                                              usernameContoller.text !=
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .user
                                                      .userName ||
                                              bioController.text !=
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .user
                                                      .bio) updateAccountInfo();
                                        });
                                      }
                                      if (jobTitleController.text !=
                                              Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .user
                                                  .jobTitle ||
                                          usernameContoller.text !=
                                              Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .user
                                                  .userName ||
                                          bioController.text !=
                                              Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .user
                                                  .bio) updateAccountInfo();
                                    },
                                    child: isLoading
                                        ? LoadingWidget(
                                            color: kDarkColor, size: 40.h)
                                        : const LargeButton(
                                            text: 'حفظ', isButton: false),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
