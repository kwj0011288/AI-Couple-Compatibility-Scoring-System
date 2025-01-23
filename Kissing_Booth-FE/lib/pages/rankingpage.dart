import 'dart:math';

import 'package:flutter/material.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kissing_booth/ads/ad_helper.dart';
import 'package:kissing_booth/api/apiService.dart';
import 'package:kissing_booth/api/test/dummy.dart';
import 'package:kissing_booth/api/totalUserInfo.dart';
import 'package:kissing_booth/component/rankingTile.dart';
import 'package:kissing_booth/pages/fixedWebWrapper.dart';
import 'package:kissing_booth/pages/homepage.dart';
import 'package:kissing_booth/provider/adsprovider.dart';
import 'package:kissing_booth/provider/imageprovider.dart';
import 'package:kissing_booth/provider/networkprovider.dart';
import 'package:kissing_booth/theme/dark.dart';
import 'package:kissing_booth/theme/font.dart';
import 'package:kissing_booth/theme/light.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankingPage extends StatefulWidget {
  final String uuid;
  final double score;
  final int ranking;
  final String nickname;

  final bool isHomepage;

  RankingPage({
    this.score = 0,
    this.isHomepage = false,
    this.ranking = 0,
    this.nickname = '',
    required this.uuid,
  });

// // {user_id: 8D194FD8-829B-4278-832E-C1FA5669C339-7, nickname: gggg, ranking: 2, score: 0.08}
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late DraggableScrollableController _controller;
  late ScrollController _scrollController;
  RewardedAd? _rewardedAd;
  bool titleVisible = false;
  final ApiService _apiService = ApiService();
  List<TotalRankingUserInfo> userTotalRanking = [];
  List<BannerAd?> _bannerAds = [];
  bool isLoading = true;
  bool isAds = true;

  int _offset = 0;
  final int _limit = 10;
  bool _hasMore = true;

  int totalUsers = 0;
  int randomMode = -1; // 랜덤 번호의 mode 값 저장

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        fetchTotalRankings();
      }
    });

    _controller.addListener(() {
      // 최대 스크롤 영역에 도달하면 데이터 로드
      if (_controller.size >= 1.0 - 0.1 && !isLoading) {
        fetchTotalRankings();
      }
    });

    if (!kIsWeb) _createRewardedAds();
    if (!kIsWeb) _initializeBannerAds();

    fetchTotalRankings();
    fetchTotalUsers();

    if (!kIsWeb) {
      if (isAds) {
        Future.delayed(const Duration(seconds: 5), () {
          if (!kIsWeb) _checkAndShowRewardAd();
        });
      }
    }

    _generateRandomMode();
  }

  void _generateRandomMode() {
    final random = Random(); // Dart의 Random 클래스
    int randomNumber = random.nextInt(100); // 0부터 99 사이의 랜덤 숫자
    setState(() {
      randomMode = randomNumber % 2; // mode 계산 (0 또는 1)
    });
  }

  void fetchTotalUsers() async {
    try {
      final apiService = ApiService();
      final result = await apiService.getTotalUsers();

      final totalNickname = result['total_nickname'];
      final totalNoNickname = result['total_no_nickname'];

      totalUsers = totalNickname!;
      setState(() {
        totalUsers = totalNickname ?? 0;
      });
      print('닉네임이 있는 사용자 수: $totalNickname');
      print('총 사용자 수: $totalNoNickname');
    } catch (e) {
      print('Failed to fetch total users: $e');
    }
  }

  Future<void> fetchTotalRankings() async {
    if (!_hasMore) return;

    try {
      setState(() {
        isLoading = true;
      });

      List<TotalRankingUserInfo> newRankings =
          await _apiService.getTotalRankings(_offset, _limit);

      setState(() {
        _offset += newRankings.length;
        userTotalRanking.addAll(newRankings);

        if (newRankings.length < _limit) {
          _hasMore = false;
        }

        // 광고 초기화 호출
        _initializeBannerAds();
      });
    } catch (e) {
      print('Failed to fetch rankings: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initializeBannerAds() {
    // userTotalRanking이 비어 있으면 초기화하지 않음
    if (userTotalRanking.isEmpty) return;

    // 광고 배치 개수를 계산
    final adCount = userTotalRanking.length ~/ 6;
    _bannerAds = List.generate(adCount, (_) => _createBannerAd());
  }

  BannerAd _createBannerAd() {
    return BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: AdHelper.bannerAdLinster,
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _controller.removeListener(() {}); // 리스너 제거
    _rewardedAd?.dispose(); // 광고 객체 해제
    for (var bannerAd in _bannerAds) {
      bannerAd?.dispose(); // Dispose all banner ads
    }
    super.dispose();
  }

  void animateTo(double targetSize) {
    _controller.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastEaseInToSlowEaseOut, // Apply the desired curve
    );
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  Future<void> _checkAndShowRewardAd() async {
    // Use SharedPreferences to store the ad counter
    final prefs = await SharedPreferences.getInstance();
    int adCounter = prefs.getInt('ranking_ad_counter') ?? 0;

    // Log the current ad counter for debugging
    print('Ranking Page Ad Counter: $adCounter');

    // Show ad on every 0, 2, 4, ... counter values
    if (adCounter % 2 == 0) {
      print('Showing Reward Ad on Ranking Page for counter: $adCounter');
      showRewardedAd();
    }

    // Increment and save the ad counter
    adCounter++;
    await prefs.setInt('ranking_ad_counter', adCounter);

    // Log the updated counter
    print('Updated Ranking Page Ad Counter: $adCounter');
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
          () => print("Rewarded Ad shown on Ranking Page"),
        ),
      );
      _rewardedAd = null;
    }
  }

  String getRankingText(int rank, BuildContext context) {
    final locale = context.locale.languageCode; // 현재 언어 코드 가져오기

    // 접미사 선택
    String suffix;
    if (locale == "en") {
      if (rank % 10 == 1 && rank % 100 != 11) {
        suffix = 'ranking_suffix_1'.tr();
      } else if (rank % 10 == 2 && rank % 100 != 12) {
        suffix = 'ranking_suffix_2'.tr();
      } else if (rank % 10 == 3 && rank % 100 != 13) {
        suffix = 'ranking_suffix_3'.tr();
      } else {
        suffix = 'ranking_suffix_4'.tr();
      }
    } else {
      suffix = 'ranking_suffix_1'.tr(); // 다른 언어는 단순히 suffix_1 사용
    }

    // 접두사와 랭킹 조합
    final prefix = 'ranking_prefix'.tr();
    return "$prefix$rank$suffix";
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageProviderModel>(context);
    final networkProvider = Provider.of<NetworkProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);

    double currentRank = widget.ranking.toDouble();
    int totalRank = userTotalRanking.length;
    double rate = currentRank / totalRank;

    print(widget.score);
    return FixedWebSizeWrapper(
      child: MaterialApp(
        title: 'Ranking',
        theme: lightTheme,
        darkTheme: dartTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          extendBody: true,
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
              title: widget.isHomepage
                  ? _buildTitleBox(context)
                  : titleVisible
                      ? _buildTitleBox(context)
                      : null,
              leading: widget.isHomepage
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: kIsWeb &&
                              (defaultTargetPlatform != TargetPlatform.iOS) &&
                              (defaultTargetPlatform != TargetPlatform.android)
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 20, bottom: 8),
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 15,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 8, bottom: 8),
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 15,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    )
                  : null),
          body: Stack(
            children: [
              ColorfulSafeArea(
                color: Theme.of(context).colorScheme.primary,
                bottom: false,
                child: isLoading && !_hasMore
                    ? Center(
                        child: Lottie.asset(
                          'assets/lottie/heart_loading.json',
                          height: 400,
                          width: 400,
                        ),
                      )
                    : widget.isHomepage
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: userTotalRanking.length + // 데이터 개수
                                  (userTotalRanking.length ~/ 6) + // 광고 슬롯 추가
                                  (_hasMore ? 1 : 0), // 로딩 인디케이터 추가
                              itemBuilder: (context, index) {
                                // 광고 배치 로직: 6, 12, 18, ... 위치에 광고 삽입
                                if (index > 0 && index % 6 == 0) {
                                  final adIndex = (index ~/ 6) - 1;
                                  if (adIndex < _bannerAds.length) {
                                    final bannerAd = _bannerAds[adIndex];
                                    return bannerAd == null
                                        ? const SizedBox()
                                        : Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            alignment: Alignment.center,
                                            child: AdWidget(ad: bannerAd),
                                            width:
                                                bannerAd.size.width.toDouble(),
                                            height:
                                                bannerAd.size.height.toDouble(),
                                          );
                                  }
                                }

                                // 데이터 인덱스 계산: 광고 슬롯 제외
                                final adjustedIndex = index - (index ~/ 6);
                                if (adjustedIndex < userTotalRanking.length) {
                                  final currentUser =
                                      userTotalRanking[adjustedIndex];
                                  return RankingTile(
                                    rank:
                                        currentUser.ranking, // API에서 제공된 순위 사용
                                    imageUrls: [
                                      currentUser.photo1,
                                      currentUser.photo2
                                    ],
                                    nickname: currentUser.nickname,
                                    score: currentUser.score,
                                    isCoupleRank: false,
                                  );
                                }

                                // 로딩 인디케이터 반환
                                if (_hasMore &&
                                    index ==
                                        userTotalRanking.length +
                                            (userTotalRanking.length ~/ 6)) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Lottie.asset(
                                        'assets/lottie/heart_loading.json',
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  );
                                }

                                return const SizedBox();
                              },
                            ),
                          )
                        : Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.nickname,
                                              style: AppFonts.title5(context))
                                          .tr(),
                                      Text('our_ranking',
                                              style: AppFonts.title5(context))
                                          .tr(),
                                    ],
                                  ),

                                  SizedBox(height: 10),
                                  Text(getRankingText(widget.ranking, context),
                                          style: AppFonts.title4(context))
                                      .tr(),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                                  //   child: RankingTile(
                                  //     rank: 50,
                                  //     imageUrls: [
                                  //       dummyUsers[0].imageUrl1,
                                  //       dummyUsers[0].imageUrl2
                                  //     ],
                                  //     nickname: "hello",
                                  //     score: 50,
                                  //     isCoupleRank: true,
                                  //   ),
                                  // ),
                                  SizedBox(height: 10),
                                  _buildtotalRate(context, currentRank,
                                      totalRank, rate, totalUsers),

                                  SizedBox(height: 15),
                                ],
                              ),
                              DraggableScrollableSheet(
                                controller:
                                    _controller, // DraggableScrollableController 연결
                                initialChildSize: 0.55, // 시작 크기
                                minChildSize: 0.55, // 최소 크기
                                maxChildSize: 1.0, // 최대 크기
                                snap: true, // 스냅 동작 활성화
                                snapSizes: [0.55, 1.0], // 스냅 크기 지정
                                builder: (BuildContext context,
                                    draggableScrollController) {
                                  // ScrollController 리스너 추가
                                  draggableScrollController.addListener(() {
                                    if (draggableScrollController
                                                .position.pixels ==
                                            draggableScrollController
                                                .position.maxScrollExtent &&
                                        _hasMore && // 더 로드할 데이터가 있는지 확인
                                        !isLoading) {
                                      // 로딩 중인지 확인
                                      fetchTotalRankings();
                                    }
                                  });

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .shadow,
                                          blurRadius: 10,
                                          offset: Offset(10, 4),
                                        ),
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .shadow,
                                          blurRadius: 10,
                                          offset: Offset(-2, 0),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 10.0),
                                          width: 40,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: ListView.builder(
                                            controller:
                                                draggableScrollController,
                                            itemCount: userTotalRanking
                                                    .length + // 데이터 개수
                                                (userTotalRanking.length ~/
                                                    6) + // 광고 슬롯 추가
                                                (_hasMore
                                                    ? 1
                                                    : 0), // 로딩 인디케이터 추가
                                            itemBuilder: (context, index) {
                                              // 광고 배치 로직: 6, 12, 18, ... 위치에 광고 삽입
                                              if (index > 0 && index % 6 == 0) {
                                                final adIndex =
                                                    (index ~/ 6) - 1;
                                                if (adIndex <
                                                    _bannerAds.length) {
                                                  final bannerAd =
                                                      _bannerAds[adIndex];
                                                  return bannerAd == null
                                                      ? const SizedBox()
                                                      : Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: AdWidget(
                                                              ad: bannerAd),
                                                          width: bannerAd
                                                              .size.width
                                                              .toDouble(),
                                                          height: bannerAd
                                                              .size.height
                                                              .toDouble(),
                                                        );
                                                }
                                              }

                                              // 데이터 인덱스 계산: 광고 슬롯 제외
                                              final adjustedIndex =
                                                  index - (index ~/ 6);
                                              if (adjustedIndex <
                                                  userTotalRanking.length) {
                                                final currentUser =
                                                    userTotalRanking[
                                                        adjustedIndex];
                                                return RankingTile(
                                                  rank: currentUser
                                                      .ranking, // API에서 제공된 순위 사용
                                                  imageUrls: [
                                                    currentUser.photo1,
                                                    currentUser.photo2
                                                  ],
                                                  nickname:
                                                      currentUser.nickname,
                                                  score: currentUser.score,
                                                  isCoupleRank: false,
                                                );
                                              }

                                              // 로딩 인디케이터 반환
                                              if (_hasMore &&
                                                  index ==
                                                      userTotalRanking.length +
                                                          (userTotalRanking
                                                                  .length ~/
                                                              6)) {
                                                return Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Lottie.asset(
                                                      'assets/lottie/heart_loading.json',
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                                  ),
                                                );
                                              }

                                              return const SizedBox();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (randomMode == 0) if (!kIsWeb &&
                          adsProvider.isAdEnabled) showRewardedAd();
                      imageProvider.removeAllImages();
                      Navigator.of(context).pushAndRemoveUntil(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                    },
                    child: Container(
                      height: 45,
                      width: 120,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      child: Text('retry',
                              style: AppFonts.retryRankingButton2(context))
                          .tr(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildtotalRate(BuildContext context, double currentRank,
      int totalRank, double rate, int totalUsers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none, // 부모 영역을 넘어서도 렌더링 허용
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 10,
                    offset: Offset(6, 4),
                  ),
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 10,
                    offset: Offset(-2, 0),
                  ),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text('total_rate', style: AppFonts.rankingTitle(context)).tr(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('${currentRank.toInt()}',
                        style: AppFonts.rankingRate(context)),
                    Text(' / $totalUsers',
                        style: AppFonts.rankingTotal(context)),
                    Spacer(),
                    Text('${(widget.score * 10).toStringAsFixed(2)}',
                            style: AppFonts.myScore(context))
                        .tr(),
                    Text(' / 10', style: AppFonts.myScoreTotal(context)),
                  ],
                ),
                SizedBox(height: 10),
                _buildProgressBar(10, widget.score, rate), // ProgressBar 포함
              ],
            ),
          ),
          // 검은 박스가 삐져나오도록 조정
        ],
      ),
    );
  }

  Widget _buildProgressBar(double maxScore, double score, double rate) {
    List<Color> colors = [
      Colors.red,
      Colors.yellow,
      Colors.lightGreen,
      Colors.green,
    ];
    List<double> thresholds = [0.25, 0.5, 0.75, 1.0];

    // Reverse rate for ranking (low rank is better)
    double reversedRate = 1.0 - rate.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth; // Use 90% of the available width
        return Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // ProgressBar background
                Row(
                  children: List.generate(colors.length, (index) {
                    double segmentWidth = width *
                        (thresholds[index] -
                            (index == 0 ? 0 : thresholds[index - 1]));
                    return Container(
                      width: segmentWidth,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.only(
                          topLeft:
                              index == 0 ? Radius.circular(6) : Radius.zero,
                          bottomLeft:
                              index == 0 ? Radius.circular(6) : Radius.zero,
                          topRight: index == colors.length - 1
                              ? Radius.circular(6)
                              : Radius.zero,
                          bottomRight: index == colors.length - 1
                              ? Radius.circular(6)
                              : Radius.zero,
                        ),
                      ),
                    );
                  }),
                ),
                // Indicator box and text
                Positioned(
                  left: (width * reversedRate).clamp(0, width) +
                      1, // Ensure it stays within bounds
                  top: -4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 3,
                        height: 20, // Indicator height
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      SizedBox(height: 4),
                      // Text(
                      //   '${((1 - rate) * 100).toStringAsFixed(0)}%',
                      //   style: AppFonts.currentMyScore(context),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildTitleBox(BuildContext context) {
    return kIsWeb &&
            (defaultTargetPlatform != TargetPlatform.iOS) &&
            (defaultTargetPlatform != TargetPlatform.android)
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text('ranking_title', style: AppFonts.title(context)).tr(),
                SizedBox(height: 10),
              ],
            ),
          )
        : Column(
            children: [
              SizedBox(height: 20),
              Text('ranking_title', style: AppFonts.title(context)).tr(),
              SizedBox(height: 10),
            ],
          );
  }
}
