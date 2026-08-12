import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/news/data/models/article_model.dart';

void main() {
  group('ArticleModel', () {
    final tJson = {
      'id': 123,
      'title': 'SpaceX Launch',
      'summary': 'A summary',
      'url': 'https://example.com/article',
      'imageUrl': 'https://example.com/image.jpg',
      'newsSite': 'SpaceNews',
      'publishedAt': '2026-08-12T14:00:00Z',
      'updatedAt': '2026-08-12T14:00:46Z',
      'featured': true,
      'authors': [
        {'name': 'John Doe'}
      ],
    };

    test('should create ArticleModel from JSON', () {
      final model = ArticleModel.fromJson(tJson);

      expect(model.id, 123);
      expect(model.title, 'SpaceX Launch');
      expect(model.summary, 'A summary');
      expect(model.url, 'https://example.com/article');
      expect(model.imageUrl, 'https://example.com/image.jpg');
      expect(model.newsSite, 'SpaceNews');
      expect(model.publishedAt, DateTime.utc(2026, 8, 12, 14));
      expect(model.featured, isTrue);
    });

    test('should handle null optional fields with defaults', () {
      final minimalJson = {
        'id': 1,
        'publishedAt': '2026-01-01T00:00:00Z',
      };

      final model = ArticleModel.fromJson(minimalJson);

      expect(model.id, 1);
      expect(model.title, '');
      expect(model.summary, '');
      expect(model.imageUrl, '');
      expect(model.newsSite, '');
      expect(model.featured, isFalse);
    });
  });
}
