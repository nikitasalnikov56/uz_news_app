import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson6/bloc/news_bloc.dart';
import 'package:lesson6/pages/home_page.dart';
import 'package:lesson6/services/news_repository.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) =>
            NewsBloc(newsRepository: NewsRepository())..add(NewsLoadRuEvent()),
        child: const HomePage(),
      ),
    );
  }
}
