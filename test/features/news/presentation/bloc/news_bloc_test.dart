import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/news/domain/entities/article.dart';
import 'package:cosmos_app/features/news/domain/usecases/get_news_usecase.dart';
import 'package:cosmos_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:cosmos_app/features/news/presentation/bloc/news_event.dart';
import 'package:cosmos_app/features/news/presentation/bloc/news_state.dart';

class MockGetNewsUseCase extends Mock implements GetNewsUseCase {}

void main() {
  late MockGetNewsUseCase mockUseCase;

  setUp(() => mockUseCase = MockGetNewsUseCase());

  final tArticles = [
    Article(
      id: 1,
      title: 'Test Article',
      summary: 'Summary',
      url: 'https://example.com',
      imageUrl: 'https://example.com/img.jpg',
      newsSite: 'SpaceNews',
      publishedAt: DateTime(2026, 8, 12),
      featured: false,
    ),
  ];

  group('NewsBloc', () {
    test('initial state should be NewsInitial', () {
      final bloc = NewsBloc(mockUseCase);
      expect(bloc.state, isA<NewsInitial>());
      bloc.close();
    });

    blocTest<NewsBloc, NewsState>(
      'should emit [Loading, Loaded] when NewsFetched succeeds',
      build: () {
        when(() => mockUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
            )).thenAnswer(
          (_) async => (articles: tArticles, count: 1),
        );
        return NewsBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(NewsFetched()),
      expect: () => [
        isA<NewsLoading>(),
        isA<NewsLoaded>()
            .having((s) => s.articles.length, 'articles length', 1)
            .having((s) => s.count, 'count', 1)
            .having((s) => s.hasReachedMax, 'hasReachedMax', true),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'should emit [Loading, Error] when NewsFetched fails',
      build: () {
        when(() => mockUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
            )).thenThrow(Exception('error'));
        return NewsBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(NewsFetched()),
      expect: () => [
        isA<NewsLoading>(),
        isA<NewsError>(),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'should append articles on NewsNextPageFetched',
      build: () {
        when(() => mockUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
            )).thenAnswer(
          (_) async => (articles: tArticles, count: 50),
        );
        return NewsBloc(mockUseCase);
      },
      seed: () => NewsLoaded(
        articles: tArticles,
        count: 50,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(NewsNextPageFetched()),
      expect: () => [
        isA<NewsLoaded>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
        isA<NewsLoaded>()
            .having((s) => s.articles.length, 'articles length', 2),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'should not fetch when hasReachedMax is true',
      build: () => NewsBloc(mockUseCase),
      seed: () => NewsLoaded(
        articles: tArticles,
        count: 1,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(NewsNextPageFetched()),
      expect: () => [],
    );

    blocTest<NewsBloc, NewsState>(
      'should reset and fetch on NewsSearchChanged',
      build: () {
        when(() => mockUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
            )).thenAnswer(
          (_) async => (articles: tArticles, count: 1),
        );
        return NewsBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(NewsSearchChanged('SpaceX')),
      expect: () => [
        isA<NewsLoading>(),
        isA<NewsLoaded>(),
      ],
      verify: (_) {
        verify(() => mockUseCase(
              limit: 20,
              offset: 0,
              search: 'SpaceX',
            )).called(1);
      },
    );
  });
}
