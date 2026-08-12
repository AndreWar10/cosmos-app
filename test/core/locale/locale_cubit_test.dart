import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/core/locale/locale_cubit.dart';
import 'package:cosmos_app/core/locale/locale_provider.dart';

void main() {
  group('LocaleCubit', () {
    late LocaleProvider localeProvider;
    late LocaleCubit cubit;

    setUp(() {
      localeProvider = LocaleProvider();
      cubit = LocaleCubit(localeProvider);
    });
    tearDown(() => cubit.close());

    test('initial state should be Locale pt', () {
      expect(cubit.state, const Locale('pt'));
    });

    test('isPortuguese should return true when locale is pt', () {
      expect(cubit.isPortuguese, isTrue);
    });

    test('should update LocaleProvider when setLocale is called', () {
      cubit.setLocale(const Locale('en'));
      expect(localeProvider.languageCode, 'en');
    });

    blocTest<LocaleCubit, Locale>(
      'should emit Locale en when setLocale is called with en',
      build: () => LocaleCubit(LocaleProvider()),
      act: (cubit) => cubit.setLocale(const Locale('en')),
      expect: () => [const Locale('en')],
    );

    blocTest<LocaleCubit, Locale>(
      'should emit Locale pt when switching back from en to pt',
      build: () => LocaleCubit(LocaleProvider()),
      act: (cubit) {
        cubit.setLocale(const Locale('en'));
        cubit.setLocale(const Locale('pt'));
      },
      expect: () => [const Locale('en'), const Locale('pt')],
    );
  });
}
