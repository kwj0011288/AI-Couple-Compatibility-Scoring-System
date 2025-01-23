import 'package:flutter/material.dart';

class AppFonts {
  static String _fontFamilyBold(BuildContext context) {
    // Retrieve the current locale
    Locale locale = Localizations.localeOf(context);
    // Assign different font families based on the locale
    if (locale.languageCode == 'ja') {
      return 'Japanese_Bold'; // Replace with the actual Japanese font family
    }
    return 'SandBox_Bold'; // Default font family
  }

  static String _fontFamilyMedium(BuildContext context) {
    // Retrieve the current locale
    Locale locale = Localizations.localeOf(context);
    // Assign different font families based on the locale
    if (locale.languageCode == 'ja') {
      return 'Japanese_Medium'; // Replace with the actual Japanese font family
    }
    return 'SandBox_Medium'; // Default font family
  }

  static String _fontFamilyLow(BuildContext context) {
    // Retrieve the current locale
    Locale locale = Localizations.localeOf(context);
    // Assign different font families based on the locale
    if (locale.languageCode == 'ja') {
      return 'Japanese_Low'; // Replace with the actual Japanese font family
    }
    return 'SandBox_Low'; // Default font family
  }

  static TextStyle title(BuildContext context) {
    return TextStyle(
      fontSize: 32,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle title2(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle title3(BuildContext context) {
    return TextStyle(
      fontSize: 32,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.primary,
    );
  }

  static TextStyle title4(BuildContext context) {
    return TextStyle(
      fontSize: 45,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle title5(BuildContext context) {
    return TextStyle(
      fontSize: 30,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
    );
  }

  static TextStyle subtitle2(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
    );
  }

  static TextStyle subtitle3(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle button(Color color, BuildContext context) {
    return TextStyle(
      fontSize: 17,
      fontFamily: _fontFamilyMedium(context),
      color: color,
    );
  }

  static TextStyle button2(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle cancelButton(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontFamily: _fontFamilyMedium(context),
      color: Colors.redAccent,
    );
  }

  static TextStyle warningBox(BuildContext context) {
    return TextStyle(
      fontSize: 10,
      fontFamily: _fontFamilyLow(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle warning(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontFamily: _fontFamilyLow(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle contentWarning(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      fontFamily: _fontFamilyLow(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle chat(Color color, BuildContext context) {
    return TextStyle(
      fontSize: 13,
      fontFamily: _fontFamilyLow(context),
      color: color,
    );
  }

  static TextStyle score1(Color color, BuildContext context) {
    return TextStyle(
      fontSize: 50,
      fontFamily: _fontFamilyMedium(context),
      color: color,
    );
  }

  static TextStyle score2(Color color, BuildContext context) {
    return TextStyle(
      fontSize: 30,
      fontFamily: _fontFamilyMedium(context),
      color: color,
    );
  }

  static TextStyle loading(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontFamily: _fontFamilyMedium(context),
      color: Colors.white,
    );
  }

  static TextStyle description(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle userCount(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle ranking(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle rankingTitle(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle rankingRate(BuildContext context) {
    return TextStyle(
      fontSize: 25,
      fontFamily: _fontFamilyBold(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle rankingTotal(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle myScore(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      fontFamily: _fontFamilyBold(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle myScoreTotal(BuildContext context) {
    return TextStyle(
      fontSize: 13,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle currentMyScore(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle popupTitle(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle popupSubtitle(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.primary,
    );
  }

  static TextStyle rankingCancel(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.primary,
    );
  }

  static TextStyle retryRankingButton(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontFamily: _fontFamilyMedium(context),
      color: Colors.white,
    );
  }

  static TextStyle retryRankingButton2(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontFamily: _fontFamilyMedium(context),
      color: Colors.white,
    );
  }

  static TextStyle privacy(Color color, BuildContext context) {
    return TextStyle(
      fontSize: 7,
      fontFamily: _fontFamilyLow(context),
      color: color,
    );
  }

  static TextStyle privacy_underline(Color color, BuildContext context) {
    return TextStyle(
      decoration: TextDecoration.underline,
      fontSize: 7,
      fontFamily: _fontFamilyLow(context),
      color: color,
    );
  }

  static TextStyle noFace(BuildContext context) {
    return TextStyle(
      fontSize: 28,
      fontFamily: _fontFamilyMedium(context),
      color: Theme.of(context).colorScheme.outline,
    );
  }

  static TextStyle total_users(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      fontFamily: _fontFamilyMedium(context),
      color: Color(0xFF34C759), // Apple Green 색상
    );
  }

  static TextStyle error(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      fontFamily: _fontFamilyMedium(context),
      color: Colors.redAccent,
    );
  }
}
