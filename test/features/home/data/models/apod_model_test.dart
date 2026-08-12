import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/home/data/models/apod_model.dart';

void main() {
  group('ApodModel', () {
    final tJson = {
      'date': '2026-08-12',
      'title': 'Perseids over a Small Planet',
      'explanation': 'Some explanation...',
      'url': 'https://apod.nasa.gov/image.jpg',
      'hdUrl': 'https://apod.nasa.gov/image_hd.jpg',
      'mediaType': 'image',
      'copyright': 'John Doe',
      'thumbnailUrl': null,
    };

    test('should create ApodModel from JSON', () {
      final model = ApodModel.fromJson(tJson);

      expect(model.date, '2026-08-12');
      expect(model.title, 'Perseids over a Small Planet');
      expect(model.explanation, 'Some explanation...');
      expect(model.url, 'https://apod.nasa.gov/image.jpg');
      expect(model.hdUrl, 'https://apod.nasa.gov/image_hd.jpg');
      expect(model.mediaType, 'image');
      expect(model.copyright, 'John Doe');
      expect(model.isImage, isTrue);
      expect(model.isVideo, isFalse);
    });

    test('should handle null optional fields', () {
      final minimalJson = <String, dynamic>{};

      final model = ApodModel.fromJson(minimalJson);

      expect(model.date, '');
      expect(model.title, '');
      expect(model.mediaType, 'image');
      expect(model.hdUrl, isNull);
      expect(model.copyright, isNull);
      expect(model.thumbnailUrl, isNull);
    });

    test('displayImageUrl should return thumbnailUrl when available', () {
      final json = {...tJson, 'thumbnailUrl': 'https://thumb.jpg'};
      final model = ApodModel.fromJson(json);

      expect(model.displayImageUrl, 'https://thumb.jpg');
    });

    test('displayImageUrl should fallback to url', () {
      final model = ApodModel.fromJson(tJson);

      expect(model.displayImageUrl, 'https://apod.nasa.gov/image.jpg');
    });

    test('should identify video mediaType', () {
      final json = {...tJson, 'mediaType': 'video'};
      final model = ApodModel.fromJson(json);

      expect(model.isVideo, isTrue);
      expect(model.isImage, isFalse);
    });
  });
}
