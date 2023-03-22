import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/api.dart';
import 'package:newsapp/providers/categoryProvider.dart';
import 'package:newsapp/providers/newsProvider.dart';
import 'package:newsapp/utilities/Globals.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  static const routeName = '/homepage';
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  ScrollController _scrollController = ScrollController();
  bool _isEndReached = false;
  @override
  void initState() {
    super.initState();
    //luistening to page scrolling and reaching end
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _onEndReached(context);
      } else {
        _isEndReached = false;
      }
    });
  }

  // Define the function to be called when the user reaches the end of the list
  // this is deactivated for now
  void _onEndReached(BuildContext context) async {
    final categoryConsumer =
        Provider.of<CategoryProvider>(context, listen: true);
    final newsProvider = Provider.of<NewsProvider>(context, listen: true);
    if (!_isEndReached) {
      _isEndReached = true;
      print('jjj');
      await Api.getMoreNews(
          context,
          categoryConsumer.categoryList[selectedIndex].CategoryId,
          newsProvider.newsList[0].next.toString());
    }
  }

//getting categories
  getNews(context) async {
    final categoryConsumer =
        Provider.of<CategoryProvider>(context, listen: true);
    await Api.getAllNews(context);
    getCategory(context, categoryConsumer.categoryList[0].CategoryId);
  }

//getting news
  getCategory(context, id) async {
    await Api.getNews(context, id);
  }

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

  bool instance = true;
  @override
  Widget build(BuildContext context) {
    final categoryConsumer =
        Provider.of<CategoryProvider>(context, listen: true);
    final newsProvider = Provider.of<NewsProvider>(context, listen: true);
    if (instance) {
      instance = false;
      getNews(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'News & Blogs',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryConsumer.categoryList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectedIndex = index;
                        getCategory(context,
                            categoryConsumer.categoryList[index].CategoryId);
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          categoryConsumer.categoryList[index].name.toString(),
                          style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.green
                                  : Colors.black),
                        ),
                      ),
                    );
                  })),
          newsProvider.newsList.length > 0
              ? CarouselSlider.builder(
                  itemCount: newsProvider.newsList.length,
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 2.0,
                    initialPage: 2,
                  ),
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: CachedNetworkImage(
                      imageUrl: Globals.image_baseUrl +
                          newsProvider.newsList[itemIndex].image.toString(),
                      // placeholder: (context, url) =>
                      //     CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.grey,
                      ),
                      height: 140.0,
                      width: MediaQuery.of(context).size.width * .9,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : SizedBox(),
          selectedIndex == 0 && newsProvider.newsList.length > 0
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Latest News',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/latest',
                            );
                          },
                          child: const Text(
                            'Read More',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(height: 0, width: 0),
          Expanded(
              child: ListView.builder(
                  controller: _scrollController,
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
                  })),
        ],
      ),
    );
  }
}
