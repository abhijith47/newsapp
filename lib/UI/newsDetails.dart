import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/models/newsModel.dart';
import 'package:newsapp/utilities/Globals.dart';

class NewsDetails extends StatefulWidget {
  static const routeName = '/news_details';
  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  String formatDates(String unformatteddate) {
    var date = DateTime.parse(unformatteddate);
    final formatter = DateFormat('d MMM y hh:mm a');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final NewsModel news =
        ModalRoute.of(context)!.settings.arguments as NewsModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        elevation: 0,
        leading: Container(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 15,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .95,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        color: Colors.grey.shade200,
                        child: CachedNetworkImage(
                          imageUrl:
                              Globals.image_baseUrl + news.image.toString(),
                          // placeholder: (context, url) =>
                          //     CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.grey,
                          ),
                          height: 200.0,
                          width: MediaQuery.of(context).size.width * .95,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Container(
                        child: Text(
                          news.title.toString(),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Updated : ' + formatDates(news.date),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 25, bottom: 25, right: 15),
                      child: Text(
                        news.content.toString(),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
