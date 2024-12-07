import 'package:flutter/material.dart';
import 'article.dart';

class ArticleSearchDelegate extends SearchDelegate<String> {
  final List<Article> articles;
  final Function(String) onSearch;

  ArticleSearchDelegate({required this.articles, required this.onSearch});

  @override
  String? get searchFieldLabel => 'Search Articles';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query); // Clear search query
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = articles
        .where((article) =>
        article.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return ListTile(
          title: Text(article.title),
          subtitle: Text(article.description),
          onTap: () {
            close(context, article.title); // Close search with selected title
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = articles
        .where((article) =>
        article.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final article = suggestions[index];
        return ListTile(
          title: Text(article.title),
          onTap: () {
            query = article.title; // Set query to the selected suggestion
            showResults(context);
          },
        );
      },
    );
  }
}
