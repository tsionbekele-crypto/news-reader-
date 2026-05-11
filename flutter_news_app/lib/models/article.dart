import 'package:flutter/foundation.dart';

@immutable
class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String sourceName;
  final String author;
  final DateTime publishedAt;

  const Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.sourceName,
    required this.author,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    // Handling nested fields and nulls as per assignment requirements
    final source = json['source'] as Map<String, dynamic>?;
    
    return Article(
      title: (json['title'] ?? 'No Title') as String,
      description: (json['description'] ?? 'No Description') as String,
      url: (json['url'] ?? '') as String,
      urlToImage: (json['urlToImage'] ?? 'https://via.placeholder.com/150') as String,
      sourceName: (source?['name'] ?? 'Unknown Source') as String,
      author: (json['author'] ?? 'Unknown Author') as String,
      publishedAt: DateTime.tryParse(json['publishedAt'] as String) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'source': {'name': sourceName},
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  Article copyWith({
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? sourceName,
    String? author,
    DateTime? publishedAt,
  }) {
    return Article(
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      sourceName: sourceName ?? this.sourceName,
      author: author ?? this.author,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
