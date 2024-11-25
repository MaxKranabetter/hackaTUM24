import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  final String name;
  final String avatarUrl;
  final int age;
  final String gender;

  UserModel({
    required this.uid,
    required this.name,
    required this.avatarUrl,
    required this.age,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['userId'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      age: json['age'],
      gender: json["gender"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': uid,
      'name': name,
      'avatarUrl': avatarUrl,
      'age': age,
      'gender': gender,
    };
  }
}
