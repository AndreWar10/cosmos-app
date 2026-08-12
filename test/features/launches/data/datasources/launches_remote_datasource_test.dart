import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/core/network/app_network.dart';
import 'package:cosmos_app/features/launches/data/datasources/launches_remote_datasource.dart';

class MockAppNetwork extends Mock implements AppNetwork {}

void main() {
  late MockAppNetwork mockNetwork;
  late LaunchesRemoteDataSourceImpl dataSource;

  setUp(() {
    mockNetwork = MockAppNetwork();
    dataSource = LaunchesRemoteDataSourceImpl(mockNetwork);
  });

  final tLaunchJson = {
    'id': '123',
    'name': 'Test Launch',
    'flightNumber': 1,
    'dateUtc': '2026-08-15T21:52:00Z',
    'success': null,
    'upcoming': true,
    'details': null,
    'rocket': 'Falcon 9',
    'launchpad': 'SLC-40',
    'links': <String, dynamic>{},
  };

  final tPaginatedResponse = {
    'locale': 'en',
    'data': {
      'count': 100,
      'limit': 20,
      'offset': 0,
      'results': [tLaunchJson],
    },
  };

  final tSingleResponse = {
    'locale': 'en',
    'data': tLaunchJson,
  };

  group('getLaunches', () {
    test('should call GET /api/launches with limit and offset', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tPaginatedResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      await dataSource.getLaunches(limit: 10, offset: 20);

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/launches',
            queryParameters: {'limit': 10, 'offset': 20},
          )).called(1);
    });

    test('should include upcoming param when provided', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tPaginatedResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      await dataSource.getLaunches(upcoming: true);

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/launches',
            queryParameters: {'limit': 20, 'offset': 0, 'upcoming': true},
          )).called(1);
    });

    test('should include status param when provided', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tPaginatedResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      await dataSource.getLaunches(upcoming: false, status: 'success');

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/launches',
            queryParameters: {
              'limit': 20,
              'offset': 0,
              'upcoming': false,
              'status': 'success',
            },
          )).called(1);
    });

    test('should return launches and count from paginated response', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tPaginatedResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await dataSource.getLaunches();

      expect(result.launches.length, 1);
      expect(result.count, 100);
      expect(result.launches.first.name, 'Test Launch');
    });

    test('should throw when network fails', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(requestOptions: RequestOptions()));

      expect(() => dataSource.getLaunches(), throwsA(isA<DioException>()));
    });
  });

  group('getNextLaunch', () {
    test('should call GET /api/launches with mode=next', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tSingleResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      await dataSource.getNextLaunch();

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/launches',
            queryParameters: {'mode': 'next'},
          )).called(1);
    });

    test('should return single LaunchModel', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tSingleResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await dataSource.getNextLaunch();

      expect(result.name, 'Test Launch');
      expect(result.upcoming, isTrue);
    });
  });

  group('getLatestLaunch', () {
    test('should call GET /api/launches with mode=latest', () async {
      when(() => mockNetwork.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tSingleResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      await dataSource.getLatestLaunch();

      verify(() => mockNetwork.get<Map<String, dynamic>>(
            '/api/launches',
            queryParameters: {'mode': 'latest'},
          )).called(1);
    });
  });
}
