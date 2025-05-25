class Article {
  final Source source;
  final String? author;
  final String title;
  final String? descp;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.descp,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'],
      title: json['title'],
      descp: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: DateTime.parse(json['publishedAt']),
      content: json['content'],
    );
  }
}

class Source {
  final String? id;
  final String name;

  Source({required this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json){
    return Source(
      id: json['id'],
      name: json['name'],
    );
  }
}

