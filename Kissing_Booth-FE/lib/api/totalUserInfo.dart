class TotalRankingUserInfo {
  final String id;
  final String nickname;
  final double score;
  final int ranking;
  final String photo1;
  final String photo2;

  TotalRankingUserInfo({
    required this.id,
    required this.nickname,
    required this.score,
    required this.ranking,
    required this.photo1,
    required this.photo2,
  });

  factory TotalRankingUserInfo.fromJson(Map<String, dynamic> json) {
    return TotalRankingUserInfo(
      id: json['user_id'], // JSON의 'user_id'를 클래스의 'id'로 매핑
      nickname: json['nickname'],
      score:
          double.tryParse(json['score'].toString()) ?? 0.0, // 문자열에서 double로 변환
      ranking: json['ranking'] as int,
      photo1: json['photo1_url'], // JSON의 'photo1_url'을 클래스의 'photo1'로 매핑
      photo2: json['photo2_url'], // JSON의 'photo2_url'을 클래스의 'photo2'로 매핑
    );
  }
}
