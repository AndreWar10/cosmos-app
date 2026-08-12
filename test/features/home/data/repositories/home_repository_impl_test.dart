import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:cosmos_app/features/home/data/models/apod_model.dart';
import 'package:cosmos_app/features/home/data/repositories/home_repository_impl.dart';

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  late MockHomeRemoteDataSource mockDataSource;
  late HomeRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(mockDataSource);
  });

  final tApod = ApodModel(
    date: '2026-08-12',
    title: 'Test APOD',
    explanation: 'Explanation',
    url: 'https://example.com/image.jpg',
    mediaType: 'image',
  );

  group('getApod', () {
    test('should delegate to datasource', () async {
      when(() => mockDataSource.getApod()).thenAnswer((_) async => tApod);

      final result = await repository.getApod();

      expect(result.title, 'Test APOD');
      verify(() => mockDataSource.getApod()).called(1);
    });

    test('should throw when datasource fails', () async {
      when(() => mockDataSource.getApod())
          .thenThrow(Exception('Network error'));

      expect(() => repository.getApod(), throwsA(isA<Exception>()));
    });
  });
}
