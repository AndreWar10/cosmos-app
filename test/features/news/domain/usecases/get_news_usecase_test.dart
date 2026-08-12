import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/news/domain/entities/article.dart';
import 'package:cosmos_app/features/news/domain/repositories/news_repository.dart';
import 'package:cosmos_app/features/news/domain/usecases/get_news_usecase.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository mockRepository;
  late GetNewsUseCase useCase;

  setUp(() {
    mockRepository = MockNewsRepository();
    useCase = GetNewsUseCase(mockRepository);
  });

  final tArticles = [
    Article(
      id: 1,
      title: 'Test',
      summary: 'Summary',
      url: 'https://example.com',
      imageUrl: 'https://example.com/img.jpg',
      newsSite: 'SpaceNews',
      publishedAt: DateTime(2026, 8, 12),
      featured: false,
    ),
  ];

  group('GetNewsUseCase', () {
    test('should delegate to repository with correct params', () async {
      when(() => mockRepository.getNews(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            search: any(named: 'search'),
          )).thenAnswer(
        (_) async => (articles: tArticles, count: 50),
      );

      final result = await useCase(limit: 10, offset: 5, search: 'SpaceX');

      expect(result.articles, tArticles);
      expect(result.count, 50);
      verify(() => mockRepository.getNews(
            limit: 10,
            offset: 5,
            search: 'SpaceX',
          )).called(1);
    });

    test('should use default params when not provided', () async {
      when(() => mockRepository.getNews(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            search: any(named: 'search'),
          )).thenAnswer(
        (_) async => (articles: tArticles, count: 1),
      );

      await useCase();

      verify(() => mockRepository.getNews(
            limit: 20,
            offset: 0,
            search: null,
          )).called(1);
    });
  });
}
