/// A model representing a news article with fields for the title, description,
/// image URL, article URL, and the publication date.
class Article {
  final String title; // Title of the article
  final String description; // Short description or summary of the article
  final String urlToImage; // URL to the article's image
  final String url; // URL to the full article
  final DateTime publishedAt; // Date and time the article was published

  /// Constructor to initialize an `Article` instance.
  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    required this.publishedAt,
  });

  /// Factory method to create an `Article` instance from JSON data.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title available', // Fallback if title is missing
      description: json['description'] ?? 'No description available', // Fallback if description is missing
      urlToImage: json['urlToImage'] ?? '', // Empty string if URL to image is missing
      url: json['url'] ?? '', // Empty string if article URL is missing
      publishedAt: _parsePublishedAt(json['publishedAt']), // Parse publication date
    );
  }

  /// Helper method to safely parse the `publishedAt` field from JSON.
  static DateTime _parsePublishedAt(dynamic dateString) {
    if (dateString == null || dateString is! String || dateString.isEmpty) {
      // Fallback date for invalid or missing date strings
      return DateTime.now();
    }
    // Try parsing the date string; fallback to now if parsing fails
    return DateTime.tryParse(dateString) ?? DateTime.now();
  }
}
