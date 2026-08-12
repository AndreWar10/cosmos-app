class Article {
  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.publishedAt,
    required this.featured,
  });

  final int id;
  final String title;
  final String summary;
  final String url;
  final String imageUrl;
  final String newsSite;
  final DateTime publishedAt;
  final bool featured;
}
