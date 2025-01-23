import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kissing_booth/ads/ad_helper.dart';
import 'package:kissing_booth/ads/ad_lilst.dart';
import 'package:kissing_booth/component/couple_photo.dart';
import 'package:kissing_booth/pages/fixedWebWrapper.dart';
import 'package:kissing_booth/pages/nicknamepage.dart';
import 'package:kissing_booth/pages/rankingpage.dart';
import 'package:kissing_booth/provider/adsprovider.dart';
import 'package:kissing_booth/provider/imageprovider.dart';
import 'package:kissing_booth/provider/networkprovider.dart';
import 'package:kissing_booth/theme/dark.dart';
import 'package:kissing_booth/theme/font.dart';
import 'package:kissing_booth/theme/light.dart';
import 'package:provider/provider.dart';
import 'package:kissing_booth/pages/homepage.dart';
import 'package:kissing_booth/component/chat_bubble.dart';
import 'package:kissing_booth/component/custom_button.dart';
import 'package:kissing_booth/component/result.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultPage extends StatefulWidget {
  final String? photo1;
  final String? photo2;
  final double score;
  final String uuid;

  const ResultPage({
    Key? key,
    this.photo1,
    this.photo2,
    required this.score,
    required this.uuid,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  /* --- google ads --- */
  bool _showBottomNavBar = false;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;

  late String resultMessage;
  late Map<String, String> chatMessages;
  late String imageAssetGirl;
  late String imageAssetBoy;
  late String heart;
  late Size heartSize;

  String getRandomResultMessage(double score) {
    // 0과 1은 같은 category로 처리
    int category = (score * 10).floor();
    if (category == 0) category = 1;

    // 9와 10은 같은 category로 처리
    if (category == 10) category = 9;

    int randomIndex = Random().nextInt(5) + 1;
    String key = "result${category}_$randomIndex";
    return key.tr();
  }

  Map<String, String> getRandomChatMessages(double score) {
    // 0과 1은 같은 category로 처리
    int category = (score * 10).floor();
    if (category == 0) category = 1;

    // 9와 10은 같은 category로 처리
    if (category == 10) category = 9;

    int randomIndex = Random().nextInt(5) + 1;
    return {
      "send": "${category}_${randomIndex}_send".tr(),
      "receive": "${category}_${randomIndex}_receive".tr(),
    };
  }

  Map<String, String> getImageAsset(double score, bool isGirl) {
    int category = (score * 10).floor();
    String emotion;
    String heart;

    if (category >= 7) {
      emotion = "happy";
      heart = "full";
    } else if (category >= 4) {
      emotion = "neutral";
      heart = "half";
    } else {
      emotion = "mad";
      heart = "broken";
    }

    String characterImage = isGirl
        ? "assets/illustrations/girl_$emotion.png"
        : "assets/illustrations/man_$emotion.png";

    String heartImage = "assets/heart/${heart}_heart.png";

    return {
      "character": characterImage,
      "heart": heartImage,
    };
  }

  Size getHeartSize(double score) {
    int category = (score * 10).floor();
    if (category >= 7) {
      return const Size(90, 90);
    } else if (category >= 4) {
      return const Size(90, 90);
    } else {
      return const Size(80, 80);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    resultMessage = getRandomResultMessage(widget.score);
    chatMessages = getRandomChatMessages(widget.score);
    imageAssetGirl = getImageAsset(widget.score, true)["character"]!;
    imageAssetBoy = getImageAsset(widget.score, false)["character"]!;
    heart = getImageAsset(widget.score, true)["heart"]!;
    heartSize = getHeartSize(widget.score);

    if (!kIsWeb) _createRewardedAds();
    if (!kIsWeb) _createBannerAds();
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _showBottomNavBar = true;
      });
    });
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

  Future<void> _checkAndShowRewardAd() async {
    // SharedPreferences를 사용해 로컬 카운터 관리
    final prefs = await SharedPreferences.getInstance();
    int adCounter = prefs.getInt('reward_ad_counter') ?? 0;
    print('Current ad counter: $adCounter');

    if (adCounter % 2 == 0) {
      // 광고를 보여주는 조건: 카운터가 0, 2, 4, 6...일 때
      _showRewardedAd();
    }

    // 카운터 증가 후 저장
    adCounter++;
    await prefs.setInt('reward_ad_counter', adCounter);
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAds(); // 광고 다시 로드
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAds();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          print("User earned reward.");
        },
      );
      _rewardedAd = null;
    }
  }

  void _createBannerAds() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.fullBanner,
      listener: AdHelper.bannerAdLinster,
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageProviderModel>(context);
    final networkProvider = Provider.of<NetworkProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);
    print("ads enabled in result page: ${adsProvider.isAdEnabled}");

    if (widget.score == -1.0) {
      return FixedWebSizeWrapper(
        child: MaterialApp(
          title: 'Kissing Booth',
          theme: lightTheme,
          darkTheme: dartTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          home: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
              title: kIsWeb &&
                      (defaultTargetPlatform != TargetPlatform.iOS) &&
                      (defaultTargetPlatform != TargetPlatform.android)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child:
                          Text('title', style: AppFonts.title2(context)).tr(),
                    )
                  : Text('title', style: AppFonts.title2(context)).tr(),
              automaticallyImplyLeading: false,
            ),
            body: ColorfulSafeArea(
              color: Theme.of(context).colorScheme.background,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.45,
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            50), // Apply the border radius
                        child: Image.asset(
                          'assets/illustrations/man_mad.png',
                        ),
                      ),
                    ),
                    Text(
                      'noface', // Translation key for the message
                      style: AppFonts.noFace(context),
                      textAlign: TextAlign.center,
                    ).tr(),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'retry',
                      color: Theme.of(context).colorScheme.outline,
                      onPressed: () {
                        // Retry logic
                        if (!kIsWeb && adsProvider.isAdEnabled)
                          _checkAndShowRewardAd();
                        imageProvider.removeAllImages();
                        Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    Homepage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'model_error',
                      style: AppFonts.warning(context),
                      textAlign: TextAlign.center,
                    ).tr(),
                    const SizedBox(height: 5),
                    Text(
                      'model_face_error',
                      style: AppFonts.warning(context),
                      textAlign: TextAlign.center,
                    ).tr(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: networkProvider.isConnected
                ? (!kIsWeb)
                    ? (_bannerAd == null
                        ? Container(
                            color: Colors.transparent,
                          )
                        : Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            color: Theme.of(context).colorScheme.surface,
                            height: 60,
                            child: AdWidget(ad: _bannerAd!),
                          ))
                    : const SizedBox()
                : const SizedBox(),
          ),
        ),
      );
    }

    void shareResult() {
      Share.share('https://kissing-booth-ai.com');
    }

    List<String> textList = ["retry", "share", "ranking"];

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CouplePhoto(photo: widget.photo1),
                  const SizedBox(width: 30),
                  CouplePhoto(photo: widget.photo2),
                ],
              ),
              Positioned(
                child: Image.asset(
                  heart,
                  width: heartSize.width,
                  height: heartSize.height,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          ResultText(text: (widget.score * 10).toStringAsFixed(2)),
          const SizedBox(height: 10),
          CustomChatBubble(
            message: chatMessages["send"]!,
            alignment: Alignment.topRight,
            bubbleType: BubbleType.sendBubble,
            imageAsset: imageAssetGirl,
            backgroundColor: Color.fromRGBO(235, 227, 209, 1),
          ),
          const SizedBox(height: 10),
          CustomChatBubble(
            message: chatMessages["receive"]!,
            alignment: Alignment.topLeft,
            bubbleType: BubbleType.receiverBubble,
            imageAsset: imageAssetBoy,
            backgroundColor: Color.fromRGBO(213, 195, 235, 1),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 1,
            ),
          ),
          CustomChatBubble(
            message: resultMessage,
            alignment: Alignment.bottomRight,
            bubbleType: BubbleType.sendBubble,
            isResult: true,
            imageAsset: "assets/illustrations/result.png",
            backgroundColor: Color.fromRGBO(243, 226, 180, 1),
          ),
          const SizedBox(height: 20),
          Text(
            'caution',
            style: AppFonts.warning(context),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(height: 25),
          for (int i = 0; i < textList.length; i++)
            CustomButton(
              text: textList[i],
              color: i == 0
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (i == 0) {
                  if (!kIsWeb && adsProvider.isAdEnabled)
                    _checkAndShowRewardAd();
                  imageProvider.removeAllImages();
                  Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Homepage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else if (i == 1) {
                  shareResult();
                } else {
                  if (networkProvider.isConnected == false) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          icon: Icon(
                            FeatherIcons.alertTriangle,
                            color: Colors.redAccent,
                            size: 45,
                          ),
                          title: Text(
                            'network_title',
                            textAlign: TextAlign.center,
                            style: AppFonts.title(context),
                          ).tr(),
                          content: Text(
                            'network_description',
                            textAlign: TextAlign.center,
                            style: AppFonts.contentWarning(context),
                          ).tr(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          actions: <Widget>[
                            GestureDetector(
                              onTap: () async {
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
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
                                          context),
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
                  if (networkProvider.isConnected == true) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Container(
                          height: (kIsWeb)
                              ? MediaQuery.of(context).size.height * 0.35
                              : MediaQuery.of(context).size.height * 0.3,
                          width: (kIsWeb)
                              ? 420
                              : MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Handle on top
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              SizedBox(height: 20),

                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Row(
                                  children: [
                                    Text('required_nickname',
                                            style: AppFonts.popupTitle(context))
                                        .tr(),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Row(
                                  children: [
                                    Flexible(
                                      // 텍스트가 부모 위젯 범위를 초과하지 않도록 설정
                                      child: Text(
                                        'nickname_description',
                                        style: AppFonts.popupSubtitle(context),
                                        maxLines: 2, // 최대 두 줄로 제한
                                        overflow: TextOverflow
                                            .ellipsis, // 초과 텍스트를 생략 표시(...)
                                      ).tr(),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20),
                              CustomButton(
                                text: 'enter_nickname',
                                onPressed: () {
                                  // if (!kIsWeb && adsProvider.isAdEnabled)
                                  //   showRewardedAd();
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          NicknamePage(
                                        uuid: widget.uuid,
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('cancel',
                                        style: AppFonts.rankingCancel(context))
                                    .tr(),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  // Navigator.of(context).push(
                  //   PageRouteBuilder(
                  //     pageBuilder: (context, animation, secondaryAnimation) =>
                  //         RankingPage(
                  //       photo1: widget.photo1,
                  //       photo2: widget.photo2,
                  //       score: score,
                  //       heart: heart,
                  //     ),
                  //     transitionsBuilder:
                  //         (context, animation, secondaryAnimation, child) {
                  //       const begin = Offset(1.0, 0.0);
                  //       const end = Offset.zero;
                  //       const curve = Curves.ease;

                  //       var tween = Tween(begin: begin, end: end)
                  //           .chain(CurveTween(curve: curve));

                  //       return SlideTransition(
                  //         position: animation.drive(tween),
                  //         child: child,
                  //       );
                  //     },
                  //   ),
                  // );
                }
              },
            ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );

    return FixedWebSizeWrapper(
      child: MaterialApp(
        title: 'Kissing Booth',
        theme: lightTheme,
        darkTheme: dartTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        home: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            title: kIsWeb &&
                    (defaultTargetPlatform != TargetPlatform.iOS) &&
                    (defaultTargetPlatform != TargetPlatform.android)
                ? Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text('title', style: AppFonts.title2(context)).tr(),
                  )
                : Text('title', style: AppFonts.title2(context)).tr(),
            automaticallyImplyLeading: false,
          ),
          body: ColorfulSafeArea(
            color: Theme.of(context).colorScheme.background,
            child: Stack(
              children: [
                kIsWeb &&
                        (defaultTargetPlatform != TargetPlatform.iOS) &&
                        (defaultTargetPlatform != TargetPlatform.android)
                    ? content
                    : SingleChildScrollView(
                        child: content,
                      ),
                // if (!kIsWeb)
                //   Positioned(
                //     left: 0,
                //     right: 0,
                //     bottom: 10,
                //     child: AnimatedSlide(
                //       offset: _showBottomNavBar ? Offset(0, 0) : Offset(0, 1),
                //       duration: const Duration(milliseconds: 800),
                //       curve: Curves.fastEaseInToSlowEaseOut,
                //       child: Visibility(
                //         visible: _showBottomNavBar,
                //         child: googleAdMobContainer(isGroup: true),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
          bottomNavigationBar: networkProvider.isConnected
              ? (!kIsWeb)
                  ? (_bannerAd == null
                      ? Container(
                          color: Colors.transparent,
                        )
                      : Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          color: Theme.of(context).colorScheme.surface,
                          height: 60,
                          child: AdWidget(ad: _bannerAd!),
                        ))
                  : SizedBox()
              : SizedBox(),
        ),
      ),
    );
  }
}
