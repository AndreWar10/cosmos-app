import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/core/theme/theme_cubit.dart';

import '../../helpers/mock_app_cache.dart';

void main() {
  group('ThemeCubit', () {
    late MockAppCache cache;
    late ThemeCubit cubit;

    setUp(() {
      cache = MockAppCache();
      cubit = ThemeCubit(cache);
    });
    tearDown(() => cubit.close());

    test('initial state should be ThemeMode.dark', () {
      expect(cubit.state, ThemeMode.dark);
    });

    test('isDark should return true when state is dark', () {
      expect(cubit.isDark, isTrue);
    });

    test('should load light theme from cache', () {
      final prefilledCache = MockAppCache();
      prefilledCache.setString('app_theme_mode', 'light');
      final c = ThemeCubit(prefilledCache);
      expect(c.state, ThemeMode.light);
      c.close();
    });

    test('should persist theme to cache on toggle', () {
      cubit.toggleTheme();
      expect(cache.getString('app_theme_mode'), 'light');
      cubit.toggleTheme();
      expect(cache.getString('app_theme_mode'), 'dark');
    });

    blocTest<ThemeCubit, ThemeMode>(
      'should emit ThemeMode.light when toggleTheme is called from dark',
      build: () => ThemeCubit(MockAppCache()),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'should emit ThemeMode.dark when toggleTheme is called from light',
      build: () => ThemeCubit(MockAppCache()),
      act: (cubit) {
        cubit.toggleTheme();
        cubit.toggleTheme();
      },
      expect: () => [ThemeMode.light, ThemeMode.dark],
    );
  });
}
