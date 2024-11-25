import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/api_endpoint.dart';
import 'package:frontend/data/models/activity_model.dart';
import 'package:http/http.dart' as httpreq;

class CurrentActivityNotifier extends StateNotifier<ActivityModel?> {
  CurrentActivityNotifier() : super(null);

  void setActivity(ActivityModel activity) {
    state = activity;
  }

  Future<String> addActivity(ActivityModel activity, String userID) async {
    // Set the initial state
    state = activity;

    // Post the activity and get the ID
    String? id = await postActivity(userID, activity);

    if (id != null) {
      // Create a new ActivityModel instance with the updated ID
      final updatedActivity = activity.copyWith(id: id);

      // Update the state with the new instance
      state = updatedActivity;
      return id;
    }
    return "fail";
  }

  void clearActivity() {
    state = null;
  }

  void updateActivity(ActivityModel updatedActivity) {
    state = updatedActivity;
  }

  // get top k activities
  Future<List<dynamic>> loadActivities(String id) async {
    try {
      final response =
          await httpreq.get(Uri.parse('$baseUrl/activity/$id/similar/?K=3'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print('Error loading activities: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error loading activities: $e');
      return [];
    }
  }

  Future<ActivityModel> loadActivityFromID(String id) async {
    try {
      final response = await httpreq.get(Uri.parse('$baseUrl/activity/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return ActivityModel.fromJson(data);
      } else {
        print('Error loading activity: ${response.body}');
        return ActivityModel(
          description: 'Error loading activity',
          location: {},
          timeRange: {},
          minParticipants: 0,
          maxParticipants: 0,
          participants: [],
        );
      }
    } catch (e) {
      print('Error loading activity2: $e');
      return ActivityModel(
        description: 'Error loading activity',
        location: {},
        timeRange: {},
        minParticipants: 0,
        maxParticipants: 0,
        participants: [],
      );
    }
  }

  Future<bool> joinActivity(ActivityModel activityModel, String userID) async {
    // Replace with your actual endpoint URL
    try {
      print('$baseUrl/activity/${activityModel.id}/add_user/$userID');
      // Make the PUT request
      final response = await httpreq.put(
        Uri.parse('$baseUrl/activity/${activityModel.id}/add_user/$userID'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(activityModel.toJson()),
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Activity joined successfully: ${response.body}');
        return true;
      } else {
        print('Failed to join activity. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while joining activity: $e');
      return false;
    }
  }

  Future<String?> postActivity(String createdBy, ActivityModel activity) async {
    // Replace with your actual endpoint URL
    try {
      print(activity.toJson());
      print('$baseUrl/activity/?created_by=$createdBy');
      // Make the POST request
      final response = await httpreq.post(
        Uri.parse('$baseUrl/activity/?created_by=$createdBy'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(activity.toJson()),
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Activity posted successfully: ${response.body}');

        // Update the activity with the ID
        final id = json.decode(response.body)["id"];
        return id;
      } else {
        print('Failed to post activity. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while posting activity: $e');
    }
  }
}

final currentActivityProvider =
    StateNotifierProvider<CurrentActivityNotifier, ActivityModel?>((ref) {
  return CurrentActivityNotifier();
});
