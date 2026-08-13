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

  Response<Map<String, dynamic>> successResponse() => Response(
        data: tApodResponse,
        statusCode: 200,
        requestOptions: RequestOptions(),
      );

  group('getApod', () {
    test('should call GET /api/apod without params', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => successResponse());

      await dataSource.getApod();

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/apod',
            queryParameters: null,
          )).called(1);
    });

    test('should return ApodModel on success', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => successResponse());

      final result = await dataSource.getApod();

      expect(result.title, 'Test APOD');
      expect(result.date, '2026-08-12');
      expect(result.mediaType, 'image');
    });

    test('should pass date query param when provided', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => successResponse());

      await dataSource.getApod(date: '2026-08-11');

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/apod',
            queryParameters: {'date': '2026-08-11'},
          )).called(1);
    });

    test('should fallback to yesterday when today fails', () async {
      var callCount = 0;
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          throw DioException(requestOptions: RequestOptions());
        }
        return successResponse();
      });

      final result = await dataSource.getApod();

      expect(result.title, 'Test APOD');
      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/apod',
            queryParameters: any(named: 'queryParameters'),
          )).called(2);
    });

    test('should throw when both today and fallback fail', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(requestOptions: RequestOptions()));

      expect(() => dataSource.getApod(), throwsA(isA<DioException>()));
    });

    test('should rethrow when explicit date fails (no fallback)', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(requestOptions: RequestOptions()));

      expect(
        () => dataSource.getApod(date: '2026-08-11'),
        throwsA(isA<DioException>()),
      );

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/apod',
            queryParameters: {'date': '2026-08-11'},
          )).called(1);
    });
  });
}
