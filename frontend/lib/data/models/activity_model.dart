import 'package:flutter/material.dart';

class ActivityModel {
  final String? id;
  final String description;
  final Map<String, dynamic> location;
  final Map<String, TimeOfDay> timeRange;
  final int minParticipants;
  final int maxParticipants;
  final List<String> participants;

  ActivityModel({
    this.id,
    required this.description,
    required this.location,
    required this.timeRange,
    required this.minParticipants,
    required this.maxParticipants,
    required this.participants,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      description: json['description'] as String,
      location: json['location'] as Map<String, dynamic>,
      timeRange: json['timeRange'] as Map<String, TimeOfDay>,
      minParticipants: json['minParticipants'] as int,
      maxParticipants: json['maxParticipants'] as int,
      participants: List<String>.from(json['participants'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      "location": {
        "lon": location['lon'],
        "lat": location['lat'],
        "radius": location['radius'],
      },
      "timerange": {
        "startTime": parseTimeOfDayToUTC(timeRange['startTime']!),
        "endTime": parseTimeOfDayToUTC(timeRange['endTime']!),
      },
      'minUsers': minParticipants,
      'maxUsers': maxParticipants,
      'joinedUsers': participants,
    };
  }
}

String parseTimeOfDayToUTC(TimeOfDay timeOfDay) {
  DateTime date = DateTime.now();
  // Combine the date and time
  final localDateTime = DateTime(
    date.year,
    date.month,
    date.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );

  // Convert to UTC
  final utcDateTime = localDateTime.toUtc();

  return utcDateTime.toString();
}

/*
    // Build the request body
    final Map<String, dynamic> requestBody = {
      "description": activity.description,
      "minUsers": activity.minParticipants,
      "maxUsers": activity.maxParticipants,
      "timerange": {
        "startTime": activity.timeRange['startTime'],
        "endTime": activity.timeRange['endTime'],
      },
      "location": {
        "lon": activity.location['lon'],
        "lat": activity.location['lat'],
        "radius": activity.location['radius'],
      },
      "joinedUsers": activity.participants,
    };*/
