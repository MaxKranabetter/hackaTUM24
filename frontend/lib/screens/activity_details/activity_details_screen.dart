import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common_widgets/chat_window.dart';
import 'package:frontend/common_widgets/free_text_input.dart';
import 'package:frontend/common_widgets/participant_list.dart';
import 'package:frontend/common_widgets/pending_request.dart';
import 'package:frontend/common_widgets/solid_button.dart';
import 'package:frontend/constants/app_spacing.dart';
import 'package:frontend/data/models/activity_model.dart';
import 'package:frontend/providers/activity_model_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/routing/app_routing.dart';
import 'package:frontend/theme/colors.dart';
import 'package:go_router/go_router.dart';

class ActivityDetailsScreen extends ConsumerStatefulWidget {
  final String activityID;
  const ActivityDetailsScreen({super.key, required this.activityID});

  @override
  ConsumerState<ActivityDetailsScreen> createState() =>
      _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends ConsumerState<ActivityDetailsScreen> {
  late double screenHeight;
  late double screenWidth;

  late Future<ActivityModel> _loadActivityModel;

  @override
  void initState() {
    super.initState();

    _loadActivityModel = loadActivity();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.surfaceColor,
        body: FutureBuilder(
          future: _loadActivityModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              ActivityModel activity = snapshot.data as ActivityModel;

              return _buildActivityDetails(context, activity);
            }
          },
        ));
  }

  Widget _buildActivityDetails(BuildContext context, ActivityModel activity) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 24, 16, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => {context.go(AppRouting.home)},
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "Your Activity",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 28),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 217, 217, 217),
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 16, 22, 16),
          child: CollapsablePendingActivityRequest(
              title: activity.description,
              location: activity.location["name"],
              startTime: activity.timeRange["startTime"]!.format(context),
              endTime: activity.timeRange["endTime"]!.format(context),
              minParticipants: activity.minParticipants,
              maxParticipants: activity.maxParticipants,
              includeOpenButton: false,
              onOpen: () => {}),
        ),
        Container(
          color: const Color.fromARGB(255, 217, 217, 217),
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 16, 22, 16),
          child: CollapsableParticipantList(
            participants: activity.participants,
            denominator: 4,
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 217, 217, 217),
          height: 1,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 22, 0, 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Chat",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 22, 30, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const ChatMessage(
                  isSender: false,
                  text: 'Hey, when are we meeting today?',
                  name: 'Isabella',
                  messageTimestamp: '11:21',
                  imageURL: 'user.png',
                ),
                const ChatMessage(
                  isSender: true,
                  text: 'How about 14:45 at the northern entrance?',
                  name: 'You',
                  messageTimestamp: '15:34',
                  imageURL: 'user.png',
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: screenWidth - 50 - 40 - 20,
                        child: FreeTextInputBox(
                            textEditingController: TextEditingController(),
                            hintText: "Chat with the group..."),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () => {},
                          icon: const Icon(Icons.arrow_forward,
                              color: AppColors.secondaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<ActivityModel> loadActivity() async {
    ActivityModel activity = await ref
        .read(currentActivityProvider.notifier)
        .loadActivityFromID(widget.activityID);

    try {
      // join the activity
      print("Joining activity");
      // check if the user is logged in
      if (ref.read(userProvider) == null) {
        await ref.read(userProvider.notifier).initializeUser();
      }

      String userID = ref.read(userProvider)!.uid;

      print("userID: $userID");
      print("activityID: ${activity.id}");

      await ref
          .read(currentActivityProvider.notifier)
          .joinActivity(activity, userID);
    } catch (e) {
      print("error $e");
    }

    return activity;
  }
}
