import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/core/locale/locale_cubit.dart';
import 'package:cosmos_app/core/locale/locale_provider.dart';

import '../../helpers/mock_app_cache.dart';

void main() {
  group('LocaleCubit', () {
    late LocaleProvider localeProvider;
    late MockAppCache cache;
    late LocaleCubit cubit;

    setUp(() {
      localeProvider = LocaleProvider();
      cache = MockAppCache();
      cubit = LocaleCubit(localeProvider, cache);
    });
    tearDown(() => cubit.close());

    test('should use system locale when no cache exists', () {
      final systemCode = PlatformDispatcher.instance.locale.languageCode;
      final expected = {'pt', 'en'}.contains(systemCode) ? systemCode : 'en';
      expect(cubit.state.languageCode, expected);
    });

    test('should load locale from cache when saved', () {
      final prefilledCache = MockAppCache();
      prefilledCache.setString('app_locale', 'en');
      final c = LocaleCubit(LocaleProvider(), prefilledCache);
      expect(c.state, const Locale('en'));
      c.close();
    });

    test('should sync LocaleProvider on initialization', () {
      final prefilledCache = MockAppCache();
      prefilledCache.setString('app_locale', 'en');
      final provider = LocaleProvider();
      final c = LocaleCubit(provider, prefilledCache);
      expect(provider.languageCode, 'en');
      c.close();
    });

    test('should update LocaleProvider when setLocale is called', () {
      cubit.setLocale(const Locale('en'));
      expect(localeProvider.languageCode, 'en');
    });

    test('should persist locale to cache on setLocale', () {
      cubit.setLocale(const Locale('en'));
      expect(cache.getString('app_locale'), 'en');
    });

    blocTest<LocaleCubit, Locale>(
      'should emit Locale en when setLocale is called with en',
      build: () => LocaleCubit(LocaleProvider(), MockAppCache()),
      act: (cubit) => cubit.setLocale(const Locale('en')),
      expect: () => [const Locale('en')],
    );

    blocTest<LocaleCubit, Locale>(
      'should emit both locales when switching en then back to pt',
      build: () => LocaleCubit(LocaleProvider(), MockAppCache()),
      act: (cubit) {
        cubit.setLocale(const Locale('en'));
        cubit.setLocale(const Locale('pt'));
      },
      expect: () => [const Locale('en'), const Locale('pt')],
    );
  });
}
