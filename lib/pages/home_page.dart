import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson6/bloc/news_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Study App'),
        centerTitle: true,
      ),
      body: const NewsBodyWidget(),
    );
  }
}

class NewsBodyWidget extends StatelessWidget {
  const NewsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewsLoadedState) {
          final item = state.newsFeed?.items;
          return Column(
            children: [
              SizedBox(
                height: 250,
                child: CarouselSlider.builder(
                  itemCount: item?.length,
                  itemBuilder: (context, index, i) {
                    return CachedNetworkImage(
                        imageUrl: '${item?[index].enclosure?.url}');
                  },
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: true,

                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              Expanded(
                  child: ListView.separated(
                itemBuilder: (context, i) {
                  final desc = item?[i].description?.replaceAll('<p>', '');
                  return Card(
                    color:
                        i % 2 == 0 ? Colors.deepPurple[200] : Colors.grey[300],
                    child: ListTile(
                      onTap: () async {
                        final Uri url = Uri.parse('${item?[i].link}');
                        try {
                          await launchUrl(url);
                        } catch (e) {
                          throw 'Could\'t launch $url';
                        }
                      },
                      title: Text(
                        '${item?[i].title}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('$desc'),
                    ),
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(height: 8),
                itemCount: item?.length ?? 0,
              )),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
