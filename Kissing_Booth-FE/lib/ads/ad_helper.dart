import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (kReleaseMode) {
      if (Platform.isAndroid) {
        return "ca-app-pub-2674925873094012/7703153246";
      } else if (Platform.isIOS) {
        return "ca-app-pub-2674925873094012/5977507600";
      } else {
        throw new UnsupportedError('Unsupported platform');
      }
    } else {
      if (Platform.isAndroid) {
        return "ca-app-pub-2515797554946271/1241033080";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/2435281174";
      } else {
        throw new UnsupportedError('Unsupported platform');
      }
    }
  }

  static String get rewardedAdUnitId {
    if (kReleaseMode) {
      if (Platform.isAndroid) {
        return "ca-app-pub-2674925873094012/2335276490";
      } else if (Platform.isIOS) {
        return "ca-app-pub-2674925873094012/4161022734";
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/5224354917";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/1712485313";
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    }
  }

  static final BannerAdListener bannerAdLinster = BannerAdListener(
      onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
      onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
      onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        print('Ad failed to load: ${ad.adUnitId}, $error');
      });
}
