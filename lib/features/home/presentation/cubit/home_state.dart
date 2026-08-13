import '../../../launches/domain/entities/launch.dart';
import '../../../news/domain/entities/article.dart';
import '../../domain/entities/apod.dart';
import '../../domain/entities/observatory.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  HomeLoaded({
    required this.apod,
    required this.latestNews,
    required this.latestLaunches,
    required this.observatories,
  });

  final Apod? apod;
  final List<Article> latestNews;
  final List<Launch> latestLaunches;
  final List<Observatory> observatories;
}

class HomeError extends HomeState {
  HomeError(this.message, {this.isNoInternet = false});
  final String message;
  final bool isNoInternet;
}
