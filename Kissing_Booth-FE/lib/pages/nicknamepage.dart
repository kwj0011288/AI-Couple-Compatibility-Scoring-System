import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kissing_booth/ads/ad_helper.dart';
import 'package:kissing_booth/api/apiService.dart';
import 'package:kissing_booth/pages/fixedWebWrapper.dart';
import 'package:kissing_booth/pages/rankingpage.dart';
import 'package:kissing_booth/provider/adsprovider.dart';
import 'package:kissing_booth/theme/dark.dart';
import 'package:kissing_booth/theme/font.dart';
import 'package:kissing_booth/theme/light.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NicknamePage extends StatefulWidget {
  final String uuid;

  NicknamePage({
    required this.uuid,
  });

  @override
  _NicknamePageState createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final TextEditingController _nicknameController = TextEditingController();
  String _errorMessageKey = '';
  bool _showErrorMessage = false; // 에러 메시지 표시 여부 상태 변수

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = Provider.of<AdsProvider>(context);
    final ApiService _apiService = ApiService();

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
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'enter_nickname_placeholder',
                  style: AppFonts.title(context),
                ).tr(),
                const SizedBox(height: 20),
                Text(
                  'enter_nickname_description',
                  style: AppFonts.subtitle2(context),
                ).tr(),
                const SizedBox(height: 20),
                CupertinoTextField(
                  autofocus: true,
                  textAlign: TextAlign.center,
                  controller: _nicknameController,
                  padding: const EdgeInsets.all(10),
                  placeholder: "Kissing Booth",
                  placeholderStyle: AppFonts.title3(context),
                  style: AppFonts.title(context),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  cursorColor: Theme.of(context).colorScheme.outline,
                  cursorHeight: 40,
                  onChanged: (text) {
                    setState(() {
                      _showErrorMessage = false; // 입력 중 에러 메시지 숨기기
                      _errorMessageKey = ''; // 에러 메시지 키 초기화
                    });
                  },
                  maxLength: 13,
                ),
                const SizedBox(height: 20),
                if (_showErrorMessage) // 에러 메시지가 있을 때만 표시
                  Text(
                    _errorMessageKey,
                    style: AppFonts.error(context),
                  ).tr(),
              ],
            ),
          ),
          bottomSheet: GestureDetector(
            onTap: () async {
              FocusScope.of(context).unfocus();

              if (_nicknameController.text.isEmpty) {
                setState(() {
                  _showErrorMessage = true;
                  _errorMessageKey =
                      'nickname_error_empty'; // 닉네임이 비어있을 때 에러 메시지 키
                });
                return;
              }

              try {
                setState(() {
                  _showErrorMessage = false; // API 호출 전 에러 메시지 숨김
                });

                final fetchData = await _apiService.getUserRanking(
                  userId: widget.uuid,
                  nickname: _nicknameController.text,
                );

                if (fetchData == null || !fetchData.containsKey('score')) {
                  throw Exception('Invalid response from API');
                }

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => RankingPage(
                      score: fetchData['score'],
                      uuid: widget.uuid,
                      ranking: fetchData['ranking'] ?? 0,
                      nickname: fetchData['nickname'],
                    ),
                  ),
                  (Route<dynamic> route) => false,
                );

                _nicknameController.clear();
              } catch (e) {
                setState(() {
                  _showErrorMessage = true;
                  _errorMessageKey =
                      'nickname_error_api'; // API 호출 실패 시 에러 메시지 키
                });
                print('API Error: $e');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                height: 55,
                width: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(60)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ranking',
                      style: AppFonts.button(Colors.white, context),
                    ).tr(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
