import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kissing_booth/pages/homepage.dart';
import 'package:kissing_booth/provider/adsprovider.dart';
import 'package:kissing_booth/provider/deviceinfoprovider.dart';
import 'package:kissing_booth/provider/imageprovider.dart';
import 'package:kissing_booth/provider/networkprovider.dart';
import 'package:kissing_booth/provider/rankprovider.dart';
import 'package:kissing_booth/theme/dark.dart';
import 'package:kissing_booth/theme/light.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (!kIsWeb) MobileAds.instance.initialize();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
        Locale('ja', 'JP'),
        Locale('zh', 'CN')
      ],
      path: 'assets/translations',
      // startLocale: const Locale('ja', 'JP'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageProviderModel()),
          ChangeNotifierProvider(create: (_) => AdsProvider()),
          ChangeNotifierProvider(create: (_) => RankProvider()),
          ChangeNotifierProvider(create: (_) => DeviceInfoProvider()),
          ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: dartTheme,
      home: Scaffold(
        body: kIsWeb &&
                (defaultTargetPlatform != TargetPlatform.iOS) &&
                (defaultTargetPlatform != TargetPlatform.android)
            ? Container(
                color: Theme.of(context).colorScheme.background,
                child: Center(
                  child: Container(
                    width: 420,
                    height: 1100,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.8),
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),

                      child: Homepage(), // Your main app content
                    ),
                  ),
                ),
              )
            : MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: dartTheme,
                home: Homepage(),
              ),
      ),
    );
  }
}
