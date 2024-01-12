import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson6/bloc/news_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

enum PopUpItem { ru, uz, en }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    PopUpItem? item;
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          icon: const Icon(Icons.language),
          initialValue: item,
          onSelected: (value) {
            item = value;
            if (item == PopUpItem.ru) {
              context.read<NewsBloc>().add(NewsLoadRuEvent());
            } else if (item == PopUpItem.uz) {
              context.read<NewsBloc>().add(NewsLoadUzEvent());
            } else {
              context.read<NewsBloc>().add(NewsLoadEnEvent());
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<PopUpItem>>[
            const PopupMenuItem<PopUpItem>(
              value: PopUpItem.ru,
              child: Text('RU'),
            ),
            const PopupMenuItem<PopUpItem>(
              value: PopUpItem.uz,
              child: Text('UZ'),
            ),
            const PopupMenuItem<PopUpItem>(
              value: PopUpItem.en,
              child: Text('EN'),
            ),
          ],
        ),
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
              //  const Padding(
              //     padding:  EdgeInsets.symmetric(horizontal: 14.0),
              //     child: PhysicalModel(
              //       color: Colors.black,
              //       elevation: 2,
              //       shadowColor: Colors.black,
              //       borderRadius: const BorderRadius.all(Radius.circular(20)),
              //       child: TextField(
              //         decoration:  InputDecoration(
              //           border: OutlineInputBorder(
              //             borderSide: BorderSide.none,
              //             borderRadius: BorderRadius.all(Radius.circular(20)),
              //           ),
              //           fillColor: Colors.white,
              //           filled: true,
              //         ),
              //       ),
              //     ),
              //   ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, i) {
                  // final desc = item?[i]
                  //     .description
                  //     ?.replaceAll('&laquo;', '')
                  //     .replaceAll('<p>', '')
                  //     .replaceAll('&raquo;', '');
                  return GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse('${item?[i].link}');
                      try {
                        await launchUrl(url);
                      } catch (e) {
                        throw 'Could\'t launch $url';
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF7CE495),
                            Color(0xFFCFF4D2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                            child: CachedNetworkImage(
                              imageUrl: '${item?[i].enclosure?.url}',
                              fit: BoxFit.cover,
                              width: 120,
                              height: 130,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 185),
                            child: Text(
                              '${item?[i].title}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF215273),
                                height: 25 / 16,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],

                        // subtitle: Text('$desc'),
                      ),
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
