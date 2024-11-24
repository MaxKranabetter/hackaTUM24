import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common_widgets/join_activity_tile.dart';
import 'package:frontend/common_widgets/solid_button.dart';
import 'package:frontend/constants/app_spacing.dart';
import 'package:frontend/data/models/activity_model.dart';
import 'package:frontend/providers/activity_model_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:http/http.dart' as httpreq;
import 'package:frontend/routing/app_routing.dart';
import 'package:frontend/common_widgets/pending_request.dart';
import 'package:frontend/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivitySelectionScreen extends ConsumerStatefulWidget {
  ActivityModel? activityModel;
  ActivitySelectionScreen({super.key, this.activityModel});

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
    super.initState(); // Always call super first.
    Future(() {
      _loadActivties = loadActivities();
    });
  }

  late double screenHeight;
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (currentRequest == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              gapH16,
              Text(
                "Loading your request...",
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => {},
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
                    "Your Request",
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
                context
                    .go("${AppRouting.activityDetails}/${currentRequest!.id}");
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
                    if (activties.isEmpty) {
                      return const Text('No activities found');
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(4),
                      itemCount: activties.length,
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
                            "woman.png",
                            "man.png",
                            "girl.png",
                          ],
                          minParticipants: activity.minParticipants,
                          onJoin: () {
                            // Navigate to activity details for the selected activity
                            context.go(
                                "${AppRouting.activityDetails}/${activity.id}");
                          },
                        );
                      },
                    );
                  }
                }),
          )
        ],
      )),
    );
  }

  Future<String?> getLocationName(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1');
    final response = await httpreq.get(url, headers: {
      'User-Agent': 'Flutter App',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name']; // Full location name
    } else {
      return null; // Handle error appropriately
    }
  }

  Future<List<ActivityModel>> loadActivities() async {
    // check if the user is logged in
    if (ref.read(userProvider) == null) {
      await ref.read(userProvider.notifier).initializeUser();
    }

    String uid = ref.read(userProvider)!.uid;

    print("Loading activities using current user ${uid}");
    print("Loading activities using current request ${widget.activityModel}");
    String? id;
    if (widget.activityModel != null) {
      String name = await getLocationName(widget.activityModel!.location["lat"],
              widget.activityModel!.location["lon"]) ??
          "Unknown Location";

      // upadte the location name
      widget.activityModel!.location["name"] = name;

      // upload the newlly created activity
      id = await ref
          .read(currentActivityProvider.notifier)
          .addActivity(widget.activityModel!, uid);

      // upload the newlly created activity id to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("currentActivityId", id);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getString("currentActivityId");

      if (id == null) {
        return [];
      }
      currentRequest = await ref
          .read(currentActivityProvider.notifier)
          .loadActivityFromID(id);
      ref.read(currentActivityProvider.notifier).setActivity(currentRequest!);
    }
    print("Loading activities using current request ${id}");
    List<dynamic> activities =
        await ref.read(currentActivityProvider.notifier).loadActivities(
              id,
            );

    print("Loaded activities ${activities}");
// check if the userID is in the participants list
    final userActivities = activities.where((element) {
      return !element["joinedUsers"].contains(uid);
    }).toList();

    print("User activities: $userActivities");

    setState(() {
      currentRequest = ref.read(currentActivityProvider)!;
    });

    return userActivities.map((e) => ActivityModel.fromJson(e)).toList();
  }
}
