import 'dart:math';

class NewsModel {
  String? NewsId;
  String? image;
  String? title;
  String? content;
  String? next;
  dynamic? date;

  NewsModel(
      {this.NewsId,
      this.image,
      this.content,
      this.title,
      this.next,
      this.date});
}
