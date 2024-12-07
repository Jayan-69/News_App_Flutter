import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Import for handling SocketException
import 'package:http/http.dart' as http;
import 'article.dart';

class NewsService {
  final String _apiKey = '980f09e04a1149dda8f8169924fff672';
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  // Fetch general articles
  Future<List<Article>> fetchArticles() async {
    final url = Uri.parse('$_baseUrl?country=us&apiKey=$_apiKey');
    return await _fetchArticlesFromApi(url);
  }

  // Fetch articles by category
  Future<List<Article>> fetchArticlesByCategory(String category) async {
    final url = Uri.parse('$_baseUrl?country=us&category=$category&apiKey=$_apiKey');
    return await _fetchArticlesFromApi(url, category: category);
  }

  // Fetch articles from API - shared logic
  Future<List<Article>> _fetchArticlesFromApi(Uri url, {String? category}) async {
    try {
      final response = await http.get(url).timeout(Duration(seconds: 15)); // Timeout added
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['articles'] == null) {
          throw Exception('No articles found.');
        }

        // Convert the List<dynamic> to a List<Article>
        List<Article> articles = [];
        for (var articleJson in data['articles']) {
          articles.add(Article.fromJson(articleJson)); // Add Article instances
        }
        return articles;
      } else {
        throw Exception('Failed to load articles. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection.');
    } on http.ClientException {
      throw Exception('Client Exception occurred.');
    } on TimeoutException {
      throw Exception('The request timed out.');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
