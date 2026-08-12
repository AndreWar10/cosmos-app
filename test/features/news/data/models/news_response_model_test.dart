import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/news/data/models/news_response_model.dart';

void main() {
  group('NewsResponseModel', () {
    test('should parse envelope with count and results', () {
      final json = {
        'locale': 'pt',
        'data': {
          'count': 100,
          'next': 'https://example.com?offset=20',
          'previous': null,
          'results': [
            {
              'id': 1,
              'title': 'Article 1',
              'summary': 'Summary 1',
              'url': 'https://example.com/1',
              'imageUrl': 'https://example.com/img1.jpg',
              'newsSite': 'SpaceNews',
              'publishedAt': '2026-08-12T14:00:00Z',
              'featured': false,
              'authors': [],
            },
            {
              'id': 2,
              'title': 'Article 2',
              'summary': 'Summary 2',
              'url': 'https://example.com/2',
              'imageUrl': 'https://example.com/img2.jpg',
              'newsSite': 'NASA',
              'publishedAt': '2026-08-11T10:00:00Z',
              'featured': true,
              'authors': [],
            },
          ],
        },
      };

      final model = NewsResponseModel.fromJson(json);

      expect(model.count, 100);
      expect(model.articles.length, 2);
      expect(model.articles[0].title, 'Article 1');
      expect(model.articles[1].newsSite, 'NASA');
    });

    test('should handle empty results', () {
      final json = {
        'locale': 'pt',
        'data': {
          'count': 0,
          'next': null,
          'previous': null,
          'results': [],
        },
      };

      final model = NewsResponseModel.fromJson(json);

      expect(model.count, 0);
      expect(model.articles, isEmpty);
    });
  });
}
