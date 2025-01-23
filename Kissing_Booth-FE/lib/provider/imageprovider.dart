import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageProviderModel with ChangeNotifier {
  Uint8List? _image1;
  Uint8List? _image2;
  Uint8List? _image3;
  bool _showConnection = false;

  // Notifiers for updates
  final ValueNotifier<bool> image1RemovedNotifier = ValueNotifier(false);
  final ValueNotifier<bool> image2RemovedNotifier = ValueNotifier(false);

  Uint8List? get image1 => _image1;
  Uint8List? get image2 => _image2;
  Uint8List? get image3 => _image3;
  bool get showConnection => _showConnection;

  void setImage1(Uint8List image) {
    _image1 = image;
    _updateConnectionVisibility();
    notifyListeners();
  }

  void setImage2(Uint8List image) {
    _image2 = image;
    _updateConnectionVisibility();
    notifyListeners();
  }

  void setImage3(Uint8List image) {
    _image3 = image;
    notifyListeners();
  }

  void removeImage1() {
    _image1 = null;
    image1RemovedNotifier.value = true;
    _updateConnectionVisibility();
    notifyListeners();
  }

  void removeImage2() {
    _image2 = null;
    image2RemovedNotifier.value = true;
    _updateConnectionVisibility();
    notifyListeners();
  }

  void removeAllImages() {
    _image1 = null;
    _image2 = null;
    image1RemovedNotifier.value = true;
    image2RemovedNotifier.value = true;
    _updateConnectionVisibility();
    print('All images removed: $_image1, $_image2');
    notifyListeners();
  }

  void _updateConnectionVisibility() {
    _showConnection = _image1 != null && _image2 != null;
    notifyListeners();
    print('Connection visibility: $_showConnection');
  }
}
