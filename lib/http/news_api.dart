import 'dart:convert';

import 'package:git_news/newscode/repos.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  final String apiKey = '328dcab42b5847b8b1e207082222fb0f';

  Future<repos> fetchnews({String source = '', String category = ''}) async {
    String baseUrl = 'https://newsapi.org/v2/top-headlines';
    String url;
    
    if (category.isNotEmpty) {
      url = '$baseUrl?category=$category&apiKey=$apiKey';
    } else if (source.isNotEmpty) {
      url = '$baseUrl?sources=$source&apiKey=$apiKey';
    } else {
      url = '$baseUrl?country=us&apiKey=$apiKey';
    }
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return repos.fromJson(body);
    }
    throw Exception('Error fetching news');
  }
}