import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/models/categoryModel.dart';
import 'package:newsapp/models/newsModel.dart';
import 'package:newsapp/utilities/utils.dart';
import 'package:provider/provider.dart';
import 'providers/categoryProvider.dart';
import 'providers/newsProvider.dart';
import 'utilities/Globals.dart';

class Api {
  //getting categories
  static getAllNews(context) async {
    if (await Utils.connectivityCheck()) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      try {
        final url = Uri.parse(Globals.baseUrl + 'news-and-blogs');
        debugPrint(url.toString());
        var response = await http.get(
          url,
        );

        if (response.statusCode == 202) {
          var data = jsonDecode(response.body);
          if (data['blogs_category'].length > 0) {
            debugPrint('--1--');
            // categoryProvider.categoryList.clear();
            for (int i = 0; i < data['blogs_category'].length; i++) {
              debugPrint(data['blogs_category'][i]['id'].toString());
              categoryProvider.addCategoryData(CategoryModel(
                CategoryId: data['blogs_category'][i]['id'].toString(),
                name: data['blogs_category'][i]['name'].toString(),
              ));
            }
            categoryProvider.refresh();
          }
        } else {
          debugPrint('no data received');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {}
  }

//getting the news from categories with id
  static Future<bool> getNews(context, catId) async {
    if (await Utils.connectivityCheck()) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      try {
        final url = Uri.parse(Globals.baseUrl + 'news-and-blogs-catg');
        var response = await http.post(url, body: {'category': catId}
            //headers: {"Authorization": "Bearer ${Globals.access}"},
            );
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['results'].length == 0) {
            newsProvider.newsList.clear();
            newsProvider.refresh();
          }
          if (data['results'].length > 0) {
            newsProvider.newsList.clear();
            for (int i = 0; i < data['results'].length; i++) {
              newsProvider.addNewsData(NewsModel(
                  NewsId: data['results'][i]['id'].toString(),
                  image: data['results'][i]['image'].toString(),
                  title: data['results'][i]['title'].toString(),
                  content: data['results'][i]['content'].toString(),
                  date: data['results'][i]['created_at'],
                  next: data['next'].toString()));
              if (i < 5) {
                Globals.slider_images
                    .add(data['results'][i]['image'].toString());
              }
            }
            newsProvider.refresh();
            return true;
          }
          return false;
        } else {
          debugPrint('no data received');
          return false;
        }
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

//getting more data
  static getMoreNews(context, catId, next) async {
    if (await Utils.connectivityCheck()) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      try {
        final url = Uri.parse(Globals.baseUrl + 'news-and-blogs-catg');
        var response =
            await http.post(url, body: {'category': catId, 'next': next}
                //headers: {"Authorization": "Bearer ${Globals.access}"},
                );
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['results'].length == 0) {
            newsProvider.newsList.clear();
            newsProvider.refresh();
          }
          if (data['results'].length > 0) {
            for (int i = 0; i < data['results'].length; i++) {
              newsProvider.addNewsData(NewsModel(
                  NewsId: data['results'][i]['id'].toString(),
                  image: data['results'][i]['image'].toString(),
                  title: data['results'][i]['title'].toString(),
                  content: data['results'][i]['content'].toString(),
                  date: data['results'][i]['created_at'],
                  next: data['next'].toString()));
            }
            newsProvider.refresh();
          }
        } else {
          debugPrint('no data received');
        }
      } catch (e) {}
    } else {}
  }
}
