class Ranking {
  final String nickname;
  final double score;
  final String photo1;
  final String photo2;

  Ranking({
    required this.nickname,
    required this.score,
    required this.photo1,
    required this.photo2,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      nickname: json['nickname'],
      score: double.parse(json['score'].toString()),
      photo1: json['photo1'],
      photo2: json['photo2'],
    );
  }
}
