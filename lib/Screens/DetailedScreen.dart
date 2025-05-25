import 'package:flutter/material.dart';
import 'package:newproject/Model/articles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class DetailedScreen extends StatelessWidget {
  final Article article;

  const DetailedScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.source.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  article.urlToImage!,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 220,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 220,
                color: Colors.grey.shade100,
                child: const Center(
                  child: Icon(Icons.article, size: 60, color: Colors.grey),
                ),
              ),

            const SizedBox(height: 24),

            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM d, y').format(article.publishedAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                if (article.author != null && article.author!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article.author!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Article Description
            if (article.descp != null && article.descp!.isNotEmpty)
              Text(
                article.descp!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Colors.grey.shade800,
                ),
              ),

            const SizedBox(height: 16),

            // Article Content
            if (article.content != null && article.content!.isNotEmpty)
              Text(
                article.content!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Colors.grey.shade800,
                ),
              ),

            const SizedBox(height: 32),

            // Read Full Article Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _launchUrl(context),
                child: const Text(
                  'Read Full Article',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context) async {
    try {
      final Uri url = Uri.parse(article.url);
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Could not launch URL';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not open link'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}