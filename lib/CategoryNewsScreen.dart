import 'package:flutter/material.dart';
import 'article.dart';
import 'news_service.dart';
import 'article_tile.dart';

class CategoryNewsScreen extends StatefulWidget {
  final String category;

  const CategoryNewsScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryNewsScreenState createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  late Future<List<Article>> articles;

  @override
  void initState() {
    super.initState();
    articles = NewsService().fetchArticlesByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category[0].toUpperCase()}${widget.category.substring(1)} News'),
      ),
      body: FutureBuilder<List<Article>>(
        future: articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No articles available for this category.'));
          }

          final categoryArticles = snapshot.data!;
          return ListView.builder(
            itemCount: categoryArticles.length,
            itemBuilder: (context, index) {
              final article = categoryArticles[index];
              return ArticleTile(
                article: article,
                onSave: () {
                  // Save functionality (if required)
                },
                onTap: () {
                  // Navigate to detailed view (if required)
                },
                isSaved: false, // Adjust based on saved state
              );
            },
          );
        },
      ),
    );
  }
}
