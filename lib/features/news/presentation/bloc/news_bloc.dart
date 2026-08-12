import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_news_usecase.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(this._getNewsUseCase) : super(NewsInitial()) {
    on<NewsFetched>(_onFetched);
    on<NewsNextPageFetched>(_onNextPage);
    on<NewsSearchChanged>(_onSearchChanged);
  }

  final GetNewsUseCase _getNewsUseCase;

  static const _pageSize = 8;
  String _currentSearch = '';

  Future<void> _onFetched(
    NewsFetched event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      final result = await _getNewsUseCase(
        limit: _pageSize,
        search: _currentSearch.isEmpty ? null : _currentSearch,
      );
      emit(NewsLoaded(
        articles: result.articles,
        count: result.count,
        hasReachedMax: result.articles.length >= result.count,
      ));
    } catch (_) {
      emit(NewsError('Failed to load news'));
    }
  }

  Future<void> _onNextPage(
    NewsNextPageFetched event,
    Emitter<NewsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NewsLoaded || currentState.hasReachedMax) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final result = await _getNewsUseCase(
        limit: _pageSize,
        offset: currentState.articles.length,
        search: _currentSearch.isEmpty ? null : _currentSearch,
      );

      final allArticles = [...currentState.articles, ...result.articles];

      emit(NewsLoaded(
        articles: allArticles,
        count: result.count,
        hasReachedMax: allArticles.length >= result.count,
      ));
    } catch (_) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSearchChanged(
    NewsSearchChanged event,
    Emitter<NewsState> emit,
  ) async {
    _currentSearch = event.query;
    add(NewsFetched());
  }
}
