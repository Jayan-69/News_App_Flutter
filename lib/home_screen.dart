import 'package:flutter/material.dart';
import 'CategorySelectionScreen.dart';
import 'article.dart';
import 'article_tile.dart';
import 'news_service.dart';
import 'article_search_delegate.dart';
import 'article_detail_screen.dart';
import 'package:my_news_app/main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Article>> articles;
  List<Article> savedArticles = [];
  List<Article> displayedArticles = [];
  String query = '';
  bool showSaved = false;
  String sortOption = 'Sort by Title';
  List<Article> allArticles = [];

  @override
  void initState() {
    super.initState();
    articles = NewsService().fetchArticles();
  }

  void _searchArticles(String query) {
    setState(() {
      this.query = query;
      displayedArticles = (showSaved ? savedArticles : allArticles)
          .where((article) =>
          article.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _sortArticles(String option) {
    setState(() {
      sortOption = option;
      if (sortOption == 'Sort by Title') {
        displayedArticles.sort((a, b) => a.title.compareTo(b.title));
      } else if (sortOption == 'Sort by Date') {
        displayedArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      }
    });
  }

  void _toggleTheme() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (isDarkMode) {
      MyApp.of(context)?.setLightMode();
    } else {
      MyApp.of(context)?.setDarkMode();
    }
  }

  void _refreshArticles() {
    setState(() {
      articles = NewsService().fetchArticles();
    });
  }

  void _toggleSavedArticles() {
    setState(() {
      showSaved = !showSaved;
      displayedArticles = showSaved ? savedArticles : allArticles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.blue,
            child: Center(
              child: Text(
                'News App',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: articles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No articles available.'));
                }

                allArticles = snapshot.data!;
                displayedArticles = query.isEmpty
                    ? (showSaved ? savedArticles : allArticles)
                    : allArticles
                    .where((article) => article.title
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                    .toList();

                return ListView.builder(
                  itemCount: displayedArticles.length,
                  itemBuilder: (context, index) {
                    return ArticleTile(
                      article: displayedArticles[index],
                      isSaved: savedArticles.contains(displayedArticles[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(
                              article: displayedArticles[index],
                            ),
                          ),
                        );
                      },
                      onSave: () {
                        setState(() {
                          if (savedArticles.contains(displayedArticles[index])) {
                            savedArticles.remove(displayedArticles[index]);
                          } else {
                            savedArticles.add(displayedArticles[index]);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.blueAccent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.category),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorySelectionScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ArticleSearchDelegate(
                      articles: allArticles,
                      onSearch: _searchArticles,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.brightness_6),
                onPressed: _toggleTheme,
              ),
              PopupMenuButton<String>(
                onSelected: _sortArticles,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'Sort by Title',
                      child: Text('Sort by Title'),
                    ),
                    PopupMenuItem(
                      value: 'Sort by Date',
                      child: Text('Sort by Date'),
                    ),
                  ];
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _refreshArticles,
              ),
              IconButton(
                icon: Icon(showSaved ? Icons.list_alt : Icons.favorite_border),
                onPressed: _toggleSavedArticles,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
