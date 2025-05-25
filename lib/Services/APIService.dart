import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newproject/Model/articles.dart';

class APIService{
  static const String api_key = 'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=ef3cf796ce8244dca583ed51dbb0702f';

  Future<List<Article>> fetchArticles() async {
      final response = await http.get(Uri.parse(api_key));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data.length);
        print(data.toString());
        final List<dynamic> articlesJson = data['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load articles');
      }

  }
}