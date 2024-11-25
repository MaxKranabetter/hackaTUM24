import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:math'; // For generating a fallback unique ID
import 'package:flutter/foundation.dart'; // For kIsWeb

Future<String> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();

  late String deviceID;

  if (kIsWeb) {
    // Web-specific logic
    final webInfo = await deviceInfo.webBrowserInfo;
    deviceID =
        "${webInfo.vendor}-${webInfo.userAgent}-${webInfo.hardwareConcurrency}";
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    final androidInfo = await deviceInfo.androidInfo;
    deviceID = androidInfo.id;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    final iosInfo = await deviceInfo.iosInfo;
    deviceID = iosInfo.identifierForVendor ?? "unknown_device_id";
  } else {
    deviceID = "unsupported_device";
  }

  // Generate a SHA-256 hash of the device ID
  var bytes = utf8.encode(deviceID);
  var digest = sha256.convert(bytes);

  print(digest.toString());
  print(deviceID);

  return digest.toString();
}
