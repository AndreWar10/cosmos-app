import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/core/network/app_network.dart';
import 'package:cosmos_app/features/news/data/datasources/news_remote_datasource.dart';

class MockAppNetwork extends Mock implements AppNetwork {}

void main() {
  late MockAppNetwork mockNetwork;
  late NewsRemoteDataSourceImpl dataSource;

  setUp(() {
    mockNetwork = MockAppNetwork();
    dataSource = NewsRemoteDataSourceImpl(mockNetwork);
  });

  final tResponseData = {
    'locale': 'pt',
    'data': {
      'count': 1,
      'next': null,
      'previous': null,
      'results': [
        {
          'id': 1,
          'title': 'Test',
          'summary': 'Summary',
          'url': 'https://example.com',
          'imageUrl': 'https://example.com/img.jpg',
          'newsSite': 'SpaceNews',
          'publishedAt': '2026-08-12T14:00:00Z',
          'featured': false,
          'authors': [],
        },
      ],
    },
  };

  group('NewsRemoteDataSourceImpl', () {
    test('should call GET /api/pt/news with correct query params', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      await dataSource.getNews(limit: 10, offset: 5);

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/pt/news',
            queryParameters: {'limit': 10, 'offset': 5},
          )).called(1);
    });

    test('should include search param when provided', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      await dataSource.getNews(search: 'SpaceX');

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/pt/news',
            queryParameters: {'limit': 20, 'offset': 0, 'search': 'SpaceX'},
          )).called(1);
    });

    test('should return NewsResponseModel on success', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await dataSource.getNews();

      expect(result.count, 1);
      expect(result.articles.length, 1);
      expect(result.articles.first.title, 'Test');
    });

    test('should throw when network fails', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(requestOptions: RequestOptions()));

      expect(() => dataSource.getNews(), throwsA(isA<DioException>()));
    });
  });
}
