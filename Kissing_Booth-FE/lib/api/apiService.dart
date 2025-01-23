import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:kissing_booth/api/ranking.dart';
import 'package:kissing_booth/api/totalUserInfo.dart';

class ApiService {
  final String baseUrl = "https://api.kissing-booth-ai.com";
  // final String baseUrl = "http://3.217.179.91:8000";
  Future<Map<String, dynamic>> getCoupleScore({
    required String userId,
    required File photo1,
    required File photo2,
  }) async {
    final uri = Uri.parse('$baseUrl/matches/');

    // 파일 존재 여부 확인sdfsdf
    if (!photo1.existsSync() || !photo2.existsSync()) {
      throw Exception("One or both of the photo files do not exist.");
    }

    // HTTP POST 요청 생성
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({'Content-Type': 'multipart/form-data'})
      ..files.add(await http.MultipartFile.fromPath('photo1', photo1.path))
      ..files.add(await http.MultipartFile.fromPath('photo2', photo2.path))
      ..fields['user_id'] = userId;

    // 요청 전송
    final response = await request.send();

    // 응답 처리
    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return {
        'photo1_url': data['photo1_url'],
        'photo2_url': data['photo2_url'],
        'score': data['score'],
      };
    } else {
      throw Exception(
          'Failed to load couple score: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> getUserRanking({
    required String userId,
    required String nickname,
  }) async {
    final uri = Uri.parse('$baseUrl/matches/register-nickname/');

    // Prepare the request body
    final requestBody = {
      "user_id": userId,
      "nickname": nickname,
    };

    // Send the request with UTF-8 encoding
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: utf8.encode(jsonEncode(requestBody)),
    );

    // Handle the response with UTF-8 decoding
    if (response.statusCode == 200) {
      // Use utf8.decode to ensure the response body is properly decoded
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception('Failed to fetch user ranking: ${response.statusCode}');
    }
  }

  Future<List<TotalRankingUserInfo>> getTotalRankings(
      int offset, int limit) async {
    final uri =
        Uri.parse('$baseUrl/matches/rankings?offset=$offset&limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // UTF-8로 디코딩하여 한국어 깨짐 방지
      final decodedResponse = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

      // JSON 데이터에서 'results' 배열만 추출
      final List<dynamic> results = jsonResponse['results'];

      // TotalRankingUserInfo 객체 리스트로 매핑
      return results
          .map((json) => TotalRankingUserInfo.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load total rankings');
    }
  }

  Future<Map<String, int>> getTotalUsers() async {
    final uri = Uri.parse('$baseUrl/matches/total-users/');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // UTF-8로 디코딩하여 한국어 깨짐 방지
      final decodedResponse = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

      // total_nickname 및 total_no_nickname 값 추출
      final int totalNickname = jsonResponse['total_nickname'];
      final int totalNoNickname = jsonResponse['total_no_nickname'];

      return {
        'total_nickname': totalNickname,
        'total_no_nickname': totalNoNickname,
      };
    } else {
      throw Exception('Failed to fetch total users');
    }
  }
}
