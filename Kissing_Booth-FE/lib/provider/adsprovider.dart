import 'package:flutter/material.dart';

class AdsProvider with ChangeNotifier {
  bool _isAdEnabled = true;

  bool get isAdEnabled => _isAdEnabled;

  void setAdEnabled(bool value) {
    _isAdEnabled = value;
    notifyListeners();
  }
}
