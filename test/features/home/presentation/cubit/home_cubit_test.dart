import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/home/domain/entities/apod.dart';
import 'package:cosmos_app/features/home/domain/usecases/get_apod_usecase.dart';
import 'package:cosmos_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:cosmos_app/features/home/presentation/cubit/home_state.dart';
import 'package:cosmos_app/features/launches/domain/entities/launch.dart';
import 'package:cosmos_app/features/launches/domain/usecases/get_launches_usecase.dart';
import 'package:cosmos_app/features/news/domain/entities/article.dart';
import 'package:cosmos_app/features/news/domain/usecases/get_news_usecase.dart';

class MockGetApodUseCase extends Mock implements GetApodUseCase {}

class MockGetNewsUseCase extends Mock implements GetNewsUseCase {}

class MockGetLaunchesUseCase extends Mock implements GetLaunchesUseCase {}

void main() {
  late MockGetApodUseCase mockApodUseCase;
  late MockGetNewsUseCase mockNewsUseCase;
  late MockGetLaunchesUseCase mockLaunchesUseCase;

  setUp(() {
    mockApodUseCase = MockGetApodUseCase();
    mockNewsUseCase = MockGetNewsUseCase();
    mockLaunchesUseCase = MockGetLaunchesUseCase();
  });

  final tApod = Apod(
    date: '2026-08-12',
    title: 'Test APOD',
    explanation: 'Explanation',
    url: 'https://example.com/image.jpg',
    mediaType: 'image',
  );

  final tArticles = [
    Article(
      id: 1,
      title: 'News',
      summary: 'Summary',
      url: 'https://example.com',
      imageUrl: 'https://example.com/img.jpg',
      newsSite: 'SpaceNews',
      publishedAt: DateTime(2026, 8, 12),
      featured: false,
    ),
  ];

  void stubSuccessAll() {
    when(() => mockApodUseCase()).thenAnswer((_) async => tApod);
    when(() => mockNewsUseCase(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          search: any(named: 'search'),
        )).thenAnswer((_) async => (articles: tArticles, count: 1));
    when(() => mockLaunchesUseCase(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          upcoming: any(named: 'upcoming'),
          status: any(named: 'status'),
        )).thenAnswer((_) async => (launches: <Launch>[], count: 0));
  }

  HomeCubit buildCubit() =>
      HomeCubit(mockApodUseCase, mockNewsUseCase, mockLaunchesUseCase);

  group('HomeCubit', () {
    test('initial state should be HomeInitial', () {
      stubSuccessAll();
      final cubit = buildCubit();
      expect(cubit.state, isA<HomeInitial>());
      cubit.close();
    });

    blocTest<HomeCubit, HomeState>(
      'should emit [Loading, Loaded] when load succeeds',
      build: () {
        stubSuccessAll();
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeLoaded>()
            .having((s) => s.apod?.title, 'apod title', 'Test APOD')
            .having((s) => s.latestNews.length, 'news length', 1)
            .having((s) => s.latestLaunches, 'launches', isEmpty),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should still load when APOD fails but news succeeds',
      build: () {
        when(() => mockApodUseCase()).thenThrow(Exception('APOD error'));
        when(() => mockNewsUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
            )).thenAnswer((_) async => (articles: tArticles, count: 1));
        when(() => mockLaunchesUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              upcoming: any(named: 'upcoming'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => (launches: <Launch>[], count: 0));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeLoaded>()
            .having((s) => s.apod, 'apod', isNull)
            .having((s) => s.latestNews.length, 'news length', 1),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should still load when news fails but APOD succeeds',
      build: () {
        when(() => mockApodUseCase()).thenAnswer((_) async => tApod);
        when(() => mockNewsUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
            )).thenThrow(Exception('News error'));
        when(() => mockLaunchesUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              upcoming: any(named: 'upcoming'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => (launches: <Launch>[], count: 0));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeLoaded>()
            .having((s) => s.apod?.title, 'apod title', 'Test APOD')
            .having((s) => s.latestNews, 'news', isEmpty),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'should still load when launches fails',
      build: () {
        when(() => mockApodUseCase()).thenAnswer((_) async => tApod);
        when(() => mockNewsUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
            )).thenAnswer((_) async => (articles: tArticles, count: 1));
        when(() => mockLaunchesUseCase(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              upcoming: any(named: 'upcoming'),
              status: any(named: 'status'),
            )).thenThrow(Exception('Launches error'));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeLoaded>()
            .having((s) => s.apod?.title, 'apod title', 'Test APOD')
            .having((s) => s.latestNews.length, 'news length', 1)
            .having((s) => s.latestLaunches, 'launches', isEmpty),
      ],
    );
  });
}
