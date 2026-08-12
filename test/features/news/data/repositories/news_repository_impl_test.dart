import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/news/data/datasources/news_remote_datasource.dart';
import 'package:cosmos_app/features/news/data/models/article_model.dart';
import 'package:cosmos_app/features/news/data/models/news_response_model.dart';
import 'package:cosmos_app/features/news/data/repositories/news_repository_impl.dart';

class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

void main() {
  late MockNewsRemoteDataSource mockDataSource;
  late NewsRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockNewsRemoteDataSource();
    repository = NewsRepositoryImpl(mockDataSource);
  });

  final tArticles = [
    ArticleModel(
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

  final tResponse = NewsResponseModel(count: 50, articles: tArticles);

  group('NewsRepositoryImpl', () {
    test('should delegate to datasource with correct params', () async {
      when(() => mockDataSource.getNews(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            search: any(named: 'search'),
          )).thenAnswer((_) async => tResponse);

      await repository.getNews(limit: 10, offset: 5, search: 'SpaceX');

      verify(() => mockDataSource.getNews(
            limit: 10,
            offset: 5,
            search: 'SpaceX',
          )).called(1);
    });

    test('should return articles and count', () async {
      when(() => mockDataSource.getNews(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            search: any(named: 'search'),
          )).thenAnswer((_) async => tResponse);

      final result = await repository.getNews();

      expect(result.articles.length, 1);
      expect(result.count, 50);
      expect(result.articles.first.title, 'Test');
    });

    test('should throw when datasource fails', () async {
      when(() => mockDataSource.getNews(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            search: any(named: 'search'),
          )).thenThrow(Exception('Network error'));

      expect(() => repository.getNews(), throwsA(isA<Exception>()));
    });
  });
}
