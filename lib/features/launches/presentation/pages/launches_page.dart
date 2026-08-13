import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/routes/app_routes.dart';
import '../bloc/launches_bloc.dart';
import '../bloc/launches_event.dart';
import '../bloc/launches_state.dart';
import '../widgets/launch_card.dart';
import '../widgets/launches_empty_widget.dart';
import '../widgets/launches_error_widget.dart';
import '../widgets/launches_loading_indicator.dart';

class LaunchesPage extends StatelessWidget {
  const LaunchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LaunchesBloc>()..add(LaunchesFetched()),
      child: const _LaunchesView(),
    );
  }
}

class _LaunchesView extends StatelessWidget {
  const _LaunchesView();

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return BlocListener<LocaleCubit, Locale>(
      listener: (context, _) {
        context.read<LaunchesBloc>().add(LaunchesFetched());
      },
      child: Scaffold(
        appBar: AppBar(title: Text(t.launchesTitle)),
        body: const _LaunchesBody(),
      ),
    );
  }
}

class _LaunchesBody extends StatelessWidget {
  const _LaunchesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaunchesBloc, LaunchesState>(
      builder: (context, state) {
        return switch (state) {
          LaunchesInitial() => const SizedBox.shrink(),
          LaunchesLoading() => const LaunchesLoadingIndicator(),
          LaunchesError(:final message) => LaunchesErrorWidget(
              message: message,
              onRetry: () =>
                  context.read<LaunchesBloc>().add(LaunchesFetched()),
            ),
          LaunchesLoaded() => _LaunchesLoadedView(state: state),
        };
      },
    );
  }
}

class _LaunchesLoadedView extends StatefulWidget {
  const _LaunchesLoadedView({required this.state});

  final LaunchesLoaded state;

  @override
  State<_LaunchesLoadedView> createState() => _LaunchesLoadedViewState();
}

class _LaunchesLoadedViewState extends State<_LaunchesLoadedView> {
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
      context.read<LaunchesBloc>().add(LaunchesNextPageFetched());
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
    final launches = widget.state.launches;

    if (launches.isEmpty) return const LaunchesEmptyWidget();

    return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final launch = launches[index];
                            return LaunchCard(
                              launch: launch,
                              onTap: () => Navigator.of(context).pushNamed(
                                AppRoutes.launchDetail,
                                arguments: launch,
                              ),
                            );
                          },
                          childCount: launches.length,
                        ),
                      ),
                    ),
                    if (!widget.state.hasReachedMax)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5),
                            ),
                          ),
                        ),
                      ),
          ],
        );
  }
}
