import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';

import 'package:cosmos_app/core/navigation/presentation/pages/root_page.dart';
import 'package:cosmos_app/core/widgets/app_bottom_navigation.dart';
import 'package:cosmos_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:cosmos_app/features/home/presentation/cubit/home_state.dart';
import 'package:cosmos_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:cosmos_app/features/news/presentation/bloc/news_event.dart';
import 'package:cosmos_app/features/news/presentation/bloc/news_state.dart';

import '../../helpers/pump_app.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockNewsBloc extends MockBloc<NewsEvent, NewsState> implements NewsBloc {}

void main() {
  late MockHomeCubit mockHomeCubit;
  late MockNewsBloc mockNewsBloc;

  setUp(() {
    mockHomeCubit = MockHomeCubit();
    when(() => mockHomeCubit.state).thenReturn(HomeLoading());
    when(() => mockHomeCubit.load()).thenAnswer((_) async {});

    mockNewsBloc = MockNewsBloc();
    when(() => mockNewsBloc.state).thenReturn(NewsInitial());

    final sl = GetIt.instance;
    if (sl.isRegistered<HomeCubit>()) sl.unregister<HomeCubit>();
    if (sl.isRegistered<NewsBloc>()) sl.unregister<NewsBloc>();
    sl.registerFactory<HomeCubit>(() => mockHomeCubit);
    sl.registerFactory<NewsBloc>(() => mockNewsBloc);
  });

  tearDown(() {
    final sl = GetIt.instance;
    if (sl.isRegistered<HomeCubit>()) sl.unregister<HomeCubit>();
    if (sl.isRegistered<NewsBloc>()) sl.unregister<NewsBloc>();
  });

  group('RootPage', () {
    testWidgets('should render with bottom navigation bar', (tester) async {
      await tester.pumpApp(const RootPage());

      expect(find.byType(AppBottomNavigation), findsOneWidget);
      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('should show Home tab initially', (tester) async {
      await tester.pumpApp(const RootPage());

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 0);
    });

    testWidgets('should switch to News tab when tapped', (tester) async {
      await tester.pumpApp(const RootPage());

      await tester.tap(find.byIcon(Icons.article_outlined));
      await tester.pump();

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 1);
    });

    testWidgets('should switch to Quiz tab when tapped', (tester) async {
      await tester.pumpApp(const RootPage());

      await tester.tap(find.byIcon(Icons.quiz_outlined));
      await tester.pump();

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 2);
    });

    testWidgets('should switch to Settings tab when tapped', (tester) async {
      await tester.pumpApp(const RootPage());

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pump();

      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 3);
    });
  });
}
