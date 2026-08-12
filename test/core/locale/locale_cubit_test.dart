import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/core/locale/locale_cubit.dart';

void main() {
  group('LocaleCubit', () {
    late LocaleCubit cubit;

    setUp(() => cubit = LocaleCubit());
    tearDown(() => cubit.close());

    test('initial state should be Locale pt', () {
      expect(cubit.state, const Locale('pt'));
    });

    test('isPortuguese should return true when locale is pt', () {
      expect(cubit.isPortuguese, isTrue);
    });

    blocTest<LocaleCubit, Locale>(
      'should emit Locale en when setLocale is called with en',
      build: () => LocaleCubit(),
      act: (cubit) => cubit.setLocale(const Locale('en')),
      expect: () => [const Locale('en')],
    );

    blocTest<LocaleCubit, Locale>(
      'should emit Locale pt when switching back from en to pt',
      build: () => LocaleCubit(),
      act: (cubit) {
        cubit.setLocale(const Locale('en'));
        cubit.setLocale(const Locale('pt'));
      },
      expect: () => [const Locale('en'), const Locale('pt')],
    );
  });
}
