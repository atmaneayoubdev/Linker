import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:linker/ui/common/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../../controllers/my_profile_controller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../models/general/specialty_model.dart';
import '../../common/back_button_widget.dart';

class AddStoryView extends StatefulWidget {
  const AddStoryView({super.key});

  @override
  State<AddStoryView> createState() => _AddStoryViewState();
}

class _AddStoryViewState extends State<AddStoryView> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? image;
  final ImagePicker _picker = ImagePicker();
  String currentToken = '';
  List<SpecialtyModel> _specialties = [];
  SpecialtyModel? _selectedSpecialty;
  bool isLoading = false;
  int _total = 0;
  int _count = 0;
  bool isPageLoading = true;

  Future getMySpecialties() async {
    await MyProfileController.getMySpecialties(
            deviceToken: Provider.of<MessagingProvider>(context, listen: false)
                .deviceToken,
            token: currentToken,
            notInt: true)
        .then((value) {
      setState(() {
        _specialties.addAll(value);
      });
    });
  }

  Future getMyInterests() async {
    await MyProfileController.getMyInterests(
      token: currentToken,
      notInt: true,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) {
      _specialties.addAll(value);
      List<SpecialtyModel> temp = [
        ...{..._specialties}
      ];
      _specialties.clear();
      _specialties = temp;
      setState(() {});
      setState(() {
        isPageLoading = false;
      });
    });
  }

  Future createStory({
    required String token,
    required String description,
    required File image,
    required int speciatltyId,
  }) async {
    try {
      Dio dio = Dio();
      String fileName = image.path.split('/').last;

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
        "description": description,
        "specialty_id": speciatltyId,
      });
      var response = await dio.post(
        "${baseUrl}stories",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            'Devices_Token':
                // ignore: use_build_context_synchronously
                Provider.of<MessagingProvider>(context, listen: false)
                    .deviceToken,
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          },
        ),
        onSendProgress: (sent, total) {
          log("$_count + $_total");
          setState(() {
            _total = total;
            _count = sent;
          });
        },
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      }
      if (response.statusCode == 400) {
        return response.data['message'].toString();
      }
    } on DioError catch (error) {
      log(error.toString());
      return error.message;
    }
  }

  @override
  void initState() {
    currentToken =
        Provider.of<UserProvider>(context, listen: false).user.apiToken;
    getMySpecialties().then((value) {
      getMyInterests();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: klighSkyBleu,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 90.h,
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              'إنشاء قصة',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: BackButtonWidget(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: isPageLoading
                          ? const Center(
                              child: LoadingWidget(color: kDarkColor, size: 40),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 24.h,
                                horizontal: 15.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40.r),
                                  bottomRight: Radius.circular(40.r),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(1, 3),
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                    color: Color.fromARGB(10, 0, 0, 0),
                                  )
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      10.verticalSpace,
                                      SizedBox(
                                        height: 40.h,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 40.h,
                                              width: 40.w,
                                              //padding: const EdgeInsets.all(1),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        99999),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      Provider.of<UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .user
                                                          .avatar,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const SizedBox(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const SizedBox(),
                                                ),
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Text(
                                              Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .user
                                                  .userName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .apply(
                                                    color: kGreyColor,
                                                  ),
                                            )
                                          ],
                                        ),
                                      ),
                                      15.verticalSpace,
                                      SizedBox(
                                        height: 300.h,
                                        width: double.infinity,
                                        child: Stack(
                                          children: [
                                            TextFormField(
                                              controller: controller,
                                              expands: true,
                                              maxLines: null,
                                              textAlign: TextAlign.start,
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              decoration:
                                                  formFieldDecoration!.copyWith(
                                                contentPadding:
                                                    const EdgeInsets.all(10),
                                                hintText: 'ماذا تريد أن تدون',
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .apply(
                                                      color: kGreyColor,
                                                    ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "الرجاء كتابة القصة";
                                                }
                                                if (image == null) {
                                                  return "الرجاء إختيار صورة";
                                                }
                                                return null;
                                              },
                                            ),
                                            if (image == null)
                                              Positioned(
                                                bottom: 0.h,
                                                child: SizedBox(
                                                  height: 70.h,
                                                  width: 70.w,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await _picker
                                                          .pickImage(
                                                        source:
                                                            ImageSource.gallery,
                                                      )
                                                          .then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            image = File(
                                                                value.path);
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        height: 45.h,
                                                        width: 45.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: const Color
                                                                    .fromARGB(
                                                                115,
                                                                95,
                                                                167,
                                                                208),
                                                            width: 1.w,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icons/images.svg',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (image != null)
                                              Positioned(
                                                bottom: 0.h,
                                                child: SizedBox(
                                                  height: 70.h,
                                                  width: 70.w,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          height: 45.h,
                                                          width: 45.w,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        300),
                                                            child: Image.file(
                                                              image!,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            image = null;
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            0.5),
                                                                    color: Color
                                                                        .fromARGB(
                                                                            21,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    blurRadius:
                                                                        1,
                                                                    spreadRadius:
                                                                        1,
                                                                  )
                                                                ]),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/icons/cancel.svg',
                                                              height: 25.h,
                                                              width: 25.w,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      10.verticalSpace,
                                      DropdownButtonFormField<SpecialtyModel>(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                        decoration:
                                            formFieldDecoration!.copyWith(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 17.w,
                                            vertical: 10.h,
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(14),
                                            ),
                                            borderSide: BorderSide(
                                              width: 0.3,
                                              color: kGreyColor,
                                            ),
                                          ),
                                        ),
                                        isExpanded: false,
                                        hint: Text(
                                          "نوع القصة",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!,
                                        ),
                                        value: _selectedSpecialty,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: _specialties.map(
                                            (SpecialtyModel specialtyModel) {
                                          return DropdownMenuItem(
                                            value: specialtyModel,
                                            child: Text(
                                              specialtyModel.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!,
                                            ),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return "الجاء إختيار مدار";
                                          }
                                          return null;
                                        },
                                        onChanged:
                                            (SpecialtyModel? newSpecialty) {
                                          setState(() {
                                            _selectedSpecialty = newSpecialty!;
                                          });
                                        },
                                      ),
                                      20.verticalSpace,
                                      Text(
                                        "إختر من المدارات المختارة سبقا ضمن تخصصك المهني أو نشاطك التجاري أو إهتماماتك",
                                        overflow: TextOverflow.clip,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .apply(color: kLightBlackColor)
                                            .copyWith(height: 1.5),
                                      ),
                                      50.verticalSpace,
                                      GestureDetector(
                                        onTap: () async {
                                          if (_formKey.currentState!
                                                  .validate() &&
                                              image != null) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await createStory(
                                              token: Provider.of<UserProvider>(
                                                      context,
                                                      listen: false)
                                                  .user
                                                  .apiToken,
                                              description: controller.text,
                                              image: image!,
                                              speciatltyId: int.parse(
                                                  _selectedSpecialty!.id),
                                            ).then((value) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              if (value == "تم نشر قصتك") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                        seconds: 3),
                                                    backgroundColor: kDarkColor,
                                                    content: Text(
                                                      value.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .apply(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                );
                                                Navigator.pop(context, true);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                        seconds: 3),
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                      value.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .apply(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                );
                                              }
                                            });
                                          }
                                        },
                                        child: isLoading
                                            ? const LoadingWidget(
                                                color: kDarkColor, size: 30)
                                            : const LargeButton(
                                                text: 'نشر',
                                                isButton: false,
                                              ),
                                      ),
                                      50.verticalSpace,
                                      //if (_count != 0)
                                      // SizedBox(
                                      //   height: 10,
                                      //   width: 300,
                                      //   child: Stack(
                                      //     children: [
                                      //       Container(
                                      //         height: 10,
                                      //         width: 400.h,
                                      //         decoration: BoxDecoration(
                                      //             color: kLightGreyColor,
                                      //             borderRadius:
                                      //                 BorderRadius.circular(11)),
                                      //       ),
                                      //       AnimatedContainer(
                                      //         decoration: BoxDecoration(
                                      //             color: kDarkColor,
                                      //             borderRadius:
                                      //                 BorderRadius.circular(11)),
                                      //         duration:
                                      //             const Duration(milliseconds: 50),
                                      //         height: 10,
                                      //         width:
                                      //             _count.toDouble() * 400.h / _total,
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
