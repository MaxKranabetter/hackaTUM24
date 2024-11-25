import 'package:flutter/material.dart';

class ActivityModel {
  String? id;
  final String description;
  final Map<String, dynamic> location;
  final Map<String, TimeOfDay> timeRange;
  final int minParticipants;
  final int maxParticipants;
  final List<dynamic> participants;

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
    Map<String, TimeOfDay> timeRange = {
      'startTime': TimeOfDay.fromDateTime(
          DateTime.parse(json['timerange']['startTime'])),
      'endTime':
          TimeOfDay.fromDateTime(DateTime.parse(json['timerange']['endTime'])),
    };
    return ActivityModel(
      id: json['id'] as String,
      description: json['description'] as String,
      location: json['location'] as Map<String, dynamic>,
      timeRange: timeRange,
      minParticipants: json['minUsers'] as int,
      maxParticipants: json['maxUsers'] as int,
      participants: List<dynamic>.from(json['joinedUsers'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      "location": {
        "lon": location['lon'],
        "lat": location['lat'],
        "radius": location['radius'],
        "name": location['name'],
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

  ActivityModel copyWith({
    String? id,
    String? description,
    Map<String, dynamic>? location,
    Map<String, TimeOfDay>? timeRange,
    int? minParticipants,
    int? maxParticipants,
    List<String>? participants,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      description: description ?? this.description,
      location: location ?? this.location,
      timeRange: timeRange ?? this.timeRange,
      minParticipants: minParticipants ?? this.minParticipants,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      participants: participants ?? this.participants,
    );
  }

  @override
  String toString() {
    return 'ActivityModel{id: $id, description: $description, location: $location, timeRange: $timeRange, minParticipants: $minParticipants, maxParticipants: $maxParticipants, participants: $participants}';
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
