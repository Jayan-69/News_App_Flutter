import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (url.isNotEmpty) {
      final uri = Uri.parse(url); // Use Uri to parse the URL
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      print('Invalid URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Article Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(article.urlToImage, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(
              article.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              article.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL(article.url),
              child: Text('Read Full Article'),
            ),
          ],
        ),
      ),
    );
  }
}
