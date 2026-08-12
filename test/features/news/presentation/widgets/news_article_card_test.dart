import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/features/news/domain/entities/article.dart';
import 'package:cosmos_app/features/news/presentation/widgets/news_article_card.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  final tArticle = Article(
    id: 1,
    title: 'SpaceX Launches Starship',
    summary: 'SpaceX successfully launched its Starship rocket.',
    url: 'https://example.com',
    imageUrl: 'https://example.com/img.jpg',
    newsSite: 'SpaceNews',
    publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
    featured: false,
  );

  group('NewsArticleCard', () {
    testWidgets('should render article title and summary', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: NewsArticleCard(article: tArticle),
        ),
      );

      expect(find.text('SpaceX Launches Starship'), findsOneWidget);
      expect(
        find.text('SpaceX successfully launched its Starship rocket.'),
        findsOneWidget,
      );
    });

    testWidgets('should render news site name', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: NewsArticleCard(article: tArticle),
        ),
      );

      expect(find.text('SpaceNews'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpApp(
        SingleChildScrollView(
          child: NewsArticleCard(
            article: tArticle,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(NewsArticleCard));
      expect(tapped, isTrue);
    });
  });
}
