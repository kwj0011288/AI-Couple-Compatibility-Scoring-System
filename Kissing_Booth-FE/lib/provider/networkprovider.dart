import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkProvider with ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  late StreamSubscription _connectivitySubscription;

  NetworkProvider() {
    _initializeConnection();
  }

  void _initializeConnection() async {
    // Check the initial connection status
    await checkConnection();

    // Listen for network changes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((dynamic event) {
      if (event is ConnectivityResult) {
        // Handle single ConnectivityResult
        _isConnected = event == ConnectivityResult.mobile ||
            event == ConnectivityResult.wifi ||
            event == ConnectivityResult.ethernet;

        // Notify listeners
        notifyListeners();

        if (_isConnected) {
          print("Connected to the Internet");
        } else {
          print("No Internet Connection");
        }
      } else if (event is List<ConnectivityResult>) {
        // Handle List<ConnectivityResult> if emitted
        _isConnected = event.any((result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet);

        // Notify listeners
        notifyListeners();

        if (_isConnected) {
          print("Connected to the Internet");
        } else {
          print("No Internet Connection");
        }
      } else {
        print("Unknown connectivity state: $event");
      }
    });
  }

  Future<void> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isConnected = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
