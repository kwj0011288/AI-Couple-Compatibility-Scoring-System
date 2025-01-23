import 'package:flutter/material.dart';

class RankProvider with ChangeNotifier {
  List<int> _rankingList = [];

  List<int> get rankingList => _rankingList;

  void setRankingList(List<int> newRankingList) {
    _rankingList = newRankingList;
    notifyListeners();
  }
}
