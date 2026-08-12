import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/core/navigation/presentation/cubit/navigation_cubit.dart';

void main() {
  group('NavigationCubit', () {
    late NavigationCubit cubit;

    setUp(() => cubit = NavigationCubit());
    tearDown(() => cubit.close());

    test('initial state should be 0', () {
      expect(cubit.state, 0);
    });

    blocTest<NavigationCubit, int>(
      'should emit new index when setTab is called',
      build: () => NavigationCubit(),
      act: (cubit) => cubit.setTab(2),
      expect: () => [2],
    );

    blocTest<NavigationCubit, int>(
      'should not emit when setTab is called with the same index',
      build: () => NavigationCubit(),
      act: (cubit) => cubit.setTab(0),
      expect: () => [],
    );

    blocTest<NavigationCubit, int>(
      'should emit sequential tab changes',
      build: () => NavigationCubit(),
      act: (cubit) {
        cubit.setTab(1);
        cubit.setTab(3);
        cubit.setTab(0);
      },
      expect: () => [1, 3, 0],
    );
  });
}
