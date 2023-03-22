import 'package:flutter/material.dart';
import 'package:newsapp/models/categoryModel.dart';
import 'package:newsapp/models/newsModel.dart';

class NewsProvider with ChangeNotifier {
  NewsModel _newsData = NewsModel();
  List<NewsModel> newsList = [];

  List<NewsModel> get newsData {
    return newsList;
  }

  void addNewsData(NewsModel obj) {
    _newsData = obj;
    newsList.add(_newsData);
    notifyListeners();
  }

  void removeItem(docId) {
    newsList.removeWhere((item) => item.NewsId == docId);

    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
