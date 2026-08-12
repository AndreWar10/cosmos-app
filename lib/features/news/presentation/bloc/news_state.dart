import '../../domain/entities/article.dart';

sealed class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  NewsLoaded({
    required this.articles,
    required this.count,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });

  final List<Article> articles;
  final int count;
  final bool hasReachedMax;
  final bool isLoadingMore;

  NewsLoaded copyWith({
    List<Article>? articles,
    int? count,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return NewsLoaded(
      articles: articles ?? this.articles,
      count: count ?? this.count,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class NewsError extends NewsState {
  NewsError(this.message);
  final String message;
}
