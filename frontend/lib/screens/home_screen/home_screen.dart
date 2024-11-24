import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common_widgets/join_activity_tile.dart';
import 'package:frontend/constants/app_spacing.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/routing/app_routing.dart';
import 'package:frontend/theme/colors.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProvider.notifier).initializeUser();

      if (_pageController.hasClients && _pageController.page != null) {
        _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
          if (_pageController.hasClients) {
            final nextPage = (_pageController.page?.toInt() ?? 0) + 1;
            _pageController.animateToPage(
              nextPage % recommendedActivities.length,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildStartActivityButton(double screenWidth) {
    final double boxSize = screenWidth - 118; // Calculate button width

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Image.asset(
            "people.gif",
            width: 700,
            height: 350,
          ),
        ),
        Positioned(
          bottom: 12,
          child: Column(
            children: [
              SizedBox(
                width: boxSize,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    context.replace(AppRouting.createActivity);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 217, 217, 217),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Start Activity',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios,
                            color: AppColors.primaryColor),
                      ],
                    ),
                  ),
                ),
              ),
              gapH8,
              Container(
                width: (screenWidth - 118) * 0.8,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 217, 217, 217),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      color: AppColors.secondaryColor,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Repeat a previous activity",
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedActivitiesList() {
    return Column(
      children: [
        SizedBox(
          height: 140,
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
                  location: [
                    "Olympiapark",
                    "Hofbräuhaus",
                    "Viktualienmarkt"
                  ][index % 3],
                  startTime: ["15:00", "13:00", "14:00"][index % 3],
                  endTime: ["17:00", "14:30", "18:30"][index % 3],
                  userProfilePicturePaths: [
                    "man.png",
                    "girl.png",
                    "woman.png",
                  ]..shuffle(),
                  minParticipants: 3 + (index % 3),
                  onJoin: () {
                    context.goNamed(AppRouting.activityDetails);
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("munich_logo.png"),
                    IconButton(
                      onPressed: () {
                        // TODO: Implement navigation
                      },
                      icon: Image.asset("list_icon.png"),
                      color: AppColors.secondaryColor,
                      iconSize: 32,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              _buildStartActivityButton(screenWidth),
              const Spacer(flex: 2),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: Text(
                    "Activities you might like",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              gapH8,
              _buildRecommendedActivitiesList(),
              gapH48,
            ],
          ),
        ],
      ),
    );
  }
}
