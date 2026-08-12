import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../launches/domain/entities/launch.dart';
import '../../../launches/domain/usecases/get_launches_usecase.dart';
import '../../../news/domain/entities/article.dart';
import '../../../news/domain/usecases/get_news_usecase.dart';
import '../../domain/entities/apod.dart';
import '../../domain/usecases/get_apod_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._getApodUseCase,
    this._getNewsUseCase,
    this._getLaunchesUseCase,
  ) : super(HomeInitial());

  final GetApodUseCase _getApodUseCase;
  final GetNewsUseCase _getNewsUseCase;
  final GetLaunchesUseCase _getLaunchesUseCase;

  Future<void> load() async {
    emit(HomeLoading());
    try {
      Apod? apod;
      List<Article> news = [];
      List<Launch> launches = [];

      try {
        apod = await _getApodUseCase();
      } catch (_) {}

      try {
        final result = await _getNewsUseCase(limit: 6);
        news = result.articles;
      } catch (_) {}

      try {
        final result = await _getLaunchesUseCase(limit: 6, upcoming: true);
        launches = result.launches;
      } catch (_) {}

      emit(HomeLoaded(
        apod: apod,
        latestNews: news,
        latestLaunches: launches,
      ));
    } catch (_) {
      emit(HomeError('Failed to load home'));
    }
  }
}
