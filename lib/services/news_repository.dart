import 'package:dart_rss/dart_rss.dart';
import 'package:lesson6/services/api.dart';

class NewsRepository {
  Future<RssFeed?> getAllNews({String? lang}) => Api.getDataRss(lang: lang);
}
