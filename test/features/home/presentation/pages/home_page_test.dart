import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';

import 'package:cosmos_app/features/home/presentation/pages/home_page.dart';
import 'package:cosmos_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:cosmos_app/features/home/presentation/cubit/home_state.dart';

import '../../../../helpers/pump_app.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

void main() {
  late MockHomeCubit mockHomeCubit;

  setUp(() {
    mockHomeCubit = MockHomeCubit();
    when(() => mockHomeCubit.state).thenReturn(HomeLoading());
    when(() => mockHomeCubit.load()).thenAnswer((_) async {});

    final sl = GetIt.instance;
    if (sl.isRegistered<HomeCubit>()) sl.unregister<HomeCubit>();
    sl.registerFactory<HomeCubit>(() => mockHomeCubit);
  });

  tearDown(() {
    final sl = GetIt.instance;
    if (sl.isRegistered<HomeCubit>()) sl.unregister<HomeCubit>();
  });

  group('HomePage', () {
    testWidgets('should render with app bar title', (tester) async {
      await tester.pumpApp(const HomePage());

      expect(find.text('Cosmos'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
