import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/join_activity_tile.dart';
import 'package:frontend/common_widgets/solid_button.dart';
import 'package:frontend/constants/app_spacing.dart';
import 'package:frontend/routing/app_routing.dart';
import 'package:frontend/theme/colors.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentIndex = 0;

  final List<String> recommendedActivities = [
    "Walk in Olympiapark",
    "Cycle Tour",
    "Cooking Class",
    "Yoga Session",
    "Photography Walk",
  ];

  @override
  void initState() {
    super.initState();

    if (_pageController.hasClients && _pageController.page != null) {
      // Set up a timer for auto-slide
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_pageController.hasClients) {
          final nextPage = _pageController.page!.toInt() + 1;
          _pageController.animateToPage(
            nextPage % recommendedActivities.length,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget startActivityButton(double screenWidth) {
    double boxSize = screenWidth - 2 * 59;
    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color.fromARGB(255, 217, 217, 217), width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
            bottom: 0,
            child: IconButton(
              onPressed: () {
                context.replace(AppRouting.createActivity);
              },
              icon: Image.asset(
                "people.gif",
                width: boxSize * 0.9,
                height: boxSize * 0.9,
              ),
              iconSize:
                  boxSize * 0.8, // Ensure the button size matches the icon size
            ),
          ),
          Positioned(
            bottom: boxSize * 0.125,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start Activity',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor),
              ],
            ),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Spacing.p8),
                    child: Image.asset(
                      "munich_logo.png",
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(Spacing.p8),
                      child: IconButton(
                        onPressed: () {
                          //TODO: Implement navigation
                        },
                        icon: Image.asset(
                          "list_icon.png",
                        ),
                        iconSize:
                            32, // Ensure the button size matches the icon size
                      )),
                ],
              ),
              gapH104,
              startActivityButton(screenWidth),
              gapH16,
              SolidButton(
                  text: "Choose from past activities",
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: AppColors.surfaceColor),
                  backgroundColor: AppColors.secondaryColor,
                  onPressed: () {}),
              gapH72,
              Text(
                "Recommended Activities",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              gapH16,
              recommendedActivitiesList(),

              // make two big text with different fonts tpo check if it works
            ],
          ),
        ],
      ),
    );
  }

  Widget recommendedActivitiesList() {
    return Column(
      children: [
        SizedBox(
          height: 132, // Fixed height for the carousel items
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PageView.builder(
              controller: _pageController,
              itemCount: recommendedActivities.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return JoinActivityTile(
                  title: recommendedActivities[index],
                  location: "Munich",
                  startTime: "15:00",
                  endTime: "17:00",
                  userProfilePicturePaths: const [
                    "user.png",
                    "user.png",
                    "user.png",
                  ],
                  minParticipants: 3 + (index % 3),
                  onJoin: () {
                    // Navigate to activity details for the selected activity
                    context.goNamed(AppRouting.activityDetails);
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16), // Space between carousel and indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(recommendedActivities.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
