import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linker/controllers/story_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:linker/ui/common/loading_widget.dart';
import 'package:linker/ui/stories/components/add_list_item.dart';
import 'package:provider/provider.dart';
import '../../../controllers/global_contoller.dart';
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

  List<File> images = [];
  final ImagePicker _picker = ImagePicker();
  String currentToken = '';
  List<SpecialtyModel> _specialties = [];
  SpecialtyModel? _selectedSpecialty;
  bool isLoading = false;

  bool isPageLoading = true;
  bool isError = false;

  Future getSpecialties() async {
    await GlobalController.getSpecialies().then((value) {
      if (mounted) {
        setState(() {
          value.removeAt(0);
          _specialties = value;
          isPageLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    currentToken =
        Provider.of<UserProvider>(context, listen: false).user.apiToken;
    getSpecialties();

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
                                        height: 400.h,
                                        width: 400.w,
                                        child: Stack(
                                          children: [
                                            TextFormField(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!,
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
                                                    .titleMedium!
                                                    .apply(
                                                      color: kGreyColor,
                                                    ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  setState(() {
                                                    isError = true;
                                                  });
                                                  return "الرجاء كتابة القصة";
                                                }
                                                if (images.isEmpty) {
                                                  setState(() {
                                                    isError = true;
                                                  });
                                                  return "الرجاء إختيار صورة";
                                                }
                                                return null;
                                              },
                                            ),
                                            if (images.isEmpty)
                                              Positioned(
                                                bottom: isError ? 30.h : 0.h,
                                                child: SizedBox(
                                                  height: 70.h,
                                                  width: 70.w,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await _picker
                                                          .pickMultiImage()
                                                          .then((value) {
                                                        if (value.isNotEmpty) {
                                                          setState(() {
                                                            for (XFile x
                                                                in value) {
                                                              images.add(
                                                                  File(x.path));
                                                            }
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
                                            if (images.isNotEmpty)
                                              Positioned(
                                                bottom: isError ? 30.h : 0.h,
                                                child: SizedBox(
                                                  height: 70.h,
                                                  width: 395.w,
                                                  child: ListView.separated(
                                                    itemCount: images.length,
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.only(
                                                        left: 20.w),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return AddStoryListItem(
                                                          deleteImg: () {
                                                            images.removeAt(
                                                                index);
                                                            setState(() {});
                                                          },
                                                          image: images[index]);
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return 3.horizontalSpace;
                                                    },
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
                                              images.isNotEmpty) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await StoryController.createStory(
                                              token: Provider.of<UserProvider>(
                                                      context,
                                                      listen: false)
                                                  .user
                                                  .apiToken,
                                              description: controller.text,
                                              images: images,
                                              speciatltyId: int.parse(
                                                  _selectedSpecialty!.id),
                                              deviceToken: Provider.of<
                                                          MessagingProvider>(
                                                      context,
                                                      listen: false)
                                                  .deviceToken,
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
                                                            color: Colors.white,
                                                          ),
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
