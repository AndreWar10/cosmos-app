import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/core/network/app_network.dart';
import 'package:cosmos_app/features/home/data/datasources/home_remote_datasource.dart';

class MockAppNetwork extends Mock implements AppNetwork {}

void main() {
  late MockAppNetwork mockNetwork;
  late HomeRemoteDataSourceImpl dataSource;

  setUp(() {
    mockNetwork = MockAppNetwork();
    dataSource = HomeRemoteDataSourceImpl(mockNetwork);
  });

  final tApodResponse = {
    'locale': 'en',
    'data': {
      'date': '2026-08-12',
      'title': 'Test APOD',
      'explanation': 'An explanation',
      'url': 'https://example.com/image.jpg',
      'hdUrl': 'https://example.com/image_hd.jpg',
      'mediaType': 'image',
      'copyright': 'NASA',
    },
  };

  group('getApod', () {
    test('should call GET /api/apod', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tApodResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      await dataSource.getApod();

      verify(() => mockNetwork.get<Map<String, dynamic>>('/api/apod'))
          .called(1);
    });

    test('should return ApodModel on success', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tApodResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await dataSource.getApod();

      expect(result.title, 'Test APOD');
      expect(result.date, '2026-08-12');
      expect(result.mediaType, 'image');
    });

    test('should throw when network fails', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(requestOptions: RequestOptions()));

      expect(() => dataSource.getApod(), throwsA(isA<DioException>()));
    });
  });
}
