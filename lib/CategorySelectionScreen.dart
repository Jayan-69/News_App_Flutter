import 'package:flutter/material.dart';
import 'CategoryNewsScreen.dart';

class CategorySelectionScreen extends StatelessWidget {
  final List<String> categories = [
    'political',
    'sports',
    'business',
    'technology',
    'entertainment',
    'health',
    'science',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Category'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              title: Text(
                category[0].toUpperCase() + category.substring(1), // Capitalize first letter
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryNewsScreen(category: category),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
