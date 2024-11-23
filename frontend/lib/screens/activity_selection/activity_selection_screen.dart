import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common_widgets/join_activity_tile.dart';
import 'package:frontend/common_widgets/solid_button.dart';
import 'package:frontend/constants/app_spacing.dart';
import 'package:frontend/data/models/activity_model.dart';
import 'package:frontend/providers/activity_model_provider.dart';

import 'package:frontend/routing/app_routing.dart';
import 'package:frontend/screens/activity_selection/widgets/pending_request.dart';
import 'package:frontend/theme/colors.dart';
import 'package:go_router/go_router.dart';

class ActivitySelectionScreen extends ConsumerStatefulWidget {
  const ActivitySelectionScreen({super.key});

  @override
  ConsumerState<ActivitySelectionScreen> createState() =>
      _ActivitySelectionScreenState();
}

class _ActivitySelectionScreenState
    extends ConsumerState<ActivitySelectionScreen> {
  late Future<List<dynamic>> _loadActivties;

  // get current activity
  ActivityModel? currentRequest;

  @override
  void initState() {
    super.initState();

    _loadActivties = loadActivities();
  }

  late double screenHeight;
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    // Get the current activity
    currentRequest = ref.watch(currentActivityProvider);

    if (currentRequest == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              gapH16,
              Text(
                "You have no pending activity requests",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
              ),
              gapH16,
              SolidButton(
                text: "Create Activity",
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  context.goNamed(AppRouting.createActivity);
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 26, 16, 16),
              child: Text(
                "Your Request",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 0, 20),
            child: PendingActivityRequest(
              title: currentRequest!.description,
              location: currentRequest!.location["name"],
              startTime:
                  currentRequest!.timeRange["startTime"]!.format(context),
              endTime: currentRequest!.timeRange["endTime"]!.format(context),
              minParticipants: currentRequest!.minParticipants,
              maxParticipants: currentRequest!.maxParticipants,
              onOpen: () {
                // Navigate to activity details for the selected activity
                context.goNamed(AppRouting.activityDetails);
              },
            ),
          ),
          Container(
            color: Colors.grey,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 19, 0, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Similar Activities",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: FutureBuilder(
                future: _loadActivties,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading activities');
                  } else {
                    List<ActivityModel> activties =
                        snapshot.data as List<ActivityModel>;
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(4),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        //dynamic activity = activties[index];
                        ActivityModel activity = activties[index];
                        return JoinActivityTile(
                          title: activity.description,
                          location: activity.location["name"],
                          startTime:
                              activity.timeRange["startTime"]!.format(context),
                          endTime:
                              activity.timeRange["endTime"]!.format(context),
                          userProfilePicturePaths: const [
                            "user.png",
                            "user.png",
                            "user.png",
                          ],
                          minParticipants: activity.minParticipants,
                          onJoin: () {
                            // Navigate to activity details for the selected activity
                            context.goNamed(AppRouting.activityDetails);
                          },
                        );
                      },
                    );
                  }
                }),
          ),
          gapH16,
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.secondaryColor,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          gapH32
        ],
      )),
    );
  }

  //TODO: Implement _buildActivityList
  Future<List<dynamic>> loadActivities() async {
    // Load activities from the backend

    // create dummy ActivityModel
    List<ActivityModel> activities = [
      ActivityModel(
        id: "1",
        description: "Play Football",
        location: {"name": "Munich"},
        timeRange: {
          "startTime": TimeOfDay(hour: 15, minute: 0),
          "endTime": TimeOfDay(hour: 17, minute: 0)
        },
        participants: [
          "user1",
          "user2",
          "user3",
        ],
        minParticipants: 3,
        maxParticipants: 5,
      ),
      ActivityModel(
        id: "2",
        description: "Play Basketball",
        location: {"name": "Munich"},
        timeRange: {
          "startTime": TimeOfDay(hour: 15, minute: 0),
          "endTime": TimeOfDay(hour: 17, minute: 0)
        },
        participants: [
          "user1",
        ],
        minParticipants: 3,
        maxParticipants: 5,
      ),
      ActivityModel(
        id: "3",
        description: "Play Tennis",
        location: {"name": "Munich"},
        timeRange: {
          "startTime": TimeOfDay(hour: 15, minute: 0),
          "endTime": TimeOfDay(hour: 17, minute: 0)
        },
        participants: [
          "user1",
          "user2",
          "user3",
        ],
        minParticipants: 3,
        maxParticipants: 5,
      ),
    ];

    return activities;
  }
}
