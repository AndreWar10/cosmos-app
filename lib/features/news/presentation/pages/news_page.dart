import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/no_internet_widget.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../widgets/news_article_card.dart';
import '../widgets/news_empty_widget.dart';
import '../widgets/news_error_widget.dart';
import '../widgets/news_loading_indicator.dart';
import '../widgets/news_search_bar.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsBloc>()..add(NewsFetched()),
      child: const _NewsView(),
    );
  }
}

class _NewsView extends StatelessWidget {
  const _NewsView();

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return BlocListener<LocaleCubit, Locale>(
      listener: (context, _) {
        context.read<NewsBloc>().add(NewsFetched());
      },
      child: Scaffold(
        appBar: AppBar(title: Text(t.newsTitle)),
        body: Column(
          children: [
            NewsSearchBar(
              onChanged: (query) {
                context.read<NewsBloc>().add(NewsSearchChanged(query));
              },
            ),
            const Expanded(child: _NewsBody()),
          ],
        ),
      ),
    );
  }
}

class _NewsBody extends StatelessWidget {
  const _NewsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        return switch (state) {
          NewsInitial() => const SizedBox.shrink(),
          NewsLoading() => const NewsLoadingIndicator(),
          NewsError(isNoInternet: true) => NoInternetWidget(
              onRetry: () => context.read<NewsBloc>().add(NewsFetched()),
            ),
          NewsError(:final message) => NewsErrorWidget(
              message: message,
              onRetry: () => context.read<NewsBloc>().add(NewsFetched()),
            ),
          NewsLoaded() => _NewsLoadedList(state: state),
        };
      },
    );
  }
}

class _NewsLoadedList extends StatefulWidget {
  const _NewsLoadedList({required this.state});

  final NewsLoaded state;

  @override
  State<_NewsLoadedList> createState() => _NewsLoadedListState();
}

class _NewsLoadedListState extends State<_NewsLoadedList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NewsBloc>().add(NewsNextPageFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll - 200;
  }

  @override
  Widget build(BuildContext context) {
    final articles = widget.state.articles;

    if (articles.isEmpty) return const NewsEmptyWidget();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      itemCount: widget.state.hasReachedMax
          ? articles.length
          : articles.length + 1,
      itemBuilder: (context, index) {
        if (index >= articles.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return NewsArticleCard(
          article: articles[index],
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.newsDetail,
            arguments: articles[index],
          ),
        );
      },
    );
  }
}
