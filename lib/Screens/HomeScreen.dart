import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newproject/Screens/DetailedScreen.dart';
import 'package:newproject/Services/APIService.dart';
import '../Model/articles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = APIService().fetchArticles() as Future<List<Article>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News App',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load articles",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No articles found",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedScreen(article: article),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image container
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade100,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                article.urlToImage?? 'https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-600nw-1037719192.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade100,
                                    child: Icon(
                                      Icons.article,
                                      size: 40,
                                      color: Colors.grey.shade400,
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if(loadingProgress==null) return child;
                                  return Container(
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ));
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Text content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  article.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  article.descp ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: Colors.grey.shade700,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('MMM d, y').format(article.publishedAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.source_outlined,
                                      size: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        article.source.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}