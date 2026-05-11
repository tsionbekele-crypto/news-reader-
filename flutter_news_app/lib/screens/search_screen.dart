import 'package:flutter/material.dart';
import '../services/news_api_service.dart';
import '../models/article.dart';
import 'article_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final NewsApiService _apiService = NewsApiService();
  final TextEditingController _searchController = TextEditingController();
  Future<List<Article>>? _searchFuture;

  void _handleSearch() {
    if (_searchController.text.trim().isNotEmpty) {
      setState(() {
        _searchFuture = _apiService.searchArticles(_searchController.text.trim());
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter keyword (e.g., Bitcoin)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _handleSearch,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _handleSearch(),
            ),
          ),
          Expanded(
            child: _searchFuture == null
                ? const Center(child: Text('Search for articles across all sources'))
                : FutureBuilder<List<Article>>(
                    future: _searchFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 60),
                              const SizedBox(height: 16),
                              Text(
                                snapshot.error.toString().replaceAll('ApiException: ', ''),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _handleSearch,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No articles found matching your query.'));
                      }

                      final articles = snapshot.data!;
                      return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                article.urlToImage,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                            subtitle: Text(article.sourceName),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailScreen(article: article),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
