import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linker/controllers/my_profile_controller.dart';
import 'package:linker/helpers/constants.dart';
import 'package:linker/models/general/specialty_model.dart';
import 'package:linker/models/general/story_model.dart';
import 'package:linker/ui/stories/components/story_grid_widget.dart';
import 'package:linker/ui/stories/components/story_shimmer.dart';
import 'package:linker/ui/stories/components/story_specialty_shimmer.dart';
import 'package:linker/ui/stories/views/add_story_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/global_contoller.dart';
import '../../../controllers/story_controller.dart';
import '../../../helpers/messaging_provider.dart';
import '../../../helpers/user_provider.dart';
import '../../home/views/stories_page_view.dart';
import '../components/story_category_widget.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  TextEditingController searchController = TextEditingController();
  List<SpecialtyModel> _specialties = [];
  SpecialtyModel? _selectedSpecialty;
  List<StroyModel> _stories = [];
  bool isLoading = false;
  SpecialtyModel allSpecialties =
      SpecialtyModel(name: 'الكل', id: '', image: '', description: '');
  bool isCatLoading = false;

  Future getSpecialties() async {
    setState(() {
      isCatLoading = true;
    });
    await GlobalController.getSpecialies().then((value) {
      if (mounted) {
        setState(() {
          _specialties = value;
          _specialties.insert(0, allSpecialties);
          _selectedSpecialty = _specialties.first;
          isCatLoading = false;
        });
      }
    });
  }

  Future getNotificationsCount() async {
    await MyProfileController.getNotificationsCount(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      Provider.of<UserProvider>(context, listen: false)
          .setUserNotifications(value);
    });
  }

  Future getStories(String? specialtyId) async {
    setState(() {
      isLoading = true;
    });
    await StoryController.getAllStories(
      deviceToken:
          Provider.of<MessagingProvider>(context, listen: false).deviceToken,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      specialtyId: specialtyId,
    ).then((value) {
      setState(() {
        _stories = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getNotificationsCount();
    getSpecialties();
    getStories(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => const AddStoryView()))).then((value) {
            if (value == true) {
              getStories(null);
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          height: 60.h,
          width: 60.w,
          decoration: const BoxDecoration(
              color: kBleuColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(5, 0, 0, 0),
                  blurRadius: 10,
                  spreadRadius: 10,
                  offset: Offset(0, 0),
                )
              ]),
          child: const FittedBox(
            child: Icon(
              Icons.add_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          displacement: 0,
          onRefresh: () async {
            getNotificationsCount();

            getSpecialties();
            getStories(null);
          },
          color: kDarkColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                13.verticalSpace,
                SizedBox(
                  height: 60.h,
                  width: double.infinity,
                  child: isCatLoading
                      ? const StorySpecialtyShimmer()
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _specialties.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return 9.horizontalSpace;
                          },
                          itemBuilder: (BuildContext context, int index) {
                            SpecialtyModel specialty = _specialties[index];

                            return GestureDetector(
                                onTap: () {
                                  if (_selectedSpecialty != specialty) {
                                    _selectedSpecialty = specialty;
                                    setState(() {});
                                    specialty.name == "الكل"
                                        ? getStories(null)
                                        : getStories(specialty.id);
                                  }
                                },
                                child: StoryCategoryWidget(
                                  isSelected: _selectedSpecialty == specialty,
                                  name: specialty.name,
                                ));
                          },
                        ),
                ),
                13.verticalSpace,
                if (isLoading)
                  const StoryShimmer(
                    isHome: false,
                  ),
                if (!isLoading)
                  _stories.isEmpty
                      ? SizedBox(
                          height: 600.h,
                          child: Center(
                            child: Text(
                              'لا توجد قصص لعرضها',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 9.w,
                              mainAxisSpacing: 16.h,
                              mainAxisExtent: 328.h,
                            ),
                            itemCount: _stories.length,
                            itemBuilder: (BuildContext context, int index) {
                              StroyModel story = _stories[index];
                              return StoryGridWidget(
                                story: story,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoriesPageView(
                                          stories: _stories,
                                          initialIndex: index,
                                        ),
                                      )).then((value) {
                                    if (value == true) {
                                      getStories(null);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                100.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
