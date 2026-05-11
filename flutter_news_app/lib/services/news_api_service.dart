import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/article.dart';
import 'api_exception.dart';

class NewsApiService {
  final String _baseUrl = 'newsapi.org';
  final Duration _timeout = const Duration(seconds: 10);
  
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  String get _apiKey {
    final key = dotenv.env['NEWSAPI_KEY'] ?? dotenv.env['API_KEY'] ?? '';
    if (key.isEmpty) {
      throw ApiException(
        message: 'Missing NEWSAPI_KEY. Add NEWSAPI_KEY to your .env file.',
      );
    }
    return key;
  }

  Future<List<Article>> fetchTopHeadlines(String countryCode) async {
    final queryParams = {
      'country': countryCode,
      'apiKey': _apiKey,
    };

    final uri = _buildUri('/v2/top-headlines', queryParams);
    
    try {
      final response = await http.get(uri, headers: _headers).timeout(_timeout);
      return _processResponse(response);
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on TimeoutException {
      throw ApiException(message: 'Request timed out. Please try again.');
    } on FormatException {
      throw ApiException(message: 'Unexpected data format received');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<List<Article>> searchArticles(String query) async {
    final queryParams = {
      'q': query,
      'apiKey': _apiKey,
      'pageSize': '20',
    };

    final uri = _buildUri('/v2/everything', queryParams);
    
    try {
      final response = await http.get(uri, headers: _headers).timeout(_timeout);
      return _processResponse(response);
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on TimeoutException {
      throw ApiException(message: 'Request timed out. Please try again.');
    } on FormatException {
      throw ApiException(message: 'Unexpected data format received');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Uri _buildUri(String path, Map<String, String> queryParams) {
    final uri = Uri.https(_baseUrl, path, queryParams);
    if (kIsWeb) {
      final encodedUrl = Uri.encodeComponent(uri.toString());
      return Uri.parse('https://api.codetabs.com/v1/proxy?quest=$encodedUrl');
    }
    return uri;
  }

  List<Article> _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articlesJson = data['articles'] ?? [];
      
      return articlesJson
          .where((json) => json['title'] != '[Removed]') // Filtering deleted articles
          .map((json) => Article.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw ApiException(
        statusCode: response.statusCode,
        message: errorData['message'] ?? 'Failed to load news',
      );
    }
  }
}
