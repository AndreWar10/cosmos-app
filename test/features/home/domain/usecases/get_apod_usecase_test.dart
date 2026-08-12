import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/home/domain/entities/apod.dart';
import 'package:cosmos_app/features/home/domain/repositories/home_repository.dart';
import 'package:cosmos_app/features/home/domain/usecases/get_apod_usecase.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late GetApodUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetApodUseCase(mockRepository);
  });

  final tApod = Apod(
    date: '2026-08-12',
    title: 'Test APOD',
    explanation: 'Explanation',
    url: 'https://example.com/image.jpg',
    mediaType: 'image',
  );

  group('GetApodUseCase', () {
    test('should delegate to repository', () async {
      when(() => mockRepository.getApod()).thenAnswer((_) async => tApod);

      final result = await useCase();

      expect(result.title, 'Test APOD');
      verify(() => mockRepository.getApod()).called(1);
    });

    test('should throw when repository fails', () async {
      when(() => mockRepository.getApod())
          .thenThrow(Exception('Network error'));

      expect(() => useCase(), throwsA(isA<Exception>()));
    });
  });
}
