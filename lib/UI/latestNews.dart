import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/api.dart';
import 'package:newsapp/providers/categoryProvider.dart';
import 'package:newsapp/providers/newsProvider.dart';
import 'package:newsapp/utilities/Globals.dart';
import 'package:provider/provider.dart';

class LatestNews extends StatefulWidget {
  static const routeName = '/latest';
  @override
  State<LatestNews> createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  ScrollController _scrollController2 = ScrollController();

  Widget news(news) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: CachedNetworkImage(
                      imageUrl: Globals.image_baseUrl + news.image,
                      // placeholder: (context, url) =>
                      //     CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.grey,
                      ),
                      height: 120.0,
                      width: MediaQuery.of(context).size.width * .9,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title.toString(),
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                news.content.toString(),
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        ],
      ),
    );
  }

  getNews(context) async {
    final categoryConsumer =
        Provider.of<CategoryProvider>(context, listen: true);
    await Api.getAllNews(context);
    getCategory(context, categoryConsumer.categoryList[0].CategoryId);
  }

  getCategory(context, id) async {
    await Api.getNews(context, id);
  }

  bool instance = true;
  @override
  Widget build(BuildContext context) {
    if (instance) {
      instance = false;
      getNews(context);
    }
    final newsProvider = Provider.of<NewsProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 15,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Latest News',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            controller: _scrollController2,
            scrollDirection: Axis.vertical,
            itemCount: newsProvider.newsList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/news_details',
                      arguments: newsProvider.newsList[index]);
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: news(newsProvider.newsList[index])),
              );
            }),
      ),
    );
  }
}
