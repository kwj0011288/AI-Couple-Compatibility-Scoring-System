import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceInfoProvider with ChangeNotifier {
  String? _uuid;

  String? get uuid => _uuid;

  DeviceInfoProvider() {
    _initializeUuid(); // Automatically fetch UUID on provider creation
  }

  Future<void> _initializeUuid() async {
    if (_uuid == null) {
      await fetchDeviceUuid();
    }
  }

  Future<void> fetchDeviceUuid() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String? newUuid;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      newUuid = androidInfo.id; // Android unique ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      newUuid = iosInfo.identifierForVendor; // iOS unique ID
    } else {
      newUuid = "Unsupported Platform";
    }

    if (_uuid != newUuid) {
      _uuid = newUuid;
      // print("Updated UUID: $_uuid");
      notifyListeners();
    }
  }
}
