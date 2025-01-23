import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kissing_booth/ads/ad_helper.dart';
import 'package:kissing_booth/api/apiService.dart';
import 'package:kissing_booth/component/custom_button.dart';
import 'package:kissing_booth/component/plus_button.dart';
import 'package:kissing_booth/model/concateImages.dart';
import 'package:kissing_booth/pages/fixedWebWrapper.dart';
import 'package:kissing_booth/pages/rankingpage.dart';
import 'package:kissing_booth/pages/resultpage.dart';
import 'package:kissing_booth/provider/adsprovider.dart';
import 'package:kissing_booth/provider/deviceinfoprovider.dart';
import 'package:kissing_booth/provider/imageprovider.dart';
import 'package:kissing_booth/provider/networkprovider.dart';
import 'package:kissing_booth/theme/dark.dart';
import 'package:kissing_booth/theme/font.dart';
import 'package:kissing_booth/theme/light.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  late AnimationController _fadeController1;
  late AnimationController _fadeController2;
  late AnimationController _textIconFadeController;
  late ImageProviderModel _imageProvider;
  late String _uuid = '';
  late Timer _uuidTimer;

  File? convertedImage1;
  File? convertedImage2;

  final ApiService _apiService = ApiService();
  late AdsProvider adsProvider;
  RewardedAd? _rewardedAd;
  String randomWelcomeKey = "welcome_1";

  int totalUsers = 0;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _createRewardedAds();
    _generateRandomWelcomeKey();

    _fadeController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _textIconFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    _startUuidTimer();
    fetchTotalUsers();
  }

  void _generateRandomWelcomeKey() {
    final welcomeKeys = [
      "welcome_1",
      "welcome_2",
      "welcome_3",
      "welcome_4",
      "welcome_5"
    ];
    final randomIndex = Random().nextInt(welcomeKeys.length);
    setState(() {
      randomWelcomeKey = welcomeKeys[randomIndex];
    });
  }

  void _startUuidTimer() {
    _uuidTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final deviceInfoProvider =
          Provider.of<DeviceInfoProvider>(context, listen: false);
      if (deviceInfoProvider.uuid != null) {
        setState(() {
          _uuid = deviceInfoProvider.uuid!;
          getCurrentDateAndTime(_uuid);
          //print("Updated UUID: $_uuid");
        });
      } else {
        print("UUID is not yet available.");
      }
    });
  }

  // Add a method to stop the UUID timer
  void _stopUuidTimer() {
    if (_uuidTimer.isActive) {
      _uuidTimer.cancel();
      print("UUID Timer stopped.");
    }
  }

  void getCurrentDateAndTime(String uuid) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd–kk:mm:ss').format(now);
    _uuid = '$uuid/$formattedDate'; // _uuid 업데이트
  }

  void fetchTotalUsers() async {
    try {
      final apiService = ApiService();
      final result = await apiService.getTotalUsers();

      final totalNickname = result['total_nickname'];
      final totalNoNickname = result['total_no_nickname'];

      setState(() {
        totalUsers = totalNoNickname ?? 0; // 값이 null일 경우 0으로 설정
      });

      print('닉네임이 있는 사용자 수: $totalNickname');
      print('총 사용자 수: $totalNoNickname');
    } catch (e) {
      print('Failed to fetch total users: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve and store the provider reference
    _imageProvider = context.read<ImageProviderModel>();

    // Add listeners to respond to image removal
    _imageProvider.image1RemovedNotifier.addListener(_handleImage1Removed);
    _imageProvider.image2RemovedNotifier.addListener(_handleImage2Removed);

    final deviceInfoProvider = Provider.of<DeviceInfoProvider>(context);
    deviceInfoProvider.addListener(() {
      if (deviceInfoProvider.uuid != null) {
        // Update the UUID and concatenate the date-time
        setState(() {
          _uuid = deviceInfoProvider.uuid!;
          getCurrentDateAndTime(_uuid);
          //print("Updated UUID: $_uuid");
        });
      }
    });

    adsProvider = Provider.of<AdsProvider>(context);

    // If uuid is already available, initialize it immediately
    if (deviceInfoProvider.uuid != null) {
      _uuid = deviceInfoProvider.uuid!;
      getCurrentDateAndTime(_uuid);
      // print("Initial UUID: $_uuid");
    } else {
      // print("UUID is not yet available.");
    }
  }

  String generateRandomUuid() {
    final random = Random();
    final now = DateTime.now();
    final timestamp = now.microsecondsSinceEpoch;
    final randomFactor = random.nextInt(1000);
    return '${timestamp * randomFactor}';
  }

  void _handleImage1Removed() {
    if (mounted && !_fadeController1.isAnimating) {
      _fadeController1.reverse();
    }
  }

  void _handleImage2Removed() {
    if (mounted && !_fadeController2.isAnimating) {
      _fadeController2.reverse();
    }
  }

  @override
  void dispose() {
    _uuidTimer.cancel();
    // Remove listeners from the stored provider reference
    _imageProvider.image1RemovedNotifier.removeListener(_handleImage1Removed);
    _imageProvider.image2RemovedNotifier.removeListener(_handleImage2Removed);

    // Dispose of animation controllers
    _fadeController1.dispose();
    _fadeController2.dispose();
    _textIconFadeController.dispose();
    super.dispose();
  }

  void _updateTextIconVisibility(ImageProviderModel imageProvider) {
    if (imageProvider.image1 == null && imageProvider.image2 == null) {
      _textIconFadeController.forward(); // Show text
    } else {
      _textIconFadeController.reverse(); // Show icon
    }
  }

  double convertValue(double value) {
    if (value < 0.0 || value > 1.0) {
      throw ArgumentError('Value must be between 0.0 and 1.0');
    }
    return double.parse((value * 10).toStringAsFixed(1));
  }

  void _createRewardedAds() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          debugPrint('Failed to load rewarded ad: $error');
        },
      ),
    );
  }

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAds();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAds();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => setState(
          () => print("Rewarded Ads shown"),
        ),
      );
      _rewardedAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);

    // print("network connection: ${networkProvider.isConnected}");
    //print("uuid: $_uuid");

    //print("isAdEnabled: ${adsProvider.isAdEnabled}");
    return FixedWebSizeWrapper(
      child: MaterialApp(
        title: 'Kissing Booth',
        theme: lightTheme,
        darkTheme: dartTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: ChangeNotifierProvider(
          create: (_) => ImageProviderModel(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            extendBody: true,
            body: ColorfulSafeArea(
              color: Theme.of(context).colorScheme.background,
              bottom: false,
              child: Center(
                child: Consumer<ImageProviderModel>(
                  builder: (context, imageProvider, child) {
                    // Update visibility of text/icon based on image state
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _updateTextIconVisibility(imageProvider),
                    );
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        _buildTitleBox(context, imageProvider, networkProvider),
                        const Spacer(),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: kIsWeb &&
                                      (defaultTargetPlatform !=
                                          TargetPlatform.iOS) &&
                                      (defaultTargetPlatform !=
                                          TargetPlatform.android)
                                  ? const EdgeInsets.only(
                                      bottom: 10, left: 20, right: 20)
                                  : const EdgeInsets.only(bottom: 10),
                              child: Stack(
                                alignment: Alignment.topCenter, // 텍스트를 중앙에 배치
                                children: [
                                  Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.45,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          50), // Apply the border radius
                                      child: Image.asset(
                                        'assets/illustrations/welcome.png',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Text(
                                      randomWelcomeKey,
                                      style: AppFonts.subtitle3(context),
                                      textAlign: TextAlign.center,
                                    ).tr(),
                                  ),
                                ],
                              ),
                            ),
                            // AnimatedSwitcher(
                            //   duration: const Duration(milliseconds: 300),
                            //   switchInCurve: Curves.easeInOut,
                            //   switchOutCurve: Curves.easeInOut,
                            //   child: (imageProvider.image1 == null &&
                            //           imageProvider.image2 == null)
                            //       ? null
                            //       : Positioned(
                            //         bottom: 0,

                            //         child: Lottie.asset(
                            //             'assets/lottie/heart.json',
                            //             height: 200,
                            //             width: 200,
                            //           ),
                            //       ),
                            // ),

                            Visibility(
                              visible: imageProvider.showConnection,
                              child: Positioned(
                                bottom: -15, // Adjust as needed
                                child: Lottie.asset(
                                  'assets/lottie/connection.json',
                                  height: 110,
                                  width: 200,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: imageProvider.showConnection,
                              child: Positioned(
                                bottom: 5,
                                child: const Icon(
                                  Icons.favorite,
                                  color: Color.fromRGBO(237, 102, 169, 1.0),
                                  size: 80,
                                ),
                              ),
                            ),

                            if (imageProvider.image1 != null)
                              Positioned(
                                bottom: 0,
                                right: 20,
                                child: FadeTransition(
                                  opacity: _fadeController1.drive(
                                      CurveTween(curve: Curves.easeInOut)),
                                  child: _buildImageBox(
                                    context,
                                    imageProvider.image1!,
                                    () {
                                      _fadeController1.reverse().then((_) {
                                        imageProvider.removeImage1();
                                      });
                                    },
                                  ),
                                ),
                              ),

                            if (imageProvider.image2 != null)
                              Positioned(
                                bottom: 0,
                                left: 20,
                                child: FadeTransition(
                                  opacity: _fadeController2.drive(
                                      CurveTween(curve: Curves.easeInOut)),
                                  child: _buildImageBox(
                                    context,
                                    imageProvider.image2!,
                                    () {
                                      _fadeController2.reverse().then((_) {
                                        imageProvider.removeImage2();
                                      });
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        _buildActionButtons(
                            context, imageProvider, networkProvider),
                        const Spacer(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBox(BuildContext context, ImageProviderModel imageProvider,
      NetworkProvider networkProvider) {
    final bool isConnected = networkProvider.isConnected;
    return kIsWeb &&
            (defaultTargetPlatform != TargetPlatform.iOS) &&
            (defaultTargetPlatform != TargetPlatform.android)
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('title', style: AppFonts.title(context)).tr(),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'subtitle',
                    style: AppFonts.subtitle(context),
                    textAlign: TextAlign.center,
                  ).tr(),
                ),
                SizedBox(height: 20),
                isConnected
                    ? _buildRankingButton(context, adsProvider)
                    : SizedBox(),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('total_users', style: AppFonts.total_users(context))
                        .tr(),
                    SizedBox(width: 10),
                    Text('$totalUsers', style: AppFonts.total_users(context)),
                  ],
                )
              ],
            ),
          )
        : Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'title',
                  style: AppFonts.title(context),
                  textAlign: TextAlign.center,
                ).tr(),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'subtitle',
                  style: AppFonts.subtitle(context),
                  textAlign: TextAlign.center,
                ).tr(),
              ),
              isConnected
                  ? _buildRankingButton(
                      context,
                      adsProvider,
                    )
                  : SizedBox(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('total_users', style: AppFonts.total_users(context))
                      .tr(),
                  SizedBox(width: 0),
                  Text('$totalUsers', style: AppFonts.total_users(context)),
                ],
              )
            ],
          );
  }

  Widget _buildImageBox(
      BuildContext context, Uint8List imageBytes, VoidCallback onRemove) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            imageBytes,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          onTap: onRemove,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove,
              color: Colors.black,
              size: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context,
      ImageProviderModel imageProvider, NetworkProvider networkProvider) {
    final bool isConnected = networkProvider.isConnected;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child:
                (imageProvider.image1 == null || imageProvider.image2 == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (imageProvider.image1 == null)
                            PlusButton(
                              imageBytes: imageProvider.image1,
                              onImageSelected: (image) {
                                imageProvider.setImage1(image);
                                _fadeController1.forward();
                                convertedImage1 = convertToJpgFile(image);
                              },
                              onImageDeleted: () {
                                _fadeController1.reverse().then((_) {
                                  imageProvider.removeImage1();
                                  convertedImage1?.delete();
                                });
                              },
                              isMe: true,
                            ),
                          const SizedBox(height: 10),
                          if (imageProvider.image2 == null)
                            PlusButton(
                              imageBytes: imageProvider.image2,
                              onImageSelected: (image) {
                                imageProvider.setImage2(image);
                                _fadeController2.forward();
                                convertedImage2 = convertToJpgFile(image);
                              },
                              onImageDeleted: () {
                                _fadeController2.reverse().then((_) {
                                  imageProvider.removeImage2();
                                  convertedImage2?.delete();
                                });
                              },
                              isMe: false,
                            ),
                          SizedBox(height: 10),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CustomButton(
                          text: "next",
                          onPressed: () async {
                            _stopUuidTimer();
                            loadingShowDialog(context); // Show loading dialog

                            try {
                              //print('Updated UUID: $_uuid');
                              Map<String, dynamic> fetchedData =
                                  await _apiService.getCoupleScore(
                                userId: _uuid,
                                photo1: convertedImage1!,
                                photo2: convertedImage2!,
                              );

                              if (fetchedData.isEmpty) {
                                return;
                              } else {
                                print("fetchedData: $fetchedData");
                                Navigator.of(context, rootNavigator: true)
                                    .pop(); // Close loading dialog
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ResultPage(
                                      photo1: fetchedData['photo1_url'],
                                      photo2: fetchedData['photo2_url'],
                                      score: fetchedData['score'],
                                      uuid: _uuid,
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              print("Error: $e");

                              Navigator.of(context, rootNavigator: true)
                                  .pop(); // Close loading dialog

                              errorDialog();
                            }
                          },
                          color: Colors.blue,
                          isNext: true,
                        ),
                      ),
          ),
          policyTerms(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget loading(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/lottie/heart_loading.json',
          height: 400,
          width: 400,
        ),
        Text(
          'uploading',
          style: AppFonts.loading(context),
        ).tr(),
      ],
    );
  }

  Widget policyTerms() {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: 'privacy_1'.tr(),
        style: AppFonts.privacy(
            Theme.of(context).colorScheme.secondaryFixed, context),
        children: <TextSpan>[
          TextSpan(
            text: 'privacy_2'.tr(),
            style: AppFonts.privacy_underline(
                Theme.of(context).colorScheme.secondaryFixed, context),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                termsOfUse();
              },
          ),
          TextSpan(
            text: 'privacy_3'.tr(),
            style: AppFonts.privacy(
                Theme.of(context).colorScheme.secondaryFixed, context),
          ),
          TextSpan(
            text: 'privacy_4'.tr(),
            style: AppFonts.privacy_underline(
                Theme.of(context).colorScheme.secondaryFixed, context),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                privaryPolicy();
              },
          ),
          TextSpan(
            text: 'privacy_5'.tr(),
            style: AppFonts.privacy(
                Theme.of(context).colorScheme.secondaryFixed, context),
          ),
        ],
      ),
    );
  }

  void privaryPolicy() async {
    const url =
        'https://numerous-lunaria-be1.notion.site/Privacy-Policy-17516184b3088029855dfe46d87643ea?pvs=74';
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  void termsOfUse() async {
    const url =
        'https://numerous-lunaria-be1.notion.site/Terms-Conditions-17516184b30880509dbef38b674476a2?pvs=4';
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  void loadingShowDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/heart_loading.json',
                height: 400,
                width: 400,
              ),
              Positioned(
                bottom: 70,
                child: Text(
                  'uploading',
                  style: AppFonts.loading(context),
                ).tr(),
              ),
            ],
          ),
        );
      },
    );
  }

  void errorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          icon: Icon(
            FeatherIcons.alertTriangle,
            color: Colors.redAccent,
            size: 45,
          ),
          title: Text(
            'error',
            textAlign: TextAlign.center,
            style: AppFonts.title(context),
          ).tr(),
          content: Text(
            'error_message',
            textAlign: TextAlign.center,
            style: AppFonts.subtitle(context),
          ).tr(),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                _startUuidTimer();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 55,
                width: MediaQuery.of(context).size.width - 10,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'confirm',
                      style: AppFonts.button(
                          Theme.of(context).colorScheme.background, context),
                    ).tr(),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildRankingButton(BuildContext context, AdsProvider adsProvider) {
    return GestureDetector(
      onTap: () {
        if (kIsWeb) {
          //  _showWebIframe();
        }
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RankingPage(
              isHomepage: true,
              uuid: _uuid,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              'ranking',
              style: AppFonts.description(context),
            ).tr(),
          ),
        ),
      ),
    );
  }
}
