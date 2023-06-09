import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/auth_controller.dart';
import 'package:linker/controllers/global_contoller.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/models/general/specialty_model.dart';
import 'package:linker/ui/auth/components/fields_item_widget.dart';
import 'package:linker/ui/auth/components/interest_shimmer.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:linker/ui/landing_view.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';
import '../../common/loading_widget.dart';
import '../components/fields_header_widget.dart';
import '../components/fields_shimmer.dart';
import '../components/interest_item_widget.dart';

class FieldsAndInterestView extends StatefulWidget {
  const FieldsAndInterestView({
    super.key,
    required this.isFromDrawer,
    this.username,
    this.jobTitle,
    this.email,
    this.passwrod,
    this.phone,
    this.token,
  });
  final bool isFromDrawer;
  final String? username;
  final String? jobTitle;
  final String? email;
  final String? passwrod;
  final String? phone;
  final String? token;

  @override
  State<FieldsAndInterestView> createState() => _FieldsAndInterestViewState();
}

class _FieldsAndInterestViewState extends State<FieldsAndInterestView> {
  int index = 1;
  List<int> _selectedSpecialies = [];
  List<int> _selectedInterests = [];

  List<SpecialtyModel> _specialties = [];
  bool isLoading = false;
  String currentToken = '';

  Future getSpecialties() async {
    await GlobalController.getSpecialies().then((value) {
      if (mounted) {
        setState(() {
          value.removeAt(0);
          _specialties = value;
        });
      }
    });
  }

  Future getMySpecialties() async {
    await MyProfileController.getMySpecialties(
      token: currentToken,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) {
      if (value.runtimeType == List<int>) {
        setState(() {
          _selectedSpecialies = value;
        });
      }
    });
  }

  Future getMyInterests() async {
    await MyProfileController.getMyInterests(
      token: currentToken,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) {
      if (value.runtimeType == List<int>) {
        setState(() {
          _selectedInterests = value;
        });
      }
    });
  }

  Future editMySpecialties() async {
    await MyProfileController.editSpecialties(
      specialties: _selectedSpecialies,
      token: currentToken,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) async {
      if (value == 'success') {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 1000),
            content: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(color: Colors.white),
            ),
          ),
        );
      }
    });
  }

  Future editMyInterests() async {
    await MyProfileController.editInterest(
      specialties: _selectedInterests,
      token: currentToken,
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
    ).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value == 'success') {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 1000),
            content: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(color: Colors.white),
            ),
          ),
        );
        //Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    currentToken =
        Provider.of<UserProvider>(context, listen: false).user.apiToken;
    if (widget.isFromDrawer) {
      getMySpecialties().then((value) {
        getMyInterests().then((value) {
          log(_selectedInterests.toString());
          getSpecialties();
        });
      });
    } else {
      getSpecialties();
      log(widget.phone!.toString());
    }
    Provider.of<MessagingProvider>(context, listen: false).getToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(248, 248, 248, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 24.h,
                    horizontal: 15.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.r),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(1, 3),
                        blurRadius: 5,
                        spreadRadius: 5,
                        color: Color.fromARGB(10, 0, 0, 0),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          FieldsHeaderWidget(index: index),
                          22.verticalSpace,
                          index == 1
                              ? Expanded(
                                  child: _specialties.isEmpty
                                      ? const FieldsShimmer()
                                      : ListView.separated(
                                          padding: EdgeInsets.zero,
                                          itemCount: _specialties.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return 10.verticalSpace;
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            SpecialtyModel specialty =
                                                _specialties[index];
                                            return FieldsItemWidget(
                                              specialtyModel: specialty,
                                              isSelected:
                                                  _selectedSpecialies.contains(
                                                int.parse(specialty.id),
                                              ),
                                              onPress: () {
                                                if (_selectedSpecialies.length <
                                                    3) {
                                                  if (_selectedSpecialies
                                                      .contains(int.parse(
                                                          specialty.id))) {
                                                    _selectedSpecialies.remove(
                                                        int.parse(
                                                            specialty.id));
                                                  } else {
                                                    _selectedSpecialies.add(
                                                        int.parse(
                                                            specialty.id));
                                                  }
                                                } else {
                                                  if (_selectedSpecialies
                                                      .contains(int.parse(
                                                          specialty.id))) {
                                                    _selectedSpecialies.remove(
                                                        int.parse(
                                                            specialty.id));
                                                  }
                                                }
                                                setState(() {});
                                                log(_selectedSpecialies
                                                    .toString());
                                              },
                                            );
                                          },
                                        ),
                                )
                              : Expanded(
                                  child: _specialties.isEmpty
                                      ? const InterestShimmer()
                                      : ListView.separated(
                                          padding: EdgeInsets.zero,
                                          itemCount: _specialties.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return 10.verticalSpace;
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            SpecialtyModel specialty =
                                                _specialties[index];
                                            return InterestItemWidget(
                                              specialtyModel: specialty,
                                              isSelected:
                                                  _selectedInterests.contains(
                                                int.parse(specialty.id),
                                              ),
                                              onPress: () {
                                                if (_selectedInterests.length <
                                                    3) {
                                                  if (_selectedInterests
                                                      .contains(int.parse(
                                                          specialty.id))) {
                                                    _selectedInterests.remove(
                                                        int.parse(
                                                            specialty.id));
                                                  } else {
                                                    _selectedInterests.add(
                                                        int.parse(
                                                            specialty.id));
                                                  }
                                                } else {
                                                  if (_selectedInterests
                                                      .contains(int.parse(
                                                          specialty.id))) {
                                                    _selectedInterests.remove(
                                                        int.parse(
                                                            specialty.id));
                                                  }
                                                }
                                                setState(() {});
                                                log(_selectedInterests
                                                    .toString());
                                              },
                                            );
                                          },
                                        ),
                                ),
                          60.verticalSpace,
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () async {
                            if (index == 1) {
                              index = 2;
                              setState(() {});
                            } else {
                              if (widget.isFromDrawer) {
                                setState(() {
                                  isLoading = true;
                                });
                                editMySpecialties().then((value) {
                                  editMyInterests();
                                });
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                debugPrint(widget.token.toString());
                                await AuthController.register(
                                  usernme: widget.username!,
                                  jobTitle: widget.jobTitle!,
                                  email: widget.email!,
                                  password: widget.passwrod!,
                                  deviceToken: Provider.of<MessagingProvider>(
                                    context,
                                    listen: false,
                                  ).deviceToken,
                                  specialies: _selectedSpecialies,
                                  interests: _selectedInterests,
                                  token: widget.token!,
                                  phone: widget.phone!,
                                ).then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (value['message'] ==
                                      "أهلا وسهلا بك , شكرا علي الإنضمام لدينا") {
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .setUser(value["user"]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: kDarkColor,
                                        content: Text(
                                          value['message'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .apply(color: Colors.white),
                                        ),
                                      ),
                                    );
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LandingView(
                                            pageNbr: 2,
                                            isLogging: true,
                                          ),
                                        ),
                                        (route) => false);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          value['message'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .apply(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                });
                              }
                            }
                          },
                          child: isLoading
                              ? LoadingWidget(color: kDarkColor, size: 40.h)
                              : LargeButton(
                                  text: index == 1 ? 'استمرار' : 'تاكيد',
                                  isButton: false,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
