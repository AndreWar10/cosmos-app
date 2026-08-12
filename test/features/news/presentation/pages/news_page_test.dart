import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cosmos_app/features/news/domain/entities/article.dart';
import 'package:cosmos_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:cosmos_app/features/news/presentation/bloc/news_event.dart';
import 'package:cosmos_app/features/news/presentation/bloc/news_state.dart';
import 'package:cosmos_app/features/news/presentation/widgets/news_article_card.dart';
import 'package:cosmos_app/features/news/presentation/widgets/news_error_widget.dart';
import 'package:cosmos_app/features/news/presentation/widgets/news_loading_indicator.dart';
import 'package:cosmos_app/features/news/presentation/widgets/news_search_bar.dart';

import '../../../../helpers/pump_app.dart';

class MockNewsBloc extends MockBloc<NewsEvent, NewsState> implements NewsBloc {}

void main() {
  late MockNewsBloc mockBloc;

  setUp(() => mockBloc = MockNewsBloc());

  final tArticles = [
    Article(
      id: 1,
      title: 'Test Article',
      summary: 'Summary',
      url: 'https://example.com',
      imageUrl: 'https://example.com/img.jpg',
      newsSite: 'SpaceNews',
      publishedAt: DateTime(2026, 8, 12),
      featured: false,
    ),
  ];

  Widget buildPage() {
    return BlocProvider<NewsBloc>.value(
      value: mockBloc,
      child: Scaffold(
        body: Column(
          children: [
            NewsSearchBar(onChanged: (_) {}),
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  return switch (state) {
                    NewsInitial() => const SizedBox.shrink(),
                    NewsLoading() => const NewsLoadingIndicator(),
                    NewsError(:final message) => NewsErrorWidget(
                        message: message,
                        onRetry: () {},
                      ),
                    NewsLoaded(:final articles) => ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (_, i) =>
                            NewsArticleCard(article: articles[i]),
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  group('NewsPage', () {
    testWidgets('should show loading indicator when state is NewsLoading',
        (tester) async {
      when(() => mockBloc.state).thenReturn(NewsLoading());

      await tester.pumpApp(buildPage());

      expect(find.byType(NewsLoadingIndicator), findsOneWidget);
    });

    testWidgets('should show articles when state is NewsLoaded',
        (tester) async {
      when(() => mockBloc.state).thenReturn(NewsLoaded(
        articles: tArticles,
        count: 1,
        hasReachedMax: true,
      ));

      await tester.pumpApp(buildPage());

      expect(find.byType(NewsArticleCard), findsOneWidget);
      expect(find.text('Test Article'), findsOneWidget);
    });

    testWidgets('should show error widget when state is NewsError',
        (tester) async {
      when(() => mockBloc.state).thenReturn(NewsError('Network error'));

      await tester.pumpApp(buildPage());

      expect(find.byType(NewsErrorWidget), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('should render search bar', (tester) async {
      when(() => mockBloc.state).thenReturn(NewsInitial());

      await tester.pumpApp(buildPage());

      expect(find.byType(NewsSearchBar), findsOneWidget);
    });
  });
}
