import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/launches/data/models/launch_model.dart';

void main() {
  group('LaunchModel', () {
    final tJson = {
      'id': '5eb87d46ffd86e000604b388',
      'name': 'Falcon 9 Block 5 | Starlink Group 10-19',
      'flightNumber': 715,
      'dateUtc': '2026-08-15T21:52:00Z',
      'success': true,
      'upcoming': false,
      'details': 'Some launch details',
      'rocket': 'Falcon 9 Block 5',
      'launchpad': 'Space Launch Complex 40',
      'links': {
        'patch': {
          'small': 'https://example.com/patch_small.png',
          'large': 'https://example.com/patch_large.png',
        },
        'webcast': 'https://youtube.com/watch?v=123',
        'wikipedia': 'https://en.wikipedia.org/wiki/Starlink',
        'article': 'https://example.com/article',
        'flickr': {
          'original': [
            'https://example.com/photo1.jpg',
            'https://example.com/photo2.jpg',
          ],
        },
      },
    };

    test('should create LaunchModel from JSON', () {
      final model = LaunchModel.fromJson(tJson);

      expect(model.id, '5eb87d46ffd86e000604b388');
      expect(model.name, 'Falcon 9 Block 5 | Starlink Group 10-19');
      expect(model.flightNumber, 715);
      expect(model.dateUtc, DateTime.utc(2026, 8, 15, 21, 52));
      expect(model.success, isTrue);
      expect(model.upcoming, isFalse);
      expect(model.details, 'Some launch details');
      expect(model.rocket, 'Falcon 9 Block 5');
      expect(model.launchpad, 'Space Launch Complex 40');
    });

    test('should parse links correctly', () {
      final model = LaunchModel.fromJson(tJson);

      expect(model.links.patchSmall, 'https://example.com/patch_small.png');
      expect(model.links.patchLarge, 'https://example.com/patch_large.png');
      expect(model.links.webcast, 'https://youtube.com/watch?v=123');
      expect(model.links.wikipedia,
          'https://en.wikipedia.org/wiki/Starlink');
      expect(model.links.article, 'https://example.com/article');
      expect(model.links.flickrOriginal.length, 2);
    });

    test('should handle null optional fields', () {
      final minimalJson = {
        'id': 'abc123',
        'dateUtc': '2026-01-01T00:00:00Z',
        'links': <String, dynamic>{},
      };

      final model = LaunchModel.fromJson(minimalJson);

      expect(model.id, 'abc123');
      expect(model.name, '');
      expect(model.flightNumber, 0);
      expect(model.success, isNull);
      expect(model.upcoming, isFalse);
      expect(model.details, isNull);
      expect(model.rocket, '');
      expect(model.launchpad, '');
      expect(model.links.patchSmall, isNull);
      expect(model.links.webcast, isNull);
      expect(model.links.flickrOriginal, isEmpty);
    });

    test('should handle missing links key entirely', () {
      final json = {
        'id': 'abc123',
        'dateUtc': '2026-01-01T00:00:00Z',
      };

      final model = LaunchModel.fromJson(json);

      expect(model.links.patchSmall, isNull);
      expect(model.links.patchLarge, isNull);
      expect(model.links.webcast, isNull);
      expect(model.links.wikipedia, isNull);
      expect(model.links.article, isNull);
      expect(model.links.flickrOriginal, isEmpty);
    });
  });

  group('LaunchLinksModel', () {
    test('should handle empty patch and flickr maps', () {
      final json = <String, dynamic>{
        'patch': <String, dynamic>{},
        'flickr': <String, dynamic>{},
      };

      final model = LaunchLinksModel.fromJson(json);

      expect(model.patchSmall, isNull);
      expect(model.patchLarge, isNull);
      expect(model.flickrOriginal, isEmpty);
    });
  });
}
