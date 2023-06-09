import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/global_contoller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/helpers/user_provider.dart';
import 'package:linker/ui/common/back_button_widget.dart';
import 'package:linker/ui/common/large_button.dart';
import 'package:provider/provider.dart';

import '../../../helpers/messaging_provider.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
                        height: 77,
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
                              'المساعده والدعم',
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
                            child: Column(
                              children: [
                                40.verticalSpace,
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'من فضلك اكتب رسالتك هنا',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                20.verticalSpace,
                                SizedBox(
                                  height: 320.h,
                                  width: 409.w,
                                  child: TextFormField(
                                    controller: controller,
                                    expands: true,
                                    maxLines: null,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: formFieldDecoration!.copyWith(
                                      errorStyle: const TextStyle(height: 0),
                                      contentPadding: const EdgeInsets.all(10),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .apply(
                                            color: kGreyColor,
                                          ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'من فضلك اكتب رسالتك';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await GlobalController.sendMessage(
                                                deviceToken: Provider.of<
                                                            MessagingProvider>(
                                                        context,
                                                        listen: false)
                                                    .deviceToken,
                                                token:
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user
                                                        .apiToken,
                                                text: controller.text)
                                            .then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: kDarkColor,
                                                  content: Text(
                                                    value,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .apply(
                                                            color:
                                                                Colors.white),
                                                  )));
                                        });
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: kDarkColor,
                                            ),
                                          )
                                        : const LargeButton(
                                            text: "ارسال", isButton: false)),
                                40.verticalSpace,
                              ],
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
