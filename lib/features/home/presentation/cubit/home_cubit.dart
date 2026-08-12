import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../news/domain/entities/article.dart';
import '../../../news/domain/usecases/get_news_usecase.dart';
import '../../domain/entities/apod.dart';
import '../../domain/usecases/get_apod_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getApodUseCase, this._getNewsUseCase)
      : super(HomeInitial());

  final GetApodUseCase _getApodUseCase;
  final GetNewsUseCase _getNewsUseCase;

  Future<void> load() async {
    emit(HomeLoading());
    try {
      Apod? apod;
      List<Article> news = [];

      try {
        apod = await _getApodUseCase();
      } catch (_) {}

      try {
        final result = await _getNewsUseCase(limit: 6);
        news = result.articles;
      } catch (_) {}

      emit(HomeLoaded(apod: apod, latestNews: news));
    } catch (_) {
      emit(HomeError('Failed to load home'));
    }
  }
}
