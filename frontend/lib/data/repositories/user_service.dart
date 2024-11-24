import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constants/api_endpoint.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<UserModel?> loadUser(String uid) async {
    final url = Uri.parse('$baseUrl/user/$uid');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Error loading user: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }

  Future<UserModel?> createUser(String deviceId) async {
    final url = Uri.parse("$baseUrl/user");

    final user = UserModel(
      uid: deviceId,
      name: 'Default Name', // Replace with your logic
      avatarUrl: 'test',
      age: 0,
      gender: 'male',
    );
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Error creating user: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating user: ${e.toString()}');
      return null;
    }
  }

  Future<void> cacheUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(user.toJson()));
  }

  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }
}
