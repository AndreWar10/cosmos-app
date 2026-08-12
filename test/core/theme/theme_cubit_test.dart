import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/core/theme/theme_cubit.dart';

void main() {
  group('ThemeCubit', () {
    late ThemeCubit cubit;

    setUp(() => cubit = ThemeCubit());
    tearDown(() => cubit.close());

    test('initial state should be ThemeMode.dark', () {
      expect(cubit.state, ThemeMode.dark);
    });

    test('isDark should return true when state is dark', () {
      expect(cubit.isDark, isTrue);
    });

    blocTest<ThemeCubit, ThemeMode>(
      'should emit ThemeMode.light when toggleTheme is called from dark',
      build: () => ThemeCubit(),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'should emit ThemeMode.dark when toggleTheme is called from light',
      build: () => ThemeCubit(),
      act: (cubit) {
        cubit.toggleTheme();
        cubit.toggleTheme();
      },
      expect: () => [ThemeMode.light, ThemeMode.dark],
    );
  });
}
