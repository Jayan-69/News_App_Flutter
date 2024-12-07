import 'package:flutter/material.dart';
import 'article.dart';

class ArticleTile extends StatefulWidget {
  final Article article;
  final VoidCallback onSave;
  final VoidCallback onTap;
  final bool isSaved;

  const ArticleTile({
    Key? key,
    required this.article,
    required this.onSave,
    required this.onTap,
    required this.isSaved,
  }) : super(key: key);

  @override
  _ArticleTileState createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  bool saved = false;

  @override
  void initState() {
    super.initState();
    saved = widget.isSaved; // Track whether the article is saved
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: widget.article.urlToImage != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.article.urlToImage!,
            width: 80, // Set a fixed width for the image
            height: 80, // Set a fixed height for the image
            fit: BoxFit.cover, // To make the image fit within the bounds
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child; // Image has loaded
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
            errorBuilder: (context, error, stackTrace) {
              // Fallback image when the image fails to load
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey[300], // Placeholder color
                child: Icon(Icons.error, color: Colors.red),
              );
            },
          ),
        )
            : null, // If no image URL, leave the leading widget as null
        title: Text(
          widget.article.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.article.description,
          maxLines: 2, // Restrict the subtitle to two lines to avoid overlap
          overflow: TextOverflow.ellipsis, // Add ellipsis if the description is too long
        ),
        onTap: widget.onTap,
        trailing: IconButton(
          icon: Icon(
            saved ? Icons.bookmark_added : Icons.bookmark,
            color: saved ? Colors.green : null,
          ),
          onPressed: () {
            setState(() {
              saved = !saved; // Toggle saved state
            });
            widget.onSave();
            // Show a confirmation snack bar message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(saved
                    ? 'News saved successfully'
                    : 'News removed from saved list'),
              ),
            );
          },
        ),
      ),
    );
  }
}
