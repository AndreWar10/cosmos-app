import '../../../news/domain/entities/article.dart';
import '../../domain/entities/apod.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  HomeLoaded({
    required this.apod,
    required this.latestNews,
  });

  final Apod? apod;
  final List<Article> latestNews;
}

class HomeError extends HomeState {
  HomeError(this.message);
  final String message;
}
