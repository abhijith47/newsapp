import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsapp/UI/homepage.dart';
import 'package:newsapp/UI/latestNews.dart';
import 'package:newsapp/UI/newsDetails.dart';
import 'package:newsapp/providers/newsProvider.dart';
import 'package:provider/provider.dart';
import 'providers/categoryProvider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //define providers here
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Homepage(),
        //define page routes here
        routes: {
          Homepage.routeName: (context) => Homepage(),
          NewsDetails.routeName: (context) => NewsDetails(),
          LatestNews.routeName: (context) => LatestNews(),
        },
      ),
    );
  }
}
