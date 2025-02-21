import 'package:git_news/http/news_api.dart';
import 'package:git_news/newscode/repos.dart';

class NewsViewModel {
  final _rep = NewsApi();

  Future<repos> fetchnews({String source = '', String category = ''}) async {
    final response = await _rep.fetchnews(source: source, category: category);
    return response;
  }
}
